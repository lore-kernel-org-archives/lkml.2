Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0CROWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:22:49 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:35086 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab0CROWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:22:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iiOD0Ug0eOqTcUFP7e0+AdS9XGBKlmgmodTpY+LxM/19gX0BwbbyKe0vwRKD7lYpar
         Wz0tHy2NAZTru47Oqu1gKXS7L94yYyQI0hExFpFMCsxE8RMwjVHle2Y80QaiT0chZe/T
         rsUmkZ2SVSDqTThIovyhL9caBmqy1jljjN97Y=
From: Steven Harms <sjharms@gmail.com>
To: gregkh@suse.de, lieb@canonical.com, forest@alittletooquiet.net,
       sharms@ubuntu.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6655: Convert C99 style comments, remove spaces between function definitions and parenthesis
Date: Thu, 18 Mar 2010 10:15:59 -0400
Message-Id: <1268921759-25355-1-git-send-email-sharms@ubuntu.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converted C99 style comments to kernel style guideline complianet comments.  Removed spaces between function definitions and parenthesis.  These were indicated as problems by checkpatch tool.

Fixed typo found by Gabor Stefanik

Signed-off-by: Steven Harms <sharms@ubuntu.com>
---
 drivers/staging/vt6655/srom.c |   50 ++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/vt6655/srom.c b/drivers/staging/vt6655/srom.c
index 5a7c6ca..335630f 100644
--- a/drivers/staging/vt6655/srom.c
+++ b/drivers/staging/vt6655/srom.c
@@ -85,15 +85,15 @@ BYTE SROMbyReadEmbedded(DWORD_PTR dwIoBase, BYTE byContntOffset)

     byData = 0xFF;
     VNSvInPortB(dwIoBase + MAC_REG_I2MCFG, &byOrg);
