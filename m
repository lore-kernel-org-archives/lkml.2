Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419Ab1IOTIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:08:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42491 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934293Ab1IOTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:08:42 -0400
Date: Thu, 15 Sep 2011 15:08:22 -0400 (EDT)
Message-Id: <20110915.150822.1432876015378023873.davem@davemloft.net>
To: mst@redhat.com
Cc: herbert@gondor.hengli.com.au, eric.dumazet@gmail.com,
        mirq-linux@rere.qmqm.pl, therbert@google.com, jpirko@redhat.com,
        jesse@nicira.com, xma@us.ibm.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-2.6] net: copy userspace buffers on device
 forwarding
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110831180328.GA22016@redhat.com>
References: <20110831180328.GA22016@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 15 Sep 2011 12:08:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 31 Aug 2011 21:03:29 +0300

> dev_forward_skb loops an skb back into host networking
> stack which might hang on the memory indefinitely.
> In particular, this can happen in macvtap in bridged mode.
> Copy the userspace fragments to avoid blocking the
> sender in that case.
> 
> As this patch makes skb_copy_ubufs extern now,
> I also added some documentation and made it clear
> the SKBTX_DEV_ZEROCOPY flag automatically instead
> of doing it in all callers. This can be made into a separate
> patch if people feel it's worth it.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied.
