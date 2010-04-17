Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab0DQLsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 07:48:06 -0400
Received: from silke.schedom-europe.net ([193.109.184.88]:53137 "EHLO
	silke.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab0DQLsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 07:48:04 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Apr 2010 07:48:04 EDT
From: Stijn Tintel <stijn@linux-ipv6.be>
To: rusty@rustcorp.com.au
Cc: akpm@linux-foundation.org, davem@davemloft.net, damm@opensource.se,
       mst@redhat.com, khali@linux-fr.org, linux-kernel@vger.kernel.org
Subject: [PATCH] virtio: initialize earlier
Date: Sat, 17 Apr 2010 13:41:13 +0200
Message-Id: <1271504473-10143-1-git-send-email-stijn@linux-ipv6.be>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move initialization of the virtio framework before the initialization of
mtd, so that block2mtd can be used on virtio-based block devices.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=15644

Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
---
 drivers/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index 34f1e10..f42a030 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_SFI)		+= sfi/
 obj-$(CONFIG_PNP)		+= pnp/
 obj-$(CONFIG_ARM_AMBA)		+= amba/
 
+obj-$(CONFIG_VIRTIO)		+= virtio/
 obj-$(CONFIG_XEN)		+= xen/
 
 # regulators early, since some subsystems rely on them to initialize
@@ -108,7 +109,6 @@ obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_OF)		+= of/
 obj-$(CONFIG_SSB)		+= ssb/
 obj-$(CONFIG_VHOST_NET)		+= vhost/
-obj-$(CONFIG_VIRTIO)		+= virtio/
 obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
 obj-y				+= platform/
-- 
1.6.4.4

