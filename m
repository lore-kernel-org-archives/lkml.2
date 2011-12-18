Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab1LRWYE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 17:24:04 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38351 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751222Ab1LRWYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 17:24:01 -0500
From: Joe Perches <joe@perches.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: [PATCH 2/2] crypto: Convert printks to pr_<level>
Date: Sun, 18 Dec 2011 14:23:41 -0800
Message-Id: <83041e15b9909bed0d0b285d171c7cfe3627f8b8.1324246976.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <b18a29f3f4217c311ff672a4ffb0bdadd2f6930d.1324246975.git.joe@perches.com>
References: <b18a29f3f4217c311ff672a4ffb0bdadd2f6930d.1324246975.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the current logging styles.

Add pr_fmt, remove embedded prefixes, add
missing newlines, coalesce formats.
Use pr_info_once as appropriate.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/crypto/amcc/crypto4xx_core.c |    4 ++-
 drivers/crypto/caam/caamalg.c        |    6 +++-
 drivers/crypto/geode-aes.c           |   10 ++++---
 drivers/crypto/hifn_795x.c           |   45 +++++++++++++++-------------------
 drivers/crypto/ixp4xx_crypto.c       |   16 ++++++------
 drivers/crypto/mv_cesa.c             |   27 +++++++++-----------
 drivers/crypto/n2_core.c             |   25 +++++++-----------
 drivers/crypto/omap-aes.c            |    6 ++--
 drivers/crypto/omap-sham.c           |   13 ++++-----
 drivers/crypto/s5p-sss.c             |    4 ++-
 10 files changed, 75 insertions(+), 81 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 13f8e1a..3d100e4 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -18,6 +18,8 @@
  * Linux CryptoAPI.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock_types.h>
