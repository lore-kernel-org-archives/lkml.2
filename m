Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab0DBBhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 21:37:09 -0400
Received: from p01c12o143.mxlogic.net ([208.65.145.66]:50584 "EHLO
	p01c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab0DBBhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 21:37:06 -0400
X-MXL-Hash: 4bb54a4151a6ffeb-cadf911b608d4a0bd718088ea7cf251c17bbd502
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
CC: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Date: Thu, 1 Apr 2010 20:36:30 -0500
Subject: [PATCH] fs-writeback.c: bitfields should be unsigned
Thread-Topic: [PATCH] fs-writeback.c: bitfields should be unsigned
Thread-Index: AcrSBOuhAQDzgk0rRY2YBvm7gUohnA==
Message-ID: <0D753D10438DA54287A00B0270842697636A7E957E@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010040101)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=ddTc33TfRA8A:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=zbe46bahRtDx8aUBN1lPzQ==:17 a=i00gxMtYAAAA:8 a=drO]
X-AnalysisOut: [t6m5kAAAA:8 a=qBuN8AYTBAJUXrrEsnUA:9 a=oBtnuD4uuwZY4xgX7c6]
X-AnalysisOut: [mKnZw8-4A:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o321bGmE026765

This fixes sparse noise:
  error: dubious one-bit signed bitfield

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>

---

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 76fc4d5..a25f491 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -41,9 +41,9 @@ struct wb_writeback_args {
 	long nr_pages;
 	struct super_block *sb;
 	enum writeback_sync_modes sync_mode;
-	int for_kupdate:1;
-	int range_cyclic:1;
-	int for_background:1;
+	unsigned int for_kupdate:1;
+	unsigned int range_cyclic:1;
+	unsigned int for_background:1;
 };
 
 /*
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
