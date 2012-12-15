Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2LOUjs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 15:39:48 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60601 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2LOUjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 15:39:47 -0500
MIME-Version: 1.0
Date: Sun, 16 Dec 2012 02:09:46 +0530
Message-ID: <CAA_L+UPsAGmRB_gEittUOag0Hu1565jbvfNGsROj9n0x41W21Q@mail.gmail.com>
Subject: [PATCH 3.7.0 2/9] i82975x_edac.c: fix layers initialisation
From: Arvind R <arvino55@gmail.com>
To: linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3.7.0 2/9] i82975x_edac.c: fix layers initialisation

correct the absolutely wrong initialisation of memory layout.
Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 i82975x_edac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/edac/i82975x_edac.c	2012-12-15 16:17:28 +0530
+++ b/drivers/edac/i82975x_edac.c	2012-12-15 16:16:51 +0530
@@ -544,10 +544,10 @@ static int i82975x_probe1(struct pci_dev

 	/* assuming only one controller, index thus is 0 */
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
-	layers[0].size = I82975X_NR_DIMMS;
+	layers[0].size = I82975X_NR_CSROWS(chans);
 	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
-	layers[1].size = I82975X_NR_CSROWS(chans);
+	layers[1].size = chans;
 	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, sizeof(*pvt));
 	if (!mci) {
