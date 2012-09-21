Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab2IUMLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:11:14 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:3412 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931Ab2IUMLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:11:12 -0400
Message-ID: <1348229466.1581.21.camel@x61.thuisdomein>
Subject: [PATCH] mvsas: use correct named constants
From: Paul Bolle <pebolle@tiscali.nl>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 21 Sep 2012 14:11:06 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2012 12:11:07.0248 (UTC) FILETIME=[2DF45700:01CD97F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building the mvsas driver triggers these GCC warnings:
    drivers/scsi/mvsas/mv_sas.c:1156:34: warning: comparison between 'enum sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]
    drivers/scsi/mvsas/mv_sas.c:1159:39: warning: comparison between 'enum sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]

Silence these warnings by using the named constants from enum
sas_device_type with the same value as the currently used named
constants.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I noticed these warnings while building v3.6-rc6 on current Fedora
17, using Fedora's default config.

1) Compile tested only.

 drivers/scsi/mvsas/mv_sas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 4539d59..f663d9a 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1153,10 +1153,10 @@ void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st)
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
1.7.11.4

