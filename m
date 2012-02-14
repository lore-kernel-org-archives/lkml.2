Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757Ab2BNOkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:40:47 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:52526 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756666Ab2BNOko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:40:44 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Xiangliang Yu <yuxiangl@marvell.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mvsas: fix enum checks
Date: Tue, 14 Feb 2012 15:40:39 +0100
Message-Id: <1329230439-26976-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329230444;b496f20e;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for:
drivers/scsi/mvsas/mv_sas.c: In function ‘mvs_update_phyinfo’:
drivers/scsi/mvsas/mv_sas.c:1163:34: warning: comparison between
  ‘enum sas_device_type’ and ‘enum sas_dev_type’ [-Wenum-compare]
drivers/scsi/mvsas/mv_sas.c:1166:39: warning: comparison between
  ‘enum sas_device_type’ and ‘enum sas_dev_type’ [-Wenum-compare]

Changed SAS_END_DEV to SAS_END_DEVICE and NO_DEVICE with
SAS_PHY_UNUSED.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/scsi/mvsas/mv_sas.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a4884a5..7a57780 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1160,10 +1160,10 @@ void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st)
 			phy->identify.device_type =
 				phy->att_dev_info & PORT_DEV_TYPE_MASK;
 
-			if (phy->identify.device_type == SAS_END_DEV)
+			if (phy->identify.device_type == SAS_END_DEVICE)
 				phy->identify.target_port_protocols =
 							SAS_PROTOCOL_SSP;
-			else if (phy->identify.device_type != NO_DEVICE)
+			else if (phy->identify.device_type != SAS_PHY_UNUSED)
 				phy->identify.target_port_protocols =
 							SAS_PROTOCOL_SMP;
 			if (oob_done)
-- 
1.7.7.3

