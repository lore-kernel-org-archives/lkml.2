Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab2GCKXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:23:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:3722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab2GCKXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:23:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172883782"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "nico@linaro.org" <nico@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: mm: fix unitialized variable warning
Thread-Topic: [PATCH] ARM: mm: fix unitialized variable warning
Thread-Index: AQHNWQSjM0RQM+NVfU+hG1Nc8rphopcXWO2g
Date: Tue, 3 Jul 2012 10:23:21 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A0A18BB@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q63ANcC9015189

arch/arm/mm/alignment.c: In function â€˜do_alignmentâ€™:
arch/arm/mm/alignment.c:327:15: warning: â€˜offset.unâ€™ may be used uninitialized in this function [-Wuninitialized]
arch/arm/mm/alignment.c:749:21: note: â€˜offset.unâ€™ was declared here

Signed-off-by: Du, Changbin <changbin.du@gmail.com>
---
 arch/arm/mm/alignment.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 9107231..387a6cd 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -746,7 +746,7 @@ do_alignment_t32_to_handler(unsigned long *pinstr, struct pt_regs *regs,
 static int
 do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 {
-	union offset_union offset;
+	union offset_union uninitialized_var(offset);
 	unsigned long instr = 0, instrptr;
 	int (*handler)(unsigned long addr, unsigned long instr, struct pt_regs *regs);
 	unsigned int type;
-- 
1.7.9.5

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