@@ -1182,7 +1184,7 @@ static int __init crypto4xx_probe(struct platform_device *ofdev)
 		mtdcri(SDR0, PPC460SX_SDR0_SRST,
 		       mfdcri(SDR0, PPC460SX_SDR0_SRST) & ~PPC460SX_CE_RESET);
 	} else {
-		printk(KERN_ERR "Crypto Function Not supported!\n");
+		pr_err("Crypto Function Not supported!\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index a5bc706..9fd808e 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -43,6 +43,8 @@
  * ---------------------
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "compat.h"
 
 #include "regs.h"
@@ -602,9 +604,9 @@ static int aead_setkey(struct crypto_aead *aead,
 	ctx->split_key_pad_len = ALIGN(ctx->split_key_len, 16);
 
 #ifdef DEBUG
-	printk(KERN_ERR "keylen %d enckeylen %d authkeylen %d\n",
+	pr_err("keylen %d enckeylen %d authkeylen %d\n",
 	       keylen, enckeylen, authkeylen);
-	printk(KERN_ERR "split_key_len %d split_key_pad_len %d\n",
+	pr_err("split_key_len %d split_key_pad_len %d\n",
 	       ctx->split_key_len, ctx->split_key_pad_len);
 	print_hex_dump(KERN_ERR, "key in @"xstr(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 219d09c..f2f23d4 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -6,6 +6,8 @@
  * (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
@@ -262,7 +264,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
 				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(op->fallback.cip)) {
-		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
+		pr_err("Error allocating fallback algo %s\n", name);
 		return PTR_ERR(op->fallback.cip);
 	}
 
@@ -373,7 +375,7 @@ static int fallback_init_blk(struct crypto_tfm *tfm)
 			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(op->fallback.blk)) {
-		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
+		pr_err("Error allocating fallback algo %s\n", name);
 		return PTR_ERR(op->fallback.blk);
 	}
 
@@ -550,7 +552,7 @@ geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (ret)
 		goto eecb;
 
-	printk(KERN_NOTICE "geode-aes: GEODE AES engine enabled.\n");
+	pr_notice("GEODE AES engine enabled\n");
 	return 0;
 
  eecb:
@@ -568,7 +570,7 @@ geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
  eenable:
 	pci_disable_device(dev);
 
-	printk(KERN_ERR "geode-aes:  GEODE AES initialization failed.\n");
+	pr_err("GEODE AES initialization failed\n");
 	return ret;
 }
 
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 76368f9..dfd8fbe 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -17,6 +17,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -986,9 +988,8 @@ static void hifn_init_pll(struct hifn_device *dev)
 		freq = simple_strtoul(hifn_pll_ref + 3, NULL, 10);
 	else {
 		freq = 66;
-		printk(KERN_INFO "hifn795x: assuming %uMHz clock speed, "
-				 "override with hifn_pll_ref=%.3s<frequency>\n",
-		       freq, hifn_pll_ref);
+		pr_info("assuming %uMHz clock speed, override with hifn_pll_ref=%.3s<frequency>\n",
+			freq, hifn_pll_ref);
 	}
 
 	m = HIFN_PLL_FCK_MAX / freq;
@@ -1538,14 +1539,13 @@ static int hifn_cipher_walk(struct ablkcipher_request *req,
 				 * Temporary of course...
 				 * Kick author if you will catch this one.
 				 */
-				printk(KERN_ERR "%s: dlen: %u, nbytes: %u,"
-					"slen: %u, offset: %u.\n",
-					__func__, dlen, nbytes, slen, offset);
-				printk(KERN_ERR "%s: please contact author to fix this "
-					"issue, generally you should not catch "
-					"this path under any condition but who "
-					"knows how did you use crypto code.\n"
-					"Thank you.\n",	__func__);
+				pr_err("%s: dlen: %u, nbytes: %u, slen: %u, offset: %u\n",
+				       __func__, dlen, nbytes, slen, offset);
+				pr_err(
+"%s: please contact author to fix this issue.\n"
+"Generally you should not catch this path under any condition.\n"
+"Who knows how did you use crypto code. Thank you.\n",
+				       __func__);
 				BUG();
 			} else {
 				copy += diff + nbytes;
@@ -1686,13 +1686,13 @@ static int hifn_test(struct hifn_device *dev, int encdec, u8 snum)
 	dprintk("\n");
 
 	if (!memcmp(src, fips_aes_ecb_from_zero, sizeof(fips_aes_ecb_from_zero))) {
-		printk(KERN_INFO "%s: AES 128 ECB test has been successfully "
-				"passed.\n", dev->name);
+		pr_info("%s: AES 128 ECB test has been successfully passed\n",
+			dev->name);
 		return 0;
 	}
 
 err_out:
-	printk(KERN_INFO "%s: AES 128 ECB test has been failed.\n", dev->name);
+	pr_info("%s: AES 128 ECB test has failed\n", dev->name);
 	return -1;
 }
 
@@ -1980,7 +1980,7 @@ static irqreturn_t hifn_interrupt(int irq, void *data)
 	if (restart) {
 		u32 puisr = hifn_read_0(dev, HIFN_0_PUISR);
 
-		printk(KERN_WARNING "%s: overflow: r: %d, d: %d, puisr: %08x, d: %u.\n",
+		pr_warn("%s: overflow: r: %d, d: %d, puisr: %08x, d: %u.\n",
 			dev->name, !!(dmacsr & HIFN_DMACSR_R_OVER),
 			!!(dmacsr & HIFN_DMACSR_D_OVER),
 			puisr, !!(puisr & HIFN_PUISR_DSTOVER));
@@ -1993,7 +1993,7 @@ static irqreturn_t hifn_interrupt(int irq, void *data)
 	restart = dmacsr & (HIFN_DMACSR_C_ABORT | HIFN_DMACSR_S_ABORT |
 			HIFN_DMACSR_D_ABORT | HIFN_DMACSR_R_ABORT);
 	if (restart) {
-		printk(KERN_WARNING "%s: abort: c: %d, s: %d, d: %d, r: %d.\n",
+		pr_warn("%s: abort: c: %d, s: %d, d: %d, r: %d\n",
 			dev->name, !!(dmacsr & HIFN_DMACSR_C_ABORT),
 			!!(dmacsr & HIFN_DMACSR_S_ABORT),
 			!!(dmacsr & HIFN_DMACSR_D_ABORT),
@@ -2749,8 +2749,7 @@ static int __init hifn_init(void)
 
 	if (strncmp(hifn_pll_ref, "ext", 3) &&
 	    strncmp(hifn_pll_ref, "pci", 3)) {
-		printk(KERN_ERR "hifn795x: invalid hifn_pll_ref clock, "
-				"must be pci or ext");
+		pr_err("invalid hifn_pll_ref clock, must be pci or ext\n");
 		return -EINVAL;
 	}
 
@@ -2762,9 +2761,7 @@ static int __init hifn_init(void)
 	if (hifn_pll_ref[3] != '\0') {
 		freq = simple_strtoul(hifn_pll_ref + 3, NULL, 10);
 		if (freq < 20 || freq > 100) {
-			printk(KERN_ERR "hifn795x: invalid hifn_pll_ref "
-					"frequency, must be in the range "
-					"of 20-100");
+			pr_err("invalid hifn_pll_ref frequency, must be in the range of 20-100\n");
 			return -EINVAL;
 		}
 	}
@@ -2776,8 +2773,7 @@ static int __init hifn_init(void)
 		return -ENODEV;
 	}
 
-	printk(KERN_INFO "Driver for HIFN 795x crypto accelerator chip "
-			"has been successfully registered.\n");
+	pr_info("Driver for HIFN 795x crypto accelerator chip successfully registered\n");
 
 	return 0;
 }
@@ -2786,8 +2782,7 @@ static void __exit hifn_fini(void)
 {
 	pci_unregister_driver(&hifn_pci_driver);
 
-	printk(KERN_INFO "Driver for HIFN 795x crypto accelerator chip "
-			"has been successfully unregistered.\n");
+	pr_info("Driver for HIFN 795x crypto accelerator chip has been successfully unregistered\n");
 }
 
 module_init(hifn_init);
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 4c20c5b..3e1e061 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
@@ -438,7 +440,7 @@ static int init_ixp_crypto(void)
 
 	if (! ( ~(*IXP4XX_EXP_CFG2) & (IXP4XX_FEATURE_HASH |
 				IXP4XX_FEATURE_AES | IXP4XX_FEATURE_DES))) {
-		printk(KERN_ERR "ixp_crypto: No HW crypto available\n");
+		pr_err("No HW crypto available\n");
 		return ret;
 	}
 	npe_c = npe_request(NPE_ID);
@@ -462,8 +464,7 @@ static int init_ixp_crypto(void)
 
 	switch ((msg[1]>>16) & 0xff) {
 	case 3:
-		printk(KERN_WARNING "Firmware of %s lacks AES support\n",
-				npe_name(npe_c));
+		pr_warn("Firmware of %s lacks AES support\n", npe_name(npe_c));
 		support_aes = 0;
 		break;
 	case 4:
@@ -471,8 +472,8 @@ static int init_ixp_crypto(void)
 		support_aes = 1;
 		break;
 	default:
-		printk(KERN_ERR "Firmware of %s lacks crypto support\n",
-			npe_name(npe_c));
+		pr_err("Firmware of %s lacks crypto support\n",
+		       npe_name(npe_c));
 		return -ENODEV;
 	}
 	/* buffer_pool will also be used to sometimes store the hmac,
@@ -507,7 +508,7 @@ static int init_ixp_crypto(void)
 	return 0;
 
 npe_error:
-	printk(KERN_ERR "%s not responding\n", npe_name(npe_c));
+	pr_err("%s not responding\n", npe_name(npe_c));
 	ret = -EIO;
 err:
 	if (ctx_pool)
@@ -1475,8 +1476,7 @@ static int __init ixp_module_init(void)
 		cra->cra_priority = 300;
 		cra->cra_exit = exit_tfm;
 		if (crypto_register_alg(cra))
-			printk(KERN_ERR "Failed to register '%s'\n",
-				cra->cra_name);
+			pr_err("Failed to register '%s'\n", cra->cra_name);
 		else
 			ixp4xx_algos[i].registered = 1;
 	}
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 597235a..ce97a03 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -6,6 +6,9 @@
  * License: GPLv2
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <linux/crypto.h>
@@ -21,7 +24,6 @@
 
 #include "mv_cesa.h"
 
-#define MV_CESA	"MV-CESA:"
 #define MAX_HW_HASH_SIZE	0xFFFF
 
 /*
@@ -826,9 +828,8 @@ static int mv_cra_hash_init(struct crypto_tfm *tfm, const char *base_hash_name,
 	fallback_tfm = crypto_alloc_shash(fallback_driver_name, 0,
 					  CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback_tfm)) {
-		printk(KERN_WARNING MV_CESA
-		       "Fallback driver '%s' could not be loaded!\n",
-		       fallback_driver_name);
+		pr_warn("Fallback driver '%s' could not be loaded!\n",
+			fallback_driver_name);
 		err = PTR_ERR(fallback_tfm);
 		goto out;
 	}
@@ -839,9 +840,8 @@ static int mv_cra_hash_init(struct crypto_tfm *tfm, const char *base_hash_name,
 		base_hash = crypto_alloc_shash(base_hash_name, 0,
 					       CRYPTO_ALG_NEED_FALLBACK);
 		if (IS_ERR(base_hash)) {
-			printk(KERN_WARNING MV_CESA
-			       "Base driver '%s' could not be loaded!\n",
-			       base_hash_name);
+			pr_warn("Base driver '%s' could not be loaded!\n",
+				base_hash_name);
 			err = PTR_ERR(base_hash);
 			goto err_bad_base;
 		}
@@ -994,7 +994,7 @@ static int mv_probe(struct platform_device *pdev)
 	int ret;
 
 	if (cpg) {
-		printk(KERN_ERR MV_CESA "Second crypto dev?\n");
+		pr_err("Second crypto dev?\n");
 		return -EEXIST;
 	}
 
@@ -1054,15 +1054,13 @@ static int mv_probe(struct platform_device *pdev)
 
 	ret = crypto_register_alg(&mv_aes_alg_ecb);
 	if (ret) {
-		printk(KERN_WARNING MV_CESA
-		       "Could not register aes-ecb driver\n");
+		pr_warn("Could not register aes-ecb driver\n");
 		goto err_irq;
 	}
 
 	ret = crypto_register_alg(&mv_aes_alg_cbc);
 	if (ret) {
-		printk(KERN_WARNING MV_CESA
-		       "Could not register aes-cbc driver\n");
+		pr_warn("Could not register aes-cbc driver\n");
 		goto err_unreg_ecb;
 	}
 
@@ -1070,14 +1068,13 @@ static int mv_probe(struct platform_device *pdev)
 	if (ret == 0)
 		cpg->has_sha1 = 1;
 	else
-		printk(KERN_WARNING MV_CESA "Could not register sha1 driver\n");
+		pr_warn("Could not register sha1 driver\n");
 
 	ret = crypto_register_ahash(&mv_hmac_sha1_alg);
 	if (ret == 0) {
 		cpg->has_hmac_sha1 = 1;
 	} else {
-		printk(KERN_WARNING MV_CESA
-		       "Could not register hmac-sha1 driver\n");
+		pr_warn("Could not register hmac-sha1 driver\n");
 	}
 
 	return 0;
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 8944dab..a5aa768 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -35,7 +35,7 @@
 #define DRV_MODULE_RELDATE	"July 28, 2011"
 
 static char version[] __devinitdata =
-	DRV_MODULE_NAME ".c:v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
+	DRV_MODULE_NAME ".c:v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")";
 
 MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
 MODULE_DESCRIPTION("Niagara2 Crypto driver");
@@ -365,8 +365,8 @@ static int n2_hash_cra_init(struct crypto_tfm *tfm)
 	fallback_tfm = crypto_alloc_ahash(fallback_driver_name, 0,
 					  CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback_tfm)) {
-		pr_warning("Fallback driver '%s' could not be loaded!\n",
-			   fallback_driver_name);
+		pr_warn("Fallback driver '%s' could not be loaded!\n",
+			fallback_driver_name);
 		err = PTR_ERR(fallback_tfm);
 		goto out;
 	}
@@ -402,16 +402,16 @@ static int n2_hmac_cra_init(struct crypto_tfm *tfm)
 	fallback_tfm = crypto_alloc_ahash(fallback_driver_name, 0,
 					  CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback_tfm)) {
-		pr_warning("Fallback driver '%s' could not be loaded!\n",
-			   fallback_driver_name);
+		pr_warn("Fallback driver '%s' could not be loaded!\n",
+			fallback_driver_name);
 		err = PTR_ERR(fallback_tfm);
 		goto out;
 	}
 
 	child_shash = crypto_alloc_shash(n2alg->child_alg, 0, 0);
 	if (IS_ERR(child_shash)) {
-		pr_warning("Child shash '%s' could not be loaded!\n",
-			   n2alg->child_alg);
+		pr_warn("Child shash '%s' could not be loaded!\n",
+			n2alg->child_alg);
 		err = PTR_ERR(child_shash);
 		goto out_free_fallback;
 	}
@@ -836,8 +836,7 @@ static int __n2_crypt_chunk(struct crypto_tfm *tfm, struct n2_crypto_chunk *cp,
 
 	ent = spu_queue_alloc(qp, cp->arr_len);
 	if (!ent) {
-		pr_info("queue_alloc() of %d fails\n",
-			cp->arr_len);
+		pr_info("queue_alloc() of %d fails\n", cp->arr_len);
 		return -EBUSY;
 	}
 
@@ -1993,10 +1992,7 @@ static void free_n2cp(struct n2_crypto *np)
 
 static void __devinit n2_spu_driver_version(void)
 {
-	static int n2_spu_version_printed;
-
-	if (n2_spu_version_printed++ == 0)
-		pr_info("%s", version);
+	pr_info_once("%s\n", version);
 }
 
 static int __devinit n2_crypto_probe(struct platform_device *dev)
@@ -2124,8 +2120,7 @@ static int __devinit n2_mau_probe(struct platform_device *dev)
 
 	mp = alloc_ncp();
 	if (!mp) {
-		dev_err(&dev->dev, "%s: Unable to allocate ncp.\n",
-			full_name);
+		dev_err(&dev->dev, "%s: Unable to allocate ncp\n", full_name);
 		return -ENOMEM;
 	}
 
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 5b970d9..95dad1a 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -12,7 +12,7 @@
  *
  */
 
-#define pr_fmt(fmt) "%s: " fmt, __func__
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
 
 #include <linux/err.h>
 #include <linux/module.h>
@@ -290,7 +290,7 @@ static void omap_aes_dma_callback(int lch, u16 ch_status, void *data)
 	struct omap_aes_dev *dd = data;
 
 	if (ch_status != OMAP_DMA_BLOCK_IRQ) {
-		pr_err("omap-aes DMA error status: 0x%hx\n", ch_status);
+		pr_err("DMA error status: 0x%hx\n", ch_status);
 		dd->err = -EIO;
 		dd->flags &= ~FLAGS_INIT; /* request to re-initialize */
 	} else if (lch == dd->dma_lch_in) {
@@ -936,7 +936,7 @@ static struct platform_driver omap_aes_driver = {
 
 static int __init omap_aes_mod_init(void)
 {
-	pr_info("loading %s driver\n", "omap-aes");
+	pr_info("loading driver\n");
 
 	if (!cpu_class_is_omap2() || omap_type() != OMAP2_DEVICE_TYPE_SEC) {
 		pr_err("Unsupported cpu\n");
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 6399a8f..5352bf1 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -13,7 +13,7 @@
  * Some ideas are from old omap-sha1-md5.c driver.
  */
 
-#define pr_fmt(fmt) "%s: " fmt, __func__
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
 
 #include <linux/err.h>
 #include <linux/device.h>
@@ -887,8 +887,7 @@ static int omap_sham_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 	tctx->fallback = crypto_alloc_shash(alg_name, 0,
 					    CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(tctx->fallback)) {
-		pr_err("omap-sham: fallback driver '%s' "
-				"could not be loaded.\n", alg_name);
+		pr_err("fallback driver '%s' could not be loaded\n", alg_name);
 		return PTR_ERR(tctx->fallback);
 	}
 
@@ -901,8 +900,8 @@ static int omap_sham_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 		bctx->shash = crypto_alloc_shash(alg_base, 0,
 						CRYPTO_ALG_NEED_FALLBACK);
 		if (IS_ERR(bctx->shash)) {
-			pr_err("omap-sham: base driver '%s' "
-					"could not be loaded.\n", alg_base);
+			pr_err("base driver '%s' could not be loaded\n",
+			       alg_base);
 			crypto_free_shash(tctx->fallback);
 			return PTR_ERR(bctx->shash);
 		}
@@ -1101,7 +1100,7 @@ static void omap_sham_dma_callback(int lch, u16 ch_status, void *data)
 	struct omap_sham_dev *dd = data;
 
 	if (ch_status != OMAP_DMA_BLOCK_IRQ) {
-		pr_err("omap-sham DMA error status: 0x%hx\n", ch_status);
+		pr_err("DMA error status: 0x%hx\n", ch_status);
 		dd->err = -EIO;
 		clear_bit(FLAGS_INIT, &dd->flags);/* request to re-initialize */
 	}
@@ -1283,7 +1282,7 @@ static struct platform_driver omap_sham_driver = {
 
 static int __init omap_sham_mod_init(void)
 {
-	pr_info("loading %s driver\n", "omap-sham");
+	pr_info("loading driver\n");
 
 	if (!cpu_class_is_omap2() ||
 		(omap_type() != OMAP2_DEVICE_TYPE_SEC &&
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 3376bca..a809a10 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -11,6 +11,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/module.h>
@@ -630,7 +632,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 			goto err_algs;
 	}
 
-	pr_info("s5p-sss driver registered\n");
+	pr_info("driver registered\n");
 
 	return 0;
 
-- 
1.7.8.111.gad25c.dirty

