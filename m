Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1HLGCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 02:02:36 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37769 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab1HLGCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 02:02:30 -0400
Date: Thu, 11 Aug 2011 23:00:17 -0700 (PDT)
Message-Id: <20110811.230017.1431877798231142541.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next] spider_net: fix compile issue introduced by driver
 move
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110812150003.1e2ba71018bea040fc7649d7@canb.auug.org.au>
References: <1313120415.2029.3.camel@jtkirshe-mobl>
	<20110812144131.59de312ee6e1a9e8865c1a85@canb.auug.org.au>
	<20110812150003.1e2ba71018bea040fc7649d7@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 11 Aug 2011 23:00:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 12 Aug 2011 15:00:03 +1000

> However, Dave, I now get these (powerpc ppc64defconfig build of just the
> net tree):

This should fix the cxgbi scsi problems, I'll work on the mlx4 ones
next.

Thanks.

>From b6a0e86efb79b8ee71cb2129f3ad384d7efc22e3 Mon Sep 17 00:00:00 2001
From: "David S. Miller" <davem@davemloft.net>
Date: Thu, 11 Aug 2011 22:59:31 -0700
Subject: [PATCH] cxgbi: Fix scsi Kconfig dependencies.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/scsi/cxgbi/cxgb3i/Kconfig |    3 ++-
 drivers/scsi/cxgbi/cxgb4i/Kconfig |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/Kconfig b/drivers/scsi/cxgbi/cxgb3i/Kconfig
index 11dff23..6bbc36f 100644
--- a/drivers/scsi/cxgbi/cxgb3i/Kconfig
+++ b/drivers/scsi/cxgbi/cxgb3i/Kconfig
@@ -2,7 +2,8 @@ config SCSI_CXGB3_ISCSI
 	tristate "Chelsio T3 iSCSI support"
 	depends on PCI && INET
 	select NETDEVICES
-	select NETDEV_10000
+	select ETHERNET
+	select NET_VENDOR_CHELSIO
 	select CHELSIO_T3
 	select SCSI_ISCSI_ATTRS
 	---help---
diff --git a/drivers/scsi/cxgbi/cxgb4i/Kconfig b/drivers/scsi/cxgbi/cxgb4i/Kconfig
index d5302c2..16b2c7d 100644
--- a/drivers/scsi/cxgbi/cxgb4i/Kconfig
+++ b/drivers/scsi/cxgbi/cxgb4i/Kconfig
@@ -2,7 +2,8 @@ config SCSI_CXGB4_ISCSI
 	tristate "Chelsio T4 iSCSI support"
 	depends on PCI && INET
 	select NETDEVICES
-	select NETDEV_10000
+	select ETHERNET
+	select NET_VENDOR_CHELSIO
 	select CHELSIO_T4
 	select SCSI_ISCSI_ATTRS
 	---help---
-- 
1.7.6

