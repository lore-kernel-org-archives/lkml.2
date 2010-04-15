Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0DORSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 13:18:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35424 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab0DORSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 13:18:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LGpVrqFWTDUWCtGGmDQ+Fb+8JNC5C/GN8dcmw+tOmYF1XStZUbAuUZiFs0DnsNRwG0
         8HGwmpH7+2331GDKEuUrukPZ9O9OLa+yCfcuzkq5ggb5rq936L/TTGA0jHZ9h3/aLGQt
         T87wCZF1BW06sDo3q0xr0Ogl8eurkXFuafr+Q=
From: Chihau Chau <chihau@gmail.com>
To: herbert@gondor.hengli.com.au
Cc: davem@davemloft.net, roel.kluin@gmail.com, sebastian@breakpoint.cc,
       linux-geode@lists.infradead.org, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Crypto: geode-aes: Fix some code style issues
Date: Thu, 15 Apr 2010 13:17:59 -0400
Message-Id: <1271351879-22805-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This fixes some code style issues like:

- Use #include <linux/io.h> instead of <asm/io.h> and #include
  <linux/delay.h> instead of <asm/delay.h>

- Use "foo *bar" instead of "foo * bar"

- Add a space after the for or while sentence and before the open
  parenthesis '('

- Don't use assignments in a if condition

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/crypto/geode-aes.c |   36 ++++++++++++++++++++----------------
 1 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index c7a5a43..09389dd 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -15,14 +15,14 @@
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
 
-#include <asm/io.h>
-#include <asm/delay.h>
+#include <linux/io.h>
+#include <linux/delay.h>
 
 #include "geode-aes.h"
 
 /* Static structures */
 
-static void __iomem * _iobase;
+static void __iomem *_iobase;
 static spinlock_t lock;
 
 /* Write a 128 bit field (either a writable key or IV) */
@@ -30,7 +30,7 @@ static inline void
 _writefield(u32 offset, void *value)
 {
 	int i;
-	for(i = 0; i < 4; i++)
+	for (i = 0; i < 4; i++)
 		iowrite32(((u32 *) value)[i], _iobase + offset + (i * 4));
 }
 
@@ -39,7 +39,7 @@ static inline void
 _readfield(u32 offset, void *value)
 {
 	int i;
-	for(i = 0; i < 4; i++)
+	for (i = 0; i < 4; i++)
 		((u32 *) value)[i] = ioread32(_iobase + offset + (i * 4));
 }
 
@@ -59,7 +59,7 @@ do_crypt(void *src, void *dst, int len, u32 flags)
 	do {
 		status = ioread32(_iobase + AES_INTR_REG);
 		cpu_relax();
-	} while(!(status & AES_INTRA_PENDING) && --counter);
+	} while (!(status & AES_INTRA_PENDING) && --counter);
 
 	/* Clear the event */
 	iowrite32((status & 0xFF) | AES_INTRA_PENDING, _iobase + AES_INTR_REG);
@@ -317,7 +317,7 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 	err = blkcipher_walk_virt(desc, &walk);
 	op->iv = walk.iv;
 
-	while((nbytes = walk.nbytes)) {
+	while ((nbytes = walk.nbytes)) {
 		op->src = walk.src.virt.addr,
 		op->dst = walk.dst.virt.addr;
 		op->mode = AES_MODE_CBC;
@@ -349,7 +349,7 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 	err = blkcipher_walk_virt(desc, &walk);
 	op->iv = walk.iv;
 
-	while((nbytes = walk.nbytes)) {
+	while ((nbytes = walk.nbytes)) {
 		op->src = walk.src.virt.addr,
 		op->dst = walk.dst.virt.addr;
 		op->mode = AES_MODE_CBC;
@@ -429,7 +429,7 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
-	while((nbytes = walk.nbytes)) {
+	while ((nbytes = walk.nbytes)) {
 		op->src = walk.src.virt.addr,
 		op->dst = walk.dst.virt.addr;
 		op->mode = AES_MODE_ECB;
@@ -459,7 +459,7 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
-	while((nbytes = walk.nbytes)) {
+	while ((nbytes = walk.nbytes)) {
 		op->src = walk.src.virt.addr,
 		op->dst = walk.dst.virt.addr;
 		op->mode = AES_MODE_ECB;
@@ -518,11 +518,12 @@ static int __devinit
 geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	int ret;
-
-	if ((ret = pci_enable_device(dev)))
+	ret = pci_enable_device(dev);
+	if (ret)
 		return ret;
 
-	if ((ret = pci_request_regions(dev, "geode-aes")))
+	ret = pci_request_regions(dev, "geode-aes");
+	if (ret)
 		goto eenable;
 
 	_iobase = pci_iomap(dev, 0, 0);
@@ -537,13 +538,16 @@ geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	/* Clear any pending activity */
 	iowrite32(AES_INTR_PENDING | AES_INTR_MASK, _iobase + AES_INTR_REG);
 
-	if ((ret = crypto_register_alg(&geode_alg)))
+	ret = crypto_register_alg(&geode_alg);
+	if (ret)
 		goto eiomap;
 
-	if ((ret = crypto_register_alg(&geode_ecb_alg)))
+	ret = crypto_register_alg(&geode_ecb_alg);
+	if (ret)
 		goto ealg;
 
-	if ((ret = crypto_register_alg(&geode_cbc_alg)))
+	ret = crypto_register_alg(&geode_cbc_alg);
+	if (ret)
 		goto eecb;
 
 	printk(KERN_NOTICE "geode-aes: GEODE AES engine enabled.\n");
-- 
1.5.6.3

