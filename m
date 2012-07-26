Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab2GZTIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 15:08:07 -0400
Received: from mail.tpi.com ([70.99.223.143]:3951 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab2GZTIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 15:08:06 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Jon Mason <jdmason@kudzu.us>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Jiri Pirko <jpirko@redhat.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, netdev@vger.kernel.org
Subject: [PATCH] vxge: Declare MODULE_FIRMWARE usage
Date: Thu, 26 Jul 2012 13:08:30 -0600
Message-Id: <1343329710-96747-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jon Mason <jdmason@kudzu.us>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Joe Perches <joe@perches.com>
Cc: Jiri Pirko <jpirko@redhat.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index de21904..d4832b2 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -4203,6 +4203,9 @@ out:
 	return ret;
 }
 
+#define VXGE_PXE_FIRMWARE "vxge/X3fw-pxe.ncf"
+#define VXGE_FIRMWARE "vxge/X3fw.ncf"
+
 static int vxge_probe_fw_update(struct vxgedev *vdev)
 {
 	u32 maj, min, bld;
@@ -4245,9 +4248,9 @@ static int vxge_probe_fw_update(struct vxgedev *vdev)
 			}
 	}
 	if (gpxe)
-		fw_name = "vxge/X3fw-pxe.ncf";
+		fw_name = VXGE_PXE_FIRMWARE;
 	else
-		fw_name = "vxge/X3fw.ncf";
+		fw_name = VXGE_FIRMWARE;
 
 	ret = vxge_fw_upgrade(vdev, fw_name, 0);
 	/* -EINVAL and -ENOENT are not fatal errors for flashing firmware on
@@ -4855,3 +4858,5 @@ vxge_closer(void)
 }
 module_init(vxge_starter);
 module_exit(vxge_closer);
+MODULE_FIRMWARE(VXGE_PXE_FIRMWARE);
+MODULE_FIRMWARE(VXGE_FIRMWARE);
-- 
1.7.9.5

