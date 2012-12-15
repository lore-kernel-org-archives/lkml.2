Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab2LOUix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 15:38:53 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53293 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab2LOUiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 15:38:51 -0500
MIME-Version: 1.0
Date: Sun, 16 Dec 2012 02:08:50 +0530
Message-ID: <CAA_L+UP_CtY4wTnOGASwqb9PJnb9XyGpGauTKk6=wssagg1GPw@mail.gmail.com>
Subject: [PATCH 3.7.0 1/9] i82975x_edac.c: fix style errors
From: Arvind R <arvino55@gmail.com>
To: linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3.7.0 1/9] i82975x_edac.c: fix style errors

splits or shortens extra long lines in source.
Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 i82975x_edac.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/edac/i82975x_edac.c	2012-12-11 09:00:57 +0530
+++ b/drivers/edac/i82975x_edac.c	2012-12-15 16:01:29 +0530
@@ -48,7 +48,7 @@
 #define I82975X_DES		0x5d	/* Dram ERRor DeSTination (8b)
 					 * 0h:    Processor Memory Reads
 					 * 1h:7h  reserved
-					 * More - See Page 65 of Intel DocSheet.
+					 * More - See Pg.65 of Intel DocSheet.
 					 */

 #define I82975X_ERRSTS		0xc8	/* Error Status Register (16b)
@@ -98,7 +98,7 @@ NOTE: Only ONE of the three must be enab
 #define I82975X_XEAP	0xfc	/* Extended Dram Error Address Pointer (8b)
 					 *
 					 * 7:1   reserved
-					 * 0     Bit32 of the Dram Error Address
+					 * 0     Bit32 of Dram Error Address
 					 */

 #define I82975X_MCHBAR		0x44	/*
@@ -305,13 +305,13 @@ static int i82975x_process_error_info(st
 			"\tXEAP=%u\n"
 			"\t EAP=0x%08x\n"
 			"\tPAGE=0x%08x\n",
-			(info->xeap & 1) ? 1 : 0, info->eap, (unsigned int) page);
+			(info->xeap & 1) ? 1 : 0, info->eap, (unsigned) page);
 		return 0;
 	}
 	chan = (mci->csrows[row]->nr_channels == 1) ? 0 : info->eap & 1;
 	offst = info->eap
 			& ((1 << PAGE_SHIFT) -
-			   (1 << mci->csrows[row]->channels[chan]->dimm->grain));
+			(1 << mci->csrows[row]->channels[chan]->dimm->grain));

 	if (info->errsts & 0x0002)
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
@@ -420,12 +420,13 @@ static void i82975x_init_csrows(struct m

 			dimm->nr_pages = nr_pages / csrow->nr_channels;

-			snprintf(csrow->channels[chan]->dimm->label, EDAC_MC_LABEL_LEN, "DIMM %c%d",
+			snprintf(csrow->channels[chan]->dimm->label,
+				 EDAC_MC_LABEL_LEN, "DIMM %c%d",
 				 (chan == 0) ? 'A' : 'B',
 				 index);
-			dimm->grain = 1 << 7;	/* 128Byte cache-line resolution */
+			dimm->grain = 1 << 7;	/* always */
 			dimm->dtype = i82975x_dram_type(mch_window, index);
-			dimm->mtype = MEM_DDR2; /* I82975x supports only DDR2 */
+			dimm->mtype = MEM_DDR2; /* only supported */
 			dimm->edac_mode = EDAC_SECDED; /* only supported */
 		}
