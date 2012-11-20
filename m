Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2KTR3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:29:51 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52867 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab2KTR3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:29:46 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@linuxfoundation.org, a.beregalov@gmail.com, devendra.aaru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 07/10] staging: cxt1e1: sbecrc.c: fixes indentation issues
Date: Tue, 20 Nov 2012 19:28:49 +0200
Message-Id: <1353432532-21203-7-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
References: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit converts several instances of space-based indentation
to use tabs instead.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/cxt1e1/sbecrc.c |  106 +++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/cxt1e1/sbecrc.c b/drivers/staging/cxt1e1/sbecrc.c
index 3f3cd60..b4fabe1 100644
--- a/drivers/staging/cxt1e1/sbecrc.c
+++ b/drivers/staging/cxt1e1/sbecrc.c
@@ -46,23 +46,23 @@ static u_int32_t CRCTable[CRC_TABLE_ENTRIES];
 static void
 genCrcTable (u_int32_t *CRCTable)
 {
-    int         ii, jj;
-    u_int32_t      crc;
-
-    for (ii = 0; ii < CRC_TABLE_ENTRIES; ii++)
-    {
-        crc = ii;
-        for (jj = 8; jj > 0; jj--)
-        {
-            if (crc & 1)
-                crc = (crc >> 1) ^ CRC32_POLYNOMIAL;
-            else
-                crc >>= 1;
-        }
-        CRCTable[ii] = crc;
-    }
-
-    crcTableInit++;
+	int         ii, jj;
+	u_int32_t      crc;
+
+	for (ii = 0; ii < CRC_TABLE_ENTRIES; ii++)
+	{
+		crc = ii;
+		for (jj = 8; jj > 0; jj--)
+		{
+			if (crc & 1)
+				crc = (crc >> 1) ^ CRC32_POLYNOMIAL;
+			else
+				crc >>= 1;
+		}
+		CRCTable[ii] = crc;
+	}
+
+	crcTableInit++;
 }
 
 
@@ -86,51 +86,51 @@ genCrcTable (u_int32_t *CRCTable)
 
 void
 sbeCrc (u_int8_t *buffer,          /* data buffer to crc */
-        u_int32_t count,           /* length of block in bytes */
-        u_int32_t initialCrc,      /* starting CRC */
-        u_int32_t *result)
+	u_int32_t count,           /* length of block in bytes */
+	u_int32_t initialCrc,      /* starting CRC */
+	u_int32_t *result)
 {
-    u_int32_t     *tbl = 0;
-    u_int32_t      temp1, temp2, crc;
-
-    /*
-     * if table not yet created, do so. Don't care about "extra" time
-     * checking this every time sbeCrc() is called, since CRC calculations are
-     * already time consuming
-     */
-    if (!crcTableInit)
-    {
+	u_int32_t     *tbl = 0;
+	u_int32_t      temp1, temp2, crc;
+
+	/*
+	* if table not yet created, do so. Don't care about "extra" time
+	* checking this every time sbeCrc() is called, since CRC calculations
+	* are already time consuming
+	*/
+	if (!crcTableInit)
+	{
 #ifdef STATIC_CRC_TABLE
-        tbl = &CRCTable;
-        genCrcTable (tbl);
+		tbl = &CRCTable;
+		genCrcTable (tbl);
 #else
-        tbl = (u_int32_t *) OS_kmalloc (CRC_TABLE_ENTRIES * sizeof (u_int32_t));
-        if (tbl == 0)
-        {
-            *result = 0;            /* dummy up return value due to malloc
-                                     * failure */
-            return;
-        }
-        genCrcTable (tbl);
+		tbl = (u_int32_t *) OS_kmalloc (CRC_TABLE_ENTRIES * sizeof (u_int32_t));
+		if (tbl == 0)
+		{
+			*result = 0;   /* dummy up return value due to malloc
+					* failure */
+			return;
+		}
+		genCrcTable (tbl);
 #endif
-    }
-    /* inverting bits makes ZMODEM & PKZIP compatible */
-    crc = initialCrc ^ 0xFFFFFFFFL;
+	}
+	/* inverting bits makes ZMODEM & PKZIP compatible */
+	crc = initialCrc ^ 0xFFFFFFFFL;
 
-    while (count-- != 0)
-    {
-        temp1 = (crc >> 8) & 0x00FFFFFFL;
-        temp2 = tbl[((int) crc ^ *buffer++) & 0xff];
-        crc = temp1 ^ temp2;
-    }
+	while (count-- != 0)
+	{
+		temp1 = (crc >> 8) & 0x00FFFFFFL;
+		temp2 = tbl[((int) crc ^ *buffer++) & 0xff];
+		crc = temp1 ^ temp2;
+	}
 
-    crc ^= 0xFFFFFFFFL;
+	crc ^= 0xFFFFFFFFL;
 
-    *result = crc;
+	*result = crc;
 
 #ifndef STATIC_CRC_TABLE
-    crcTableInit = 0;
-    OS_kfree (tbl);
+	crcTableInit = 0;
+	OS_kfree (tbl);
 #endif
 }
 
-- 
1.7.10.4

