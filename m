Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab2KLW3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 17:29:22 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:47155 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751212Ab2KLW3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 17:29:21 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18/KNlxanA/dP3dQGyimfve1UdyE0IaKg4aMqcpnr
	Yg4Wt+qo+HDy5C
From: Peter Huewe <peterhuewe@gmx.de>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 1/2] char/tpm: Remove duplicated lookup table
Date: Mon, 12 Nov 2012 23:37:17 +0100
Message-Id: <1352759838-27175-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The entries in tpm_protected_ordinal_duration are exactly the same as
the first 12 in tpm_ordinal_duration, so we can simply remove this one,
and save some bytes.

This does not change the behavior of the driver.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
This patch reflects only my opinion and work, 
and is not related to my employer or anybody else.

 drivers/char/tpm/tpm.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 93211df..9e3c529 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -65,21 +65,6 @@ static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
  * values of the SHORT, MEDIUM, and LONG durations are retrieved
  * from the chip during initialization with a call to tpm_get_timeouts.
  */
-static const u8 tpm_protected_ordinal_duration[TPM_MAX_PROTECTED_ORDINAL] = {
-	TPM_UNDEFINED,		/* 0 */
-	TPM_UNDEFINED,
-	TPM_UNDEFINED,
-	TPM_UNDEFINED,
-	TPM_UNDEFINED,
-	TPM_UNDEFINED,		/* 5 */
-	TPM_UNDEFINED,
-	TPM_UNDEFINED,
-	TPM_UNDEFINED,
-	TPM_UNDEFINED,
-	TPM_SHORT,		/* 10 */
-	TPM_SHORT,
-};
-
 static const u8 tpm_ordinal_duration[TPM_MAX_ORDINAL] = {
 	TPM_UNDEFINED,		/* 0 */
 	TPM_UNDEFINED,
@@ -357,8 +342,7 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
 	else if ((ordinal & TPM_PROTECTED_ORDINAL_MASK) <
 		 TPM_MAX_PROTECTED_ORDINAL)
 		duration_idx =
-		    tpm_protected_ordinal_duration[ordinal &
-						   TPM_PROTECTED_ORDINAL_MASK];
+		    tpm_ordinal_duration[ordinal & TPM_PROTECTED_ORDINAL_MASK];
 
 	if (duration_idx != TPM_UNDEFINED)
 		duration = chip->vendor.duration[duration_idx];
-- 
1.7.8.6

