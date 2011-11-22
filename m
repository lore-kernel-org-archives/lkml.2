Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab1KVUyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:54:31 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53816 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1KVUya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:54:30 -0500
Date: Tue, 22 Nov 2011 15:54:26 -0500 (EST)
Message-Id: <20111122.155426.1153643155035648664.davem@davemloft.net>
To: peter.p.waskiewicz.jr@intel.com
Cc: lkml@hover.be, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: softirq oops from b44_poll
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321917453.10276.3.camel@pjaxe>
References: <CAJfGthSxanFbL2vKCpOQbP9K5oNAxeaYt7OMdmdoCb4eLQ_Fww@mail.gmail.com>
	<1321917453.10276.3.camel@pjaxe>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 Nov 2011 12:54:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Date: Mon, 21 Nov 2011 15:17:33 -0800

> I suspect the "right" way to fix this is to call dev_kfree_skb_any(skb);
> instead, since that will handle the in-interrupt case if that's where
> we're stuck.

Caller is always b44_poll(), and that caller always does spin_lock_irqsave().

Adding the extra tests implied by dev_kfree_skb_any() therefore doesn't
make any sense, as it will always evaluate to dev_kfree_skb_irq().
