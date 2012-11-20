Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab2KTRaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:30:14 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43850 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab2KTRaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:30:10 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@linuxfoundation.org, a.beregalov@gmail.com, devendra.aaru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 10/10] staging: cxt1e1: sbecrc.c: fixes 80+ char line length issue
Date: Tue, 20 Nov 2012 19:28:52 +0200
Message-Id: <1353432532-21203-10-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
References: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit sorts out a single case where a line was longer than
80 characters.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/cxt1e1/sbecrc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/cxt1e1/sbecrc.c b/drivers/staging/cxt1e1/sbecrc.c
index 87512a5..59dd7e2 100644
--- a/drivers/staging/cxt1e1/sbecrc.c
+++ b/drivers/staging/cxt1e1/sbecrc.c
@@ -101,7 +101,8 @@ sbeCrc(u_int8_t *buffer,          /* data buffer to crc */
 		tbl = &CRCTable;
 		genCrcTable(tbl);
 #else
-		tbl = (u_int32_t *) OS_kmalloc(CRC_TABLE_ENTRIES * sizeof(u_int32_t));
+		tbl = (u_int32_t *) OS_kmalloc(CRC_TABLE_ENTRIES
+			* sizeof(u_int32_t));
 		if (tbl == 0) {
 			*result = 0;   /* dummy up return value due to malloc
 					* failure */
-- 
1.7.10.4

