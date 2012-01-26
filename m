Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2AZCgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 21:36:14 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54866 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2AZCgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 21:36:13 -0500
Date: Wed, 25 Jan 2012 21:36:09 -0500 (EST)
Message-Id: <20120125.213609.1699401522361877843.davem@davemloft.net>
To: steweg@ynet.sk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v1, kernel 3.2.1] RTNETLINK adjusting values of
 min_ifinfo_dump_size
From: David Miller <davem@davemloft.net>
In-Reply-To: <26709175.701327480995351.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <30372884.681327480899559.JavaMail.root@5-MeO-DMT.ynet.sk>
	<26709175.701327480995351.JavaMail.root@5-MeO-DMT.ynet.sk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 Jan 2012 18:36:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Gula <steweg@ynet.sk>
Date: Wed, 25 Jan 2012 09:43:15 +0100 (CET)

> From: Stefan Gula <steweg@gmail.com>
> 
> This patch extends the rtnetlink.c. The problem is that calcit, which
> returns the value min_ifinfo_dump_size, is called without ability to
> get device info as well (struct net_device *dev is not accessible from
> it). This create a problem if required size of struct sk_buff *skb is
> not enough big to comply with all data returned by fill_info function
> for the interface that required size can vary over time, e.g. some
> dynamic structures will be putted to skb like hlists or lists. To do
> this patch extends the do_setlink function with recalculating of
> min_ifinfo_dump_size accordingly to device type and get_size
> functions.
> 
> Signed-off-by: Stefan Gula <steweg@gmail.com>

This commit message is terrible, and the reason I know it's terrible
is because even after reading it I still had to go read the code
in order to understand what your change even does or why it's even
necessary.

How about this:

	Setting link parameters on a netdevice changes the value
	of if_nlmsg_size(), therefore it is necessary to recalculate
	min_ifinfo_dump_size.

