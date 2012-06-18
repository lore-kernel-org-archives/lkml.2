Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab2FRAJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 20:09:14 -0400
Received: from mout2.fh-giessen.de ([212.201.18.46]:35021 "EHLO
	mout2.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab2FRAJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 20:09:13 -0400
Message-ID: <4FDE71A4.2090807@mni.thm.de>
Date: Mon, 18 Jun 2012 02:09:08 +0200
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/16.0 Thunderbird/16.0a1
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: james.smart@emulex.com, linux-kernel@vger.kernel.org
Subject: Driver scsi/lpfc breaks build since 3.4.1
Content-Type: multipart/mixed;
 boundary="------------000802090709080508090206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000802090709080508090206
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit

Hello there,
since 3.4.1 the driver scsi/lpfc breaks my build for some unused variables:
drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_bpl’:
drivers/scsi/lpfc/lpfc_scsi.c:1900:11: error: unused variable ‘rc’ 
[-Werror=unused-variable]
drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_bpl_prot’:
drivers/scsi/lpfc/lpfc_scsi.c:2037:11: error: unused variable ‘rc’ 
[-Werror=unused-variable]
drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_sgl’:
drivers/scsi/lpfc/lpfc_scsi.c:2256:11: error: unused variable ‘rc’ 
[-Werror=unused-variable]
drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_sgl_prot’:
drivers/scsi/lpfc/lpfc_scsi.c:2386:11: error: unused variable ‘rc’ 
[-Werror=unused-variable]
cc1: all warnings being treated as errors

 From the drivers makefile:
ccflags-y += -Werror <- this causes the bad behavior.

=> remove this line or the unused variables
=> decided to remove the unused varaibles for 3.4.x and create a patch 
for it. Maybe you want to queue it up for the 3.4.y stable series!

Greetings
Tobias Klausmann

--------------000802090709080508090206
Content-Type: text/x-patch;
 name="lpfc_compile_fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lpfc_compile_fix.diff"

>From 69c2b0224847f6b7f6fb701fe0cb0c5657f1389b Mon Sep 17 00:00:00 2001
From: Tobias Klausmann <tobias.klausmann@mni.thm.de>
Date: Mon, 18 Jun 2012 01:14:55 +0200
Subject: [PATCH] Driver scsi/lpfc: Remove some unused varaibles (Compilefix
 for linux 3.4.1-3.4.x)

---
 drivers/scsi/lpfc/lpfc_scsi.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 88f3a83..7f20599 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1897,7 +1897,6 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	dma_addr_t physaddr;
 	int i = 0, num_bde = 0, status;
 	int datadir = sc->sc_data_direction;
-	uint32_t rc;
 	uint32_t checking = 1;
 	uint32_t reftag;
 	unsigned blksize;
@@ -2034,7 +2033,6 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	int datadir = sc->sc_data_direction;
 	unsigned char pgdone = 0, alldone = 0;
 	unsigned blksize;
-	uint32_t rc;
 	uint32_t checking = 1;
 	uint32_t reftag;
 	uint8_t txop, rxop;
@@ -2253,7 +2251,6 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	uint32_t reftag;
 	unsigned blksize;
 	uint8_t txop, rxop;
-	uint32_t rc;
 	uint32_t checking = 1;
 	uint32_t dma_len;
 	uint32_t dma_offset = 0;
@@ -2383,7 +2380,6 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	uint32_t reftag;
 	uint8_t txop, rxop;
 	uint32_t dma_len;
-	uint32_t rc;
 	uint32_t checking = 1;
 	uint32_t dma_offset = 0;
 	int num_sge = 0;
-- 
1.7.7


--------------000802090709080508090206--
