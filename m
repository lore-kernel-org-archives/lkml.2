Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1HOSCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:02:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57411 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752566Ab1HOSCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:02:06 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/rApEh9jnr0ky4TeJ2pt5TOAgqz3QIOH1VD8XrY/
	hucBtLMPh12E34
From: Peter Huewe <peterhuewe@gmx.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] avr32/clock.c: Move '#include linux/export.h' to fix build failure
Date: Mon, 15 Aug 2011 20:02:00 +0200
Message-Id: <1313431320-17080-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a build failure for the avr32 defconfig by moving the include
of linux/export.h to the top of the file where it is needed.

Without the patch the build first warns about:
arch/avr32/mach-at32ap/clock.c:62: warning: data definition has no type
or storage class
arch/avr32/mach-at32ap/clock.c:62: warning: type defaults to 'int' in
declaration of 'EXPORT_SYMBOL'
arch/avr32/mach-at32ap/clock.c:62: warning: parameter names (without
types) in function declaration
(...)

And then fails with
ERROR: "clk_enable" [sound/spi/snd-at73c213.ko] undefined!
ERROR: "clk_disable" [sound/spi/snd-at73c213.ko] undefined!
(...)

This is because the definition of EXPORT_SYMBOL is needed before the
first usage, and thus the include has to be on the top of the file.

While at it, I sorted the include list alphabetically.

KernelVersion: Linux-next 20110812

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 arch/avr32/mach-at32ap/clock.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/avr32/mach-at32ap/clock.c b/arch/avr32/mach-at32ap/clock.c
index 579d619..78c873a 100644
--- a/arch/avr32/mach-at32ap/clock.c
+++ b/arch/avr32/mach-at32ap/clock.c
@@ -12,10 +12,11 @@
  * published by the Free Software Foundation.
  */
 #include <linux/clk.h>
-#include <linux/err.h>
 #include <linux/device.h>
-#include <linux/string.h>
+#include <linux/err.h>
+#include <linux/export.h>
 #include <linux/list.h>
+#include <linux/string.h>
 
 #include <mach/chip.h>
 
@@ -186,7 +187,6 @@ EXPORT_SYMBOL(clk_get_parent);
 #include <linux/io.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
-#include <linux/export.h>
 #include "pm.h"
 
 
-- 
1.7.3.4

