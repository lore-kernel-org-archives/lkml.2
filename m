Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814Ab2BNOlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:41:05 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:52644 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756666Ab2BNOlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:41:01 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Danny Kukawka <dkukawka@suse.de>, jack_wang@usish.com,
        lindar_liu@usish.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pm8001: fix enum checks
Date: Tue, 14 Feb 2012 15:40:55 +0100
Message-Id: <1329230455-27084-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329230461;0afe932b;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for:
drivers/scsi/pm8001/pm8001_hwi.c: In function ‘hw_event_sas_phy_up’:
drivers/scsi/pm8001/pm8001_hwi.c:2932:32: warning: comparison between
  ‘enum sas_device_type’ and ‘enum sas_dev_type’ [-Wenum-compare]
drivers/scsi/pm8001/pm8001_hwi.c:2934:37: warning: comparison between
  ‘enum sas_device_type’ and ‘enum sas_dev_type’ [-Wenum-compare]

Changed SAS_END_DEV to SAS_END_DEVICE and NO_DEVICE with
SAS_PHY_UNUSED.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/scsi/pm8001/pm8001_hwi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index b7b92f7..46fd7219 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2929,9 +2929,9 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->phy_type |= PORT_TYPE_SAS;
 	phy->identify.device_type = deviceType;
 	phy->phy_attached = 1;
-	if (phy->identify.device_type == SAS_END_DEV)
+	if (phy->identify.device_type == SAS_END_DEVICE)
 		phy->identify.target_port_protocols = SAS_PROTOCOL_SSP;
-	else if (phy->identify.device_type != NO_DEVICE)
+	else if (phy->identify.device_type != SAS_PHY_UNUSED)
 		phy->identify.target_port_protocols = SAS_PROTOCOL_SMP;
 	phy->sas_phy.oob_mode = SAS_OOB_MODE;
 	sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
-- 
1.7.7.3

