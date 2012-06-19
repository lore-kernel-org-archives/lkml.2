Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2FSLwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:52:46 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:3991 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550Ab2FSLwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:52:44 -0400
Message-ID: <1340106762.1936.25.camel@x61.thuisdomein>
Subject: [PATCH] mtd: chips: reorganize Kconfig help on swapping
From: Paul Bolle <pebolle@tiscali.nl>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Jun 2012 13:52:42 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 19 Jun 2012 11:52:42.0882 (UTC) FILETIME=[08DEF620:01CD4E12]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig help on "Flash cmd/query data swapping" still mentions
LART_ENDIAN_BYTE. That option used to be relevant for setting
CONFIG_MTD_CFI_LART_BIT_SWAP. That option and macro got both removed in
v2.4.11-pre4. So, although LART endianness sounds intriguing, that part
of the help text can be removed.

And, while we're touching this choice, move the help text up one level.
Currently it's available under the "NO" option, while it's relevant for
all three options.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested only with "make menuconfig".

1) Triggers a checkpatch warning: "please write a paragraph that
describes the config symbol fully". That's a bit of a false positive
here (also see the comment starting at line 1708 in checkpatch.pl).

 drivers/mtd/chips/Kconfig |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/chips/Kconfig b/drivers/mtd/chips/Kconfig
index b1e3c26..e469b01 100644
--- a/drivers/mtd/chips/Kconfig
+++ b/drivers/mtd/chips/Kconfig
@@ -43,9 +43,6 @@ choice
 	prompt "Flash cmd/query data swapping"
 	depends on MTD_CFI_ADV_OPTIONS
 	default MTD_CFI_NOSWAP
-
-config MTD_CFI_NOSWAP
-	bool "NO"
 	---help---
 	  This option defines the way in which the CPU attempts to arrange
 	  data bits when writing the 'magic' commands to the chips. Saying
@@ -55,12 +52,8 @@ config MTD_CFI_NOSWAP
 	  Specific arrangements are possible with the BIG_ENDIAN_BYTE and
 	  LITTLE_ENDIAN_BYTE, if the bytes are reversed.
 
-	  If you have a LART, on which the data (and address) lines were
-	  connected in a fashion which ensured that the nets were as short
-	  as possible, resulting in a bit-shuffling which seems utterly
-	  random to the untrained eye, you need the LART_ENDIAN_BYTE option.
-
-	  Yes, there really exists something sicker than PDP-endian :)
+config MTD_CFI_NOSWAP
+	bool "NO"
 
 config MTD_CFI_BE_BYTE_SWAP
 	bool "BIG_ENDIAN_BYTE"
-- 
1.7.7.6