-    // turn off hardware retry for getting NACK
+    /* turn off hardware retry for getting NACK */
     VNSvOutPortB(dwIoBase + MAC_REG_I2MCFG, (byOrg & (~I2MCFG_NORETRY)));
     for (wNoACK = 0; wNoACK < W_MAX_I2CRETRY; wNoACK++) {
         VNSvOutPortB(dwIoBase + MAC_REG_I2MTGID, EEP_I2C_DEV_ID);
         VNSvOutPortB(dwIoBase + MAC_REG_I2MTGAD, byContntOffset);

-        // issue read command
+        /* issue read command */
         VNSvOutPortB(dwIoBase + MAC_REG_I2MCSR, I2MCSR_EEMR);
-        // wait DONE be set
+        /* wait DONE be set */
         for (wDelay = 0; wDelay < W_MAX_TIMEOUT; wDelay++) {
             VNSvInPortB(dwIoBase + MAC_REG_I2MCSR, &byWait);
             if (byWait & (I2MCSR_DONE | I2MCSR_NACK))
@@ -125,7 +125,7 @@ BYTE SROMbyReadEmbedded(DWORD_PTR dwIoBase, BYTE byContntOffset)
  * Return Value: TRUE if succeeded; FALSE if failed.
  *
  */
-BOOL SROMbWriteEmbedded (DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byData)
+BOOL SROMbWriteEmbedded(DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byData)
 {
     WORD    wDelay, wNoACK;
     BYTE    byWait;
@@ -133,16 +133,16 @@ BOOL SROMbWriteEmbedded (DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byData)
     BYTE    byOrg;

     VNSvInPortB(dwIoBase + MAC_REG_I2MCFG, &byOrg);
-    // turn off hardware retry for getting NACK
+    /* turn off hardware retry for getting NACK */
     VNSvOutPortB(dwIoBase + MAC_REG_I2MCFG, (byOrg & (~I2MCFG_NORETRY)));
     for (wNoACK = 0; wNoACK < W_MAX_I2CRETRY; wNoACK++) {
         VNSvOutPortB(dwIoBase + MAC_REG_I2MTGID, EEP_I2C_DEV_ID);
         VNSvOutPortB(dwIoBase + MAC_REG_I2MTGAD, byContntOffset);
         VNSvOutPortB(dwIoBase + MAC_REG_I2MDOPT, byData);

-        // issue write command
+        /* issue write command */
         VNSvOutPortB(dwIoBase + MAC_REG_I2MCSR, I2MCSR_EEMW);
-        // wait DONE be set
+        /* wait DONE be set */
         for (wDelay = 0; wDelay < W_MAX_TIMEOUT; wDelay++) {
             VNSvInPortB(dwIoBase + MAC_REG_I2MCSR, &byWait);
             if (byWait & (I2MCSR_DONE | I2MCSR_NACK))
@@ -178,7 +178,7 @@ BOOL SROMbWriteEmbedded (DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byData)
  * Return Value: none
  *
  */
-void SROMvRegBitsOn (DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byBits)
+void SROMvRegBitsOn(DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byBits)
 {
     BYTE    byOrgData;

@@ -199,7 +199,7 @@ void SROMvRegBitsOn (DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byBits)
  *      none
  *
  */
-void SROMvRegBitsOff (DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byBits)
+void SROMvRegBitsOff(DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byBits)
 {
     BYTE    byOrgData;

@@ -222,7 +222,7 @@ void SROMvRegBitsOff (DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byBits)
  * Return Value: TRUE if all test bits on; otherwise FALSE
  *
  */
-BOOL SROMbIsRegBitsOn (DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byTestBits)
+BOOL SROMbIsRegBitsOn(DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byTestBits)
 {
     BYTE    byOrgData;

@@ -245,7 +245,7 @@ BOOL SROMbIsRegBitsOn (DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byTestBits)
  * Return Value: TRUE if all test bits off; otherwise FALSE
  *
  */
-BOOL SROMbIsRegBitsOff (DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byTestBits)
+BOOL SROMbIsRegBitsOff(DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byTestBits)
 {
     BYTE    byOrgData;

@@ -266,11 +266,11 @@ BOOL SROMbIsRegBitsOff (DWORD_PTR dwIoBase, BYTE byContntOffset, BYTE byTestBits
  * Return Value: none
  *
  */
-void SROMvReadAllContents (DWORD_PTR dwIoBase, PBYTE pbyEepromRegs)
+void SROMvReadAllContents(DWORD_PTR dwIoBase, PBYTE pbyEepromRegs)
 {
     int     ii;

-    // ii = Rom Address
+    /* ii = Rom Address */
     for (ii = 0; ii < EEP_MAX_CONTEXT_SIZE; ii++) {
         *pbyEepromRegs = SROMbyReadEmbedded(dwIoBase,(BYTE) ii);
         pbyEepromRegs++;
@@ -291,11 +291,11 @@ void SROMvReadAllContents (DWORD_PTR dwIoBase, PBYTE pbyEepromRegs)
  * Return Value: none
  *
  */
-void SROMvWriteAllContents (DWORD_PTR dwIoBase, PBYTE pbyEepromRegs)
+void SROMvWriteAllContents(DWORD_PTR dwIoBase, PBYTE pbyEepromRegs)
 {
     int     ii;

-    // ii = Rom Address
+    /* ii = Rom Address */
     for (ii = 0; ii < EEP_MAX_CONTEXT_SIZE; ii++) {
         SROMbWriteEmbedded(dwIoBase,(BYTE) ii, *pbyEepromRegs);
         pbyEepromRegs++;
@@ -315,11 +315,11 @@ void SROMvWriteAllContents (DWORD_PTR dwIoBase, PBYTE pbyEepromRegs)
  * Return Value: none
  *
  */
-void SROMvReadEtherAddress (DWORD_PTR dwIoBase, PBYTE pbyEtherAddress)
+void SROMvReadEtherAddress(DWORD_PTR dwIoBase, PBYTE pbyEtherAddress)
 {
     BYTE     ii;

-    // ii = Rom Address
+    /* ii = Rom Address */
     for (ii = 0; ii < U_ETHER_ADDR_LEN; ii++) {
         *pbyEtherAddress = SROMbyReadEmbedded(dwIoBase, ii);
         pbyEtherAddress++;
@@ -340,11 +340,11 @@ void SROMvReadEtherAddress (DWORD_PTR dwIoBase, PBYTE pbyEtherAddress)
  * Return Value: none
  *
  */
-void SROMvWriteEtherAddress (DWORD_PTR dwIoBase, PBYTE pbyEtherAddress)
+void SROMvWriteEtherAddress(DWORD_PTR dwIoBase, PBYTE pbyEtherAddress)
 {
     BYTE     ii;

-    // ii = Rom Address
+    /* ii = Rom Address */
     for (ii = 0; ii < U_ETHER_ADDR_LEN; ii++) {
         SROMbWriteEmbedded(dwIoBase, ii, *pbyEtherAddress);
         pbyEtherAddress++;
@@ -364,15 +364,15 @@ void SROMvWriteEtherAddress (DWORD_PTR dwIoBase, PBYTE pbyEtherAddress)
  * Return Value: none
  *
  */
-void SROMvReadSubSysVenId (DWORD_PTR dwIoBase, PDWORD pdwSubSysVenId)
+void SROMvReadSubSysVenId(DWORD_PTR dwIoBase, PDWORD pdwSubSysVenId)
 {
     PBYTE   pbyData;

     pbyData = (PBYTE)pdwSubSysVenId;
-    // sub vendor
+    /* sub vendor */
     *pbyData = SROMbyReadEmbedded(dwIoBase, 6);
     *(pbyData+1) = SROMbyReadEmbedded(dwIoBase, 7);
-    // sub system
+    /* sub system */
     *(pbyData+2) = SROMbyReadEmbedded(dwIoBase, 8);
     *(pbyData+3) = SROMbyReadEmbedded(dwIoBase, 9);
 }
@@ -389,7 +389,7 @@ void SROMvReadSubSysVenId (DWORD_PTR dwIoBase, PDWORD pdwSubSysVenId)
  * Return Value: TRUE if success; otherwise FALSE
  *
  */
-BOOL SROMbAutoLoad (DWORD_PTR dwIoBase)
+BOOL SROMbAutoLoad(DWORD_PTR dwIoBase)
 {
     BYTE    byWait;
     int     ii;
@@ -397,12 +397,12 @@ BOOL SROMbAutoLoad (DWORD_PTR dwIoBase)
     BYTE    byOrg;

     VNSvInPortB(dwIoBase + MAC_REG_I2MCFG, &byOrg);
-    // turn on hardware retry
+    /* turn on hardware retry */
     VNSvOutPortB(dwIoBase + MAC_REG_I2MCFG, (byOrg | I2MCFG_NORETRY));

     MACvRegBitsOn(dwIoBase, MAC_REG_I2MCSR, I2MCSR_AUTOLD);

-    // ii = Rom Address
+    /* ii = Rom Address */
     for (ii = 0; ii < EEP_MAX_CONTEXT_SIZE; ii++) {
         MACvTimer0MicroSDelay(dwIoBase, CB_EEPROM_READBYTE_WAIT);
         VNSvInPortB(dwIoBase + MAC_REG_I2MCSR, &byWait);
--
1.6.3.3

