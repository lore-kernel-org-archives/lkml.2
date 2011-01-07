Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab1AGDzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:55:12 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:60100 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab1AGDzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:55:01 -0500
Date: Fri, 7 Jan 2011 14:54:56 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: crypto: padlock - Move padlock.h into include/crypto
Message-ID: <20110107035456.GA1341@gondor.apana.org.au>
References: <20110104230644.GJ27114@darkside.kls.lan> <20110105003020.GA5751@gondor.apana.org.au> <20110105035222.GA8762@darkside.kls.lan> <20110105054735.GA7773@gondor.apana.org.au> <20110105131621.GA24769@darkside.kls.lan> <20110106061241.GA18939@gondor.apana.org.au> <20110106131516.GB8803@darkside.kls.lan> <20110106133541.GA22030@gondor.apana.org.au> <20110106144254.GC8803@darkside.kls.lan> <20110107034948.GA1177@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107034948.GA1177@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 02:49:48PM +1100, Herbert Xu wrote:
>
> commit 0735ac1f2551d9f9d356126aaf3b1110150918e6
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Fri Jan 7 14:48:57 2011 +1100

Here are the other patches to fix this problem:

commit 21493088733e6e09dac6f54595a1b6b8ab1e68fd
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Jan 7 14:52:00 2011 +1100

    crypto: padlock - Move padlock.h into include/crypto
    
    This patch moves padlock.h from drivers/crypto into include/crypto
    so that it may be used by the via-rng driver.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 2e992bc..2e56508 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -9,6 +9,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/padlock.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -21,7 +22,6 @@
 #include <asm/byteorder.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
-#include "padlock.h"
 
 /*
  * Number of data blocks actually fetched for each xcrypt insn.
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index d3a27e0..adf075b 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -13,6 +13,7 @@
  */
 
 #include <crypto/internal/hash.h>
+#include <crypto/padlock.h>
 #include <crypto/sha.h>
 #include <linux/err.h>
 #include <linux/module.h>
@@ -22,13 +23,6 @@
 #include <linux/kernel.h>
 #include <linux/scatterlist.h>
 #include <asm/i387.h>
-#include "padlock.h"
-
-#ifdef CONFIG_64BIT
-#define STACK_ALIGN 16
-#else
-#define STACK_ALIGN 4
-#endif
 
 struct padlock_sha_desc {
 	struct shash_desc fallback;
diff --git a/drivers/crypto/padlock.h b/drivers/crypto/padlock.h
deleted file mode 100644
index b728e45..0000000
--- a/drivers/crypto/padlock.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Driver for VIA PadLock
- *
- * Copyright (c) 2004 Michal Ludvig <michal@logix.cz>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
- * any later version.
- *
- */
-
-#ifndef _CRYPTO_PADLOCK_H
-#define _CRYPTO_PADLOCK_H
-
-#define PADLOCK_ALIGNMENT 16
-
-#define PFX	"padlock: "
-
-#define PADLOCK_CRA_PRIORITY	300
-#define PADLOCK_COMPOSITE_PRIORITY 400
-
-#endif	/* _CRYPTO_PADLOCK_H */
diff --git a/include/crypto/padlock.h b/include/crypto/padlock.h
new file mode 100644
index 0000000..d2cfa2e
--- /dev/null
+++ b/include/crypto/padlock.h
@@ -0,0 +1,29 @@
+/*
+ * Driver for VIA PadLock
+ *
+ * Copyright (c) 2004 Michal Ludvig <michal@logix.cz>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option) 
+ * any later version.
+ *
+ */
+
+#ifndef _CRYPTO_PADLOCK_H
+#define _CRYPTO_PADLOCK_H
+
+#define PADLOCK_ALIGNMENT 16
+
+#define PFX	KBUILD_MODNAME ": "
+
+#define PADLOCK_CRA_PRIORITY	300
+#define PADLOCK_COMPOSITE_PRIORITY 400
+
+#ifdef CONFIG_64BIT
+#define STACK_ALIGN 16
+#else
+#define STACK_ALIGN 4
+#endif
+
+#endif	/* _CRYPTO_PADLOCK_H */

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
