Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab0EVOEN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 10:04:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab0EVOEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 10:04:09 -0400
Date: Sat, 22 May 2010 10:04:07 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       phillip@lougher.demon.co.uk, alain@knaff.lu, hpa@zytor.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100522135933.28675.17356.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: bunzip2: Fix warning in get_next_block()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkstack compile warning in get_next_block():

lib/decompress_bunzip2.c: In function `get_next_block':
lib/decompress_bunzip2.c:511: warning: the frame size of 1920 bytes is larger than 1024 bytes

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index a4e971d..8a78788 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -158,9 +158,10 @@ static int INIT get_next_block(struct bunzip_data *bd)
 	int *base = NULL;
 	int *limit = NULL;
 	int dbufCount, nextSym, dbufSize, groupCount, selector,
-		i, j, k, t, runPos, symCount, symTotal, nSelectors,
-		byteCount[256];
-	unsigned char uc, symToByte[256], mtfSymbol[256], *selectors;
+		i, j, k, t, runPos, symCount, symTotal, nSelectors;
+	static int byteCount[256];
+	unsigned char uc, *selectors;
+	static unsigned char symToByte[256], mtfSymbol[256];
 	unsigned int *dbuf, origPtr;
 
 	dbuf = bd->dbuf;
