Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0ELWG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:06:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:52745 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754508Ab0ELWG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:06:56 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18QyNBE9eYQ0JR8Gqz6BcyTppiv3UCGKMF8YBOekM
	cs3/9XRVTrnon7
From: Peter Huewe <PeterHuewe@gmx.de>
To: David Woodhouse <dwmw2@infradead.org>, Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH] mtd: Move function mtd_to_flctl to fix build failure
Date: Thu, 13 May 2010 00:06:54 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: Magnus Damm <damm@opensource.se>, Paul Mundt <lethal@linux-sh.org>,
       Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005130006.54616.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch fixes a build failure[1] by simply moving the function mtd_to_flctl
beneath the definition of sh_flctl which it uses.

BF introduced by patch 
'mtd/nand/sh_flctl: Replace the dangerous mtd_to_flctl macro' (67026418)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next of 20100512
References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2601986/

 include/linux/mtd/sh_flctl.h |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/mtd/sh_flctl.h b/include/linux/mtd/sh_flctl.h
index 178b5c2..d7b686a 100644
--- a/include/linux/mtd/sh_flctl.h
+++ b/include/linux/mtd/sh_flctl.h
@@ -93,11 +93,6 @@
 #define INIT_FL4ECCRESULT_VAL	0x03FF03FF
 #define LOOP_TIMEOUT_MAX	0x00010000
 
-static inline struct sh_flctl *mtd_to_flctl(struct mtd_info *mtdinfo)
-{
-	return container_of(mtdinfo, struct sh_flctl, mtd);
-}
-
 struct sh_flctl {
 	struct mtd_info		mtd;
 	struct nand_chip	chip;
@@ -128,4 +123,9 @@ struct sh_flctl_platform_data {
 	unsigned has_hwecc:1;
 };
 
+static inline struct sh_flctl *mtd_to_flctl(struct mtd_info *mtdinfo)
+{
+	return container_of(mtdinfo, struct sh_flctl, mtd);
+}
+
 #endif	/* __SH_FLCTL_H__ */
-- 
1.6.4.4

