Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab1JAUF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:05:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62152 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab1JAUFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 11/26] ARM: pxa: allow building palm27x without pxafb
Date: Sat,  1 Oct 2011 22:03:43 +0200
Message-Id: <1317499438-14058-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:EH8UVL88OXbTGjHuerKNyIoIJEROr81gLEvZ3610sWx
 Y61mUYoQpr5CKSu3dPhHjwoKrbBKXZTSXYLqnh6kAvun4pT6Rj
 H1CwTe1zOwuuf7GP6njxcBHli6N4pJDWaP+iHYQwPPeXhDyeVX
 59z5Io2KJr/FkccsdzU7W/iLwc9f9Ti7oDkmVwraCtvUtXHgvc
 E6w/IeQRgLsWHJNJQEoprJq4FOsqU7uArRW63ur29iXLhK8+gl
 KkEQ//VaQacpNpS0ulKipFb8Mnc5jpU33TJJJzB4dgtKfzvuqT
 ovJbxwUaaFp82kCO0g5sWNF291yVQOVxBObjBQb8HklFKgHNoG
 xZuJqR9c714x52u0Pw4DzYG7hYHYdjhmGgBRzb6Bg8s3SPTYBh
 gGgOndGM1NSFw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The frame buffer device is defined conditionally on whether the
driver is configured. However, the #ifdef guard around the
declaration of palm27x_lcd_init also removes the visibility
of the lcd mode declarations, which need to be available in
order to build correctly, even if they are not defined in the
end.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/include/mach/palm27x.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pxa/include/mach/palm27x.h b/arch/arm/mach-pxa/include/mach/palm27x.h
index 0a5e5ea..030a916 100644
--- a/arch/arm/mach-pxa/include/mach/palm27x.h
+++ b/arch/arm/mach-pxa/include/mach/palm27x.h
@@ -27,10 +27,10 @@ extern void __init palm27x_pm_init(unsigned long str_base);
 static inline void palm27x_pm_init(unsigned long str_base) {}
 #endif
 
-#if defined(CONFIG_FB_PXA) || defined(CONFIG_FB_PXA_MODULE)
 extern struct pxafb_mode_info palm_320x480_lcd_mode;
 extern struct pxafb_mode_info palm_320x320_lcd_mode;
 extern struct pxafb_mode_info palm_320x320_new_lcd_mode;
+#if defined(CONFIG_FB_PXA) || defined(CONFIG_FB_PXA_MODULE)
 extern void __init palm27x_lcd_init(int power,
 					struct pxafb_mode_info *mode);
 #else
-- 
1.7.5.4

