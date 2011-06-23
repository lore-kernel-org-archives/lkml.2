Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab1FWRW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:22:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:63069 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab1FWRWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Kashyap, Desai" <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 033/247] mpt2sas: Fix device removal handshake for zoned devices
Date: Thu, 23 Jun 2011 13:17:56 -0400
Message-Id: <1308849690-14530-34-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kashyap, Desai <kashyap.desai@lsi.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4dc2757a2e9a9d1f2faee4fc6119276fc0061c16 upstream.

When zoning end devices, the driver is not sending device
removal handshake alogrithm to firmware. This results in controller
firmware not sending sas topology add events the next time the device is
added. The fix is the driver should be doing the device removal handshake
even though the PHYSTATUS_VACANT bit is set in the PhyStatus of the
event data. The current design is avoiding the handshake when the
VACANT bit is set in the phy status.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index be171ed..87cf0d2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2818,9 +2818,6 @@ _scsih_check_topo_delete_events(struct MPT2SAS_ADAPTER *ioc,
 	u16 handle;
 
 	for (i = 0 ; i < event_data->NumEntries; i++) {
-		if (event_data->PHY[i].PhyStatus &
-		    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT)
-			continue;
 		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
 		if (!handle)
 			continue;
-- 
1.7.4.4

