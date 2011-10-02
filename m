Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab1JBNen (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 09:34:43 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60054 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1JBNej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 09:34:39 -0400
Subject: [PATCH] ASoC: samsung: s3c-i2s-v2.c needs module.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jassi Brar <jassisinghbrar@gmail.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Oct 2011 21:34:26 +0800
Message-ID: <1317562466.4996.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include <linux/module.h> to fix below build error:

  CC      sound/soc/samsung/s3c-i2s-v2.o
sound/soc/samsung/s3c-i2s-v2.c:573: warning: data definition has no type or storage class
sound/soc/samsung/s3c-i2s-v2.c:573: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
sound/soc/samsung/s3c-i2s-v2.c:573: warning: parameter names (without types) in function declaration
sound/soc/samsung/s3c-i2s-v2.c:638: warning: data definition has no type or storage class
sound/soc/samsung/s3c-i2s-v2.c:638: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
sound/soc/samsung/s3c-i2s-v2.c:638: warning: parameter names (without types) in function declaration
sound/soc/samsung/s3c-i2s-v2.c:677: warning: data definition has no type or storage class
sound/soc/samsung/s3c-i2s-v2.c:677: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
sound/soc/samsung/s3c-i2s-v2.c:677: warning: parameter names (without types) in function declaration
sound/soc/samsung/s3c-i2s-v2.c: In function 's3c_i2sv2_register_dai':
sound/soc/samsung/s3c-i2s-v2.c:736: warning: initialization discards qualifiers from pointer target type
sound/soc/samsung/s3c-i2s-v2.c: At top level:
sound/soc/samsung/s3c-i2s-v2.c:754: warning: data definition has no type or storage class
sound/soc/samsung/s3c-i2s-v2.c:754: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
sound/soc/samsung/s3c-i2s-v2.c:754: warning: parameter names (without types) in function declaration
sound/soc/samsung/s3c-i2s-v2.c:756: error: expected declaration specifiers or '...' before string constant
sound/soc/samsung/s3c-i2s-v2.c:756: warning: data definition has no type or storage class
sound/soc/samsung/s3c-i2s-v2.c:756: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
sound/soc/samsung/s3c-i2s-v2.c:756: warning: function declaration isn't a prototype
make[3]: *** [sound/soc/samsung/s3c-i2s-v2.o] Error 1
make[2]: *** [sound/soc/samsung] Error 2
make[1]: *** [sound/soc] Error 2
make: *** [sound] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is against linux-next (20110930).

 sound/soc/samsung/s3c-i2s-v2.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/samsung/s3c-i2s-v2.c b/sound/soc/samsung/s3c-i2s-v2.c
index 52074a2b..7a73380 100644
--- a/sound/soc/samsung/s3c-i2s-v2.c
+++ b/sound/soc/samsung/s3c-i2s-v2.c
@@ -16,6 +16,7 @@
  * option) any later version.
  */
 
+#include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/clk.h>
 #include <linux/io.h>
-- 
1.7.4.1



