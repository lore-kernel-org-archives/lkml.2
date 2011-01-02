Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab1ABH0I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:26:08 -0500
Received: from mail.windriver.com ([147.11.1.11]:37217 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab1ABH0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:26:02 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, David Milburn <dmilburn@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 256/260] libsas: fix NCQ mixing with non-NCQ
Date: Sun,  2 Jan 2011 02:19:12 -0500
Message-Id: <1293952756-15010-257-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:49.0449 (UTC) FILETIME=[23C53990:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Milburn <dmilburn@redhat.com>

commit f0ad30d3d2dc924decc0e10b1ff6dc32525a5d99 upstream.

Some cards (like mvsas) have issue troubles if non-NCQ commands are
mixed with NCQ ones.  Fix this by using the libata default NCQ check
routine which waits until all NCQ commands are complete before issuing
a non-NCQ one.  The impact to cards (like aic94xx) which don't need
this logic should be minimal

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/libsas/sas_ata.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 8c496b5..fb78856 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -347,6 +347,7 @@ static int sas_ata_scr_read(struct ata_link *link, unsigned int sc_reg_in,
 static struct ata_port_operations sas_sata_ops = {
 	.phy_reset		= sas_ata_phy_reset,
 	.post_internal_cmd	= sas_ata_post_internal,
+	.qc_defer               = ata_std_qc_defer,
 	.qc_prep		= ata_noop_qc_prep,
 	.qc_issue		= sas_ata_qc_issue,
 	.qc_fill_rtf		= sas_ata_qc_fill_rtf,
-- 
1.7.3.3

