Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2DCLGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:06:49 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:33441 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab2DCLGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:06:47 -0400
Date: Tue, 3 Apr 2012 14:06:44 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: James Smart <james.smart@emulex.com>
cc: linux-scsi@vgerkkernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix lpfc compilation without debugfs
Message-ID: <alpine.SOC.1.00.1204031401350.23847@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-rc1-104 fails to compile with

  CC [M]  drivers/scsi/lpfc/lpfc_scsi.o
drivers/scsi/lpfc/lpfc_scsi.c: In function ¡lpfc_bg_setup_bpl¢:
drivers/scsi/lpfc/lpfc_scsi.c:1900:11: error: unused variable ¡rc¢ [-Werror=unused-variable]
drivers/scsi/lpfc/lpfc_scsi.c: In function ¡lpfc_bg_setup_bpl_prot¢:
drivers/scsi/lpfc/lpfc_scsi.c:2037:11: error: unused variable ¡rc¢ [-Werror=unused-variable]
drivers/scsi/lpfc/lpfc_scsi.c: In function ¡lpfc_bg_setup_sgl¢:
drivers/scsi/lpfc/lpfc_scsi.c:2256:11: error: unused variable ¡rc¢ [-Werror=unused-variable]
drivers/scsi/lpfc/lpfc_scsi.c: In function ¡lpfc_bg_setup_sgl_prot¢:
drivers/scsi/lpfc/lpfc_scsi.c:2386:11: error: unused variable ¡rc¢ [-Werror=unused-variable]
cc1: all warnings being treated as errors

rc is used only when debugfs is used, so silence it by guarding rc 
definition by the same #ifdef.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 88f3a83..8817057 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1897,7 +1897,9 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	dma_addr_t physaddr;
 	int i = 0, num_bde = 0, status;
 	int datadir = sc->sc_data_direction;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t rc;
+#endif
 	uint32_t checking = 1;
 	uint32_t reftag;
 	unsigned blksize;
@@ -2034,7 +2036,9 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	int datadir = sc->sc_data_direction;
 	unsigned char pgdone = 0, alldone = 0;
 	unsigned blksize;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t rc;
+#endif
 	uint32_t checking = 1;
 	uint32_t reftag;
 	uint8_t txop, rxop;
@@ -2253,7 +2257,9 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	uint32_t reftag;
 	unsigned blksize;
 	uint8_t txop, rxop;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t rc;
+#endif
 	uint32_t checking = 1;
 	uint32_t dma_len;
 	uint32_t dma_offset = 0;
@@ -2383,7 +2389,9 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	uint32_t reftag;
 	uint8_t txop, rxop;
 	uint32_t dma_len;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t rc;
+#endif
 	uint32_t checking = 1;
 	uint32_t dma_offset = 0;
 	int num_sge = 0;

-- 
Meelis Roos (mroos@linux.ee)
