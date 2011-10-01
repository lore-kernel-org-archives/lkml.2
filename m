Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab1JAUJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:09:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53338 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab1JAUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 05/26] ARM: pxa: make zylonite_pxa*_init declaration match code
Date: Sat,  1 Oct 2011 22:03:37 +0200
Message-Id: <1317499438-14058-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:UHOspz6ZKZX8IE5BFB3h4J9N//JY4/j7MfoonUlbTfA
 3t5syvXclciOCk0khyzF6qVshODUdir/PKj3/CN7PWrnJrrfY1
 8RqRZo7WRGWi5XDogN1WGqBI/wul64VLQ8++FwJTj3nJpIEgmh
 TwEhMGfMUCRUakTxeBn3UyNsQuA7OEmrEvWtCmDU0CYoODYphT
 ADOnstAQaIkGh3g7Hk8BIxUbthNUTxbQsc3LPiGrjvtzWrdurZ
 C8x76NnJbTrA0aIFGGgytZ7tlFbKOLwJHibIxUWF14nfjaURyV
 DxtPAOkXtIzMQEZoPK/3a1qce6SGf3z2Iox3rntLYaf3VDsDZ/
 ud1eqIvC3OGVRBrfSgngssirjHsWFRC480Rg7UBo/+LN1Ij2hU
 Ee42iiCkZvWIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When support for zylonite is disabled, the zylonite_pxa300_init
and zylonite_pxa320_init functions are not there, but the declaration
is still kept around if any other boards for the same soc are
enabled. This changes the declaration to be conditional on the
same symbol as the code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/include/mach/zylonite.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/include/mach/zylonite.h b/arch/arm/mach-pxa/include/mach/zylonite.h
index ea24998..ecca976 100644
--- a/arch/arm/mach-pxa/include/mach/zylonite.h
+++ b/arch/arm/mach-pxa/include/mach/zylonite.h
@@ -19,7 +19,7 @@ extern int wm9713_irq;
 extern int lcd_id;
 extern int lcd_orientation;
 
-#ifdef CONFIG_CPU_PXA300
+#ifdef CONFIG_MACH_ZYLONITE300
 extern void zylonite_pxa300_init(void);
 #else
 static inline void zylonite_pxa300_init(void)
@@ -29,7 +29,7 @@ static inline void zylonite_pxa300_init(void)
 }
 #endif
 
-#ifdef CONFIG_CPU_PXA320
+#ifdef CONFIG_MACH_ZYLONITE320
 extern void zylonite_pxa320_init(void);
 #else
 static inline void zylonite_pxa320_init(void)
-- 
1.7.5.4

