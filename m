Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1GGLB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:01:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41907 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab1GGLBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:01:54 -0400
Date: Thu, 07 Jul 2011 04:01:49 -0700 (PDT)
Message-Id: <20110707.040149.441417258943576903.davem@davemloft.net>
To: mashirle@us.ibm.com
Cc: mst@redhat.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V8 2/4 net-next] skbuff: skb supports zero-copy buffers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1309990932.10209.19.camel@localhost.localdomain>
References: <1309990932.10209.19.camel@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 07 Jul 2011 04:01:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shirley Ma <mashirle@us.ibm.com>
Date: Wed, 06 Jul 2011 15:22:12 -0700

> +			while (head) {
> +				put_page(head);
> +				head = (struct page *)head->private;
> +			}

Looks like you might be referencing the page after it's
release here.  I think you need something like:

			while (head) {
				struct page *next = (struct page *)head->private;
				put_page(head);
				head = next;
			}
