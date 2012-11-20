Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab2KTR35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:29:57 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34109 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab2KTR3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:29:54 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@linuxfoundation.org, a.beregalov@gmail.com, devendra.aaru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 08/10] staging: cxt1e1: sbecrc.c: fixes brace placement
Date: Tue, 20 Nov 2012 19:28:50 +0200
Message-Id: <1353432532-21203-8-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
References: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit sorts out the incorrect placement of braces in the file.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/cxt1e1/sbecrc.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/cxt1e1/sbecrc.c b/drivers/staging/cxt1e1/sbecrc.c
index b4fabe1..f95728e 100644
--- a/drivers/staging/cxt1e1/sbecrc.c
+++ b/drivers/staging/cxt1e1/sbecrc.c
@@ -49,11 +49,9 @@ genCrcTable (u_int32_t *CRCTable)
 	int         ii, jj;
 	u_int32_t      crc;
 
-	for (ii = 0; ii < CRC_TABLE_ENTRIES; ii++)
-	{
+	for (ii = 0; ii < CRC_TABLE_ENTRIES; ii++) {
 		crc = ii;
-		for (jj = 8; jj > 0; jj--)
-		{
+		for (jj = 8; jj > 0; jj--) {
 			if (crc & 1)
 				crc = (crc >> 1) ^ CRC32_POLYNOMIAL;
 			else
@@ -98,15 +96,13 @@ sbeCrc (u_int8_t *buffer,          /* data buffer to crc */
 	* checking this every time sbeCrc() is called, since CRC calculations
 	* are already time consuming
 	*/
-	if (!crcTableInit)
-	{
+	if (!crcTableInit) {
 #ifdef STATIC_CRC_TABLE
 		tbl = &CRCTable;
 		genCrcTable (tbl);
 #else
 		tbl = (u_int32_t *) OS_kmalloc (CRC_TABLE_ENTRIES * sizeof (u_int32_t));
-		if (tbl == 0)
-		{
+		if (tbl == 0) {
 			*result = 0;   /* dummy up return value due to malloc
 					* failure */
 			return;
@@ -117,8 +113,7 @@ sbeCrc (u_int8_t *buffer,          /* data buffer to crc */
 	/* inverting bits makes ZMODEM & PKZIP compatible */
 	crc = initialCrc ^ 0xFFFFFFFFL;
 
-	while (count-- != 0)
-	{
+	while (count-- != 0) {
 		temp1 = (crc >> 8) & 0x00FFFFFFL;
 		temp2 = tbl[((int) crc ^ *buffer++) & 0xff];
 		crc = temp1 ^ temp2;
-- 
1.7.10.4

