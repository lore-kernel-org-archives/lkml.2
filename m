Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab1HLGH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 02:07:59 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44273 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab1HLGH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 02:07:56 -0400
Date: Thu, 11 Aug 2011 23:05:52 -0700 (PDT)
Message-Id: <20110811.230552.837691497153518712.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next] spider_net: fix compile issue introduced by driver
 move
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110811.230017.1431877798231142541.davem@davemloft.net>
References: <20110812144131.59de312ee6e1a9e8865c1a85@canb.auug.org.au>
	<20110812150003.1e2ba71018bea040fc7649d7@canb.auug.org.au>
	<20110811.230017.1431877798231142541.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 11 Aug 2011 23:05:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 11 Aug 2011 23:00:17 -0700 (PDT)

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 12 Aug 2011 15:00:03 +1000
> 
>> However, Dave, I now get these (powerpc ppc64defconfig build of just the
>> net tree):
> 
> This should fix the cxgbi scsi problems, I'll work on the mlx4 ones
> next.

And this one will fix the mlx4 infiniband problems, thanks Stephen.

--------------------
>From af3dcd2f449b7243a4c7b987125ffc40fad262f0 Mon Sep 17 00:00:00 2001
From: "David S. Miller" <davem@davemloft.net>
Date: Thu, 11 Aug 2011 23:05:05 -0700
Subject: [PATCH] mlx4: Fix infiniband Kconfig dependencies.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/infiniband/hw/mlx4/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/Kconfig b/drivers/infiniband/hw/mlx4/Kconfig
index bd995b2..24ab11a 100644
--- a/drivers/infiniband/hw/mlx4/Kconfig
+++ b/drivers/infiniband/hw/mlx4/Kconfig
@@ -1,6 +1,7 @@
 config MLX4_INFINIBAND
 	tristate "Mellanox ConnectX HCA support"
-	depends on NETDEVICES && NETDEV_10000 && PCI
+	depends on NETDEVICES && ETHERNET && PCI
+	select NET_VENDOR_MELLANOX
 	select MLX4_CORE
 	---help---
 	  This driver provides low-level InfiniBand support for
-- 
1.7.6

