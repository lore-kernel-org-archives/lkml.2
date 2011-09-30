Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab1I3Euq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 00:50:46 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:47670 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1I3Euo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 00:50:44 -0400
Date: Fri, 30 Sep 2011 14:50:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110930145042.4a7ee530848262294b297939@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/pinctrl/core.c:80:1: warning: data definition has no type or storage class [enabled by default]
drivers/pinctrl/core.c:80:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/pinctrl/core.c:80:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/pinctrl/core.c:86:1: warning: data definition has no type or storage class [enabled by default]
drivers/pinctrl/core.c:86:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/pinctrl/core.c:86:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/pinctrl/core.c:152:1: warning: data definition has no type or storage class [enabled by default]
drivers/pinctrl/core.c:152:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/pinctrl/core.c:152:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/pinctrl/core.c:590:1: warning: data definition has no type or storage class [enabled by default]
drivers/pinctrl/core.c:590:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/pinctrl/core.c:590:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/pinctrl/core.c:614:1: warning: data definition has no type or storage class [enabled by default]
drivers/pinctrl/core.c:614:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/pinctrl/core.c:614:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/pinctrl/pinmux.c: In function 'pin_request':
drivers/pinctrl/pinmux.c:143:2: error: implicit declaration of function 'try_module_get' [-Werror=implicit-function-declaration]
drivers/pinctrl/pinmux.c: In function 'pin_free':
drivers/pinctrl/pinmux.c:206:2: error: implicit declaration of function 'module_put' [-Werror=implicit-function-declaration]
drivers/pinctrl/pinmux.c: At top level:
drivers/pinctrl/pinmux.c:234:1: warning: data definition has no type or storage class [enabled by default]
drivers/pinctrl/pinmux.c:234:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/pinctrl/pinmux.c:234:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/pinctrl/pinmux.c:257:1: warning: data definition has no type or storage class [enabled by default]
drivers/pinctrl/pinmux.c:257:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/pinctrl/pinmux.c:257:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/pinctrl/pinmux.c:754:1: warning: data definition has no type or storage class [enabled by default]
drivers/pinctrl/pinmux.c:754:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/pinctrl/pinmux.c:754:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/pinctrl/pinmux.c:779:1: warning: data definition has no type or storage class [enabled by default]
drivers/pinctrl/pinmux.c:779:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/pinctrl/pinmux.c:779:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/pinctrl/pinmux.c:813:1: warning: data definition has no type or storage class [enabled by default]
drivers/pinctrl/pinmux.c:813:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/pinctrl/pinmux.c:813:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/pinctrl/pinmux.c:837:1: warning: data definition has no type or storage class [enabled by default]
drivers/pinctrl/pinmux.c:837:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/pinctrl/pinmux.c:837:1: warning: parameter names (without types) in function declaration [enabled by default]


Caused by commit 05f20c997d73 ("drivers: create a pin control subsystem
v8"), revelealed by the module.h split.

I have applied the following patch for today (Linus, the
drivers/pinctrl/pinmux.c part of this can be applied to your tree).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 30 Sep 2011 14:39:04 +1000
Subject: [PATCH] pinctrl: EXPORT_SYMBOL needs export.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/pinctrl/core.c   |    1 +
 drivers/pinctrl/pinmux.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 4229628..f9263b2 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -12,6 +12,7 @@
 #define pr_fmt(fmt) "pinctrl core: " fmt
 
 #include <linux/kernel.h>
+#include <linux/export.h>
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/slab.h>
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 37803f0..6b28f2b 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -12,6 +12,7 @@
 #define pr_fmt(fmt) "pinmux core: " fmt
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/slab.h>
-- 
1.7.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
