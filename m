Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0KXXdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:33:42 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:44924 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab0KXXdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:33:41 -0500
From: Jay Vosburgh <fubar@us.ibm.com>
To: David Strand <dpstrand@gmail.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding: check for assigned mac before adopting the slaves mac address
In-reply-to: <AANLkTinpO=FmoecfV8epubXU4OrhFsXJ7-Kc68yNhMEs@mail.gmail.com>
References: <AANLkTinpO=FmoecfV8epubXU4OrhFsXJ7-Kc68yNhMEs@mail.gmail.com>
Comments: In-reply-to David Strand <dpstrand@gmail.com>
   message dated "Wed, 24 Nov 2010 15:12:14 -0800."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Wed, 24 Nov 2010 15:33:37 -0800
Message-ID: <31169.1290641617@death>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Strand <dpstrand@gmail.com> wrote:

>Restore the check for a missing mac address before adopting the first
>slaves as it's own. This regression was introduced in:
>http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.36.y.git;a=commit;h=c20811a79e671a6a1fe86a8c1afe04aca8a7f085

	How exactly is this a regression?  The above referenced patch
changes the method used to decide if the bonding master needs to have
it's MAC address set.  The original way was "bonding master's MAC is
zero," after the above, it's "adding first slave."

	Do you have some use case that manually sets the master's MAC
address prior to adding any slaves?

	-J

>Signed-off-by: David Strand dpstrand@gmail.com
>---
>diff -uprN a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>--- a/drivers/net/bonding/bond_main.c	2010-11-24 11:36:58.125640000 -0800
>+++ b/drivers/net/bonding/bond_main.c	2010-11-24 11:40:58.175640000 -0800
>@@ -1577,8 +1577,9 @@ int bond_enslave(struct net_device *bond
> 	/* If this is the first slave, then we need to set the master's hardware
> 	 * address to be the same as the slave's. */
> 	if (bond->slave_cnt == 0)
>-		memcpy(bond->dev->dev_addr, slave_dev->dev_addr,
>-		       slave_dev->addr_len);
>+		if (is_zero_ether_addr(bond->dev->dev_addr))
>+			memcpy(bond->dev->dev_addr, slave_dev->dev_addr,
>+			       slave_dev->addr_len);
>
>
> 	new_slave = kzalloc(sizeof(struct slave), GFP_KERNEL);

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
