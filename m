Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2BDA3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 19:29:40 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57886 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab2BDA3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 19:29:38 -0500
Date: Fri, 03 Feb 2012 19:29:33 -0500 (EST)
Message-Id: <20120203.192933.510206531351047222.davem@davemloft.net>
To: steweg@ynet.sk
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [patch v1, kernel version 3.2.1] rtnetlink workaround around
 the skb buff size issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <10521320.3761328279061644.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <5422254.3711328278789768.JavaMail.root@5-MeO-DMT.ynet.sk>
	<10521320.3761328279061644.JavaMail.root@5-MeO-DMT.ynet.sk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 03 Feb 2012 16:29:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Gula <steweg@ynet.sk>
Date: Fri, 3 Feb 2012 15:24:21 +0100 (CET)

> From: Stefan Gula <steweg@gmail.com>
> 
> Adding new rtnetlink ops and command for getting more information about
> network devices, which are not able to fit inside predefined SKB structures
> (e.g. PAGE_SIZE limit). DEVDUMP command allows to call specific device driver
> code for complete handling this netlink message. Useful if devices needed to
> list some addition dynamic structures like hlists and doesn't require to have
> complete set of codes for it new PF families.
> 
> Signed-off-by: Stefan Gula <steweg@gmail.com>

This is not how we're going to fix this.  I already stated the desired
way to fix this, which is to make the existing dump request have a way
for the requestor to enable extended parts of the device dump.

This is just like netlink diag socket dumps, where the dump request
specifies what the user wants to see.

In this case we'd add a netlink attribute to the dump request which
is just a u32 bitmask or similar.

The Intel engineer who added the VF dump support said he would work on
this fix so why don't you just wait patiently for him to do the work?
