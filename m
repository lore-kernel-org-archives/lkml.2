Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab2JBQjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:39:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65129 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab2JBQhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH 06/17] ARM: pxa: work around duplicate definition of GPIO24_SSP1_SFRM
Date: Tue,  2 Oct 2012 18:36:45 +0200
Message-Id: <1349195816-2225-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:KT0mO/nDxTFBQYV/ia7fYlWiYtMlb3ONz6bX+6wRQzM
 h72RDfUOlmYpEI1TVSa6HDIJnwc0rXqKfaAnqnWhscxz00S91T
 9atFq4qABBMKivgad7vO60fYZE5/NpQagCFJNjLROnOuarHdZl
 /fTutAGL8ILqSjKFit3haVkuSG/1hg0iVAo8Z3yfB6u2AYeQHe
 emeSfe085wo4G7W32kTzwFDn2schTWV60vYnSmtopMLjY+DhxR
 TlexYWZYPYCwCvfMJsXIQQDiI6LeR2d+c7H8XBQ6XeFvo6JPnV
 dkIiuBARrXbTkLmJbjnkzKS+kmmbykYr1Ttiwpg3gPncfuXjLS
 OzVnUpq+sLxQJB4hdZadvFWRSA1BYWFA6Op6Xk2b57g2eIBrBt
 CvJQC3A/wyY/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol "GPIO24_SSP1_SFRM" is defined in both mfp-pxa27x.h and
mfp-pxa25x.h. Since the macro is not actually used in the cm-x2xx.c
file, but it includes both headers, a safe workaround should be
to just undefine it from the .c file. This is a bit hacky and
the headers should be fixed to not both define it, but for now
it gets us around an annoying warning.

Without this patch, building cm_x2xx_defconfig results in:

In file included from arch/arm/mach-pxa/include/mach-pxa/pxa27x.h:7:0,
                 from arch/arm/mach-pxa/cm-x2xx.c:25:
arch/arm/mach-pxa/include/mach-pxa/mfp-pxa27x.h:215:0: warning: "GPIO24_SSP1_SFRM" redefined [enabled by default]
arch/arm/mach-pxa/include/mach-pxa/mfp-pxa25x.h:111:0: note: this is the location of the previous definition

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Mike Rapoport <mike@compulab.co.il>
---
 arch/arm/mach-pxa/cm-x2xx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-pxa/cm-x2xx.c b/arch/arm/mach-pxa/cm-x2xx.c
index 8fa4ad2..ae5e74a 100644
--- a/arch/arm/mach-pxa/cm-x2xx.c
+++ b/arch/arm/mach-pxa/cm-x2xx.c
@@ -22,6 +22,7 @@
 #include <asm/mach/map.h>
 
 #include <mach/pxa25x.h>
+#undef GPIO24_SSP1_SFRM
 #include <mach/pxa27x.h>
 #include <mach/audio.h>
 #include <mach/pxafb.h>
-- 
1.7.10

