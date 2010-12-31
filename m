Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab0LaPVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 10:21:45 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41704 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab0LaPVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 10:21:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=FlkhbpLH0q4pJynoxAdSt4IKViPRiPLYcYKeBpIHieVvA+mgSMqR8RKaxAJZarlDUt
         vHZuHap3tzvep27M+Q2Pbyyqs7KII5SwMkJfJPxEE1dUpdCS/T1SInqlzeovtsYj6r9a
         +d2quHk1vikDSsNnKZDah5HG8LO+f2qG9cAj8=
Message-ID: <4D1DF505.3040005@gmail.com>
Date: Fri, 31 Dec 2010 16:21:41 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: dont return PTR_ERR() of wrong pointer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a PTR_ERR() return of the wrong pointer

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/crypto/mv_cesa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 7d279e5..c99305a 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -857,7 +857,7 @@ static int mv_cra_hash_init(struct crypto_tfm *tfm, const char *base_hash_name,
 			printk(KERN_WARNING MV_CESA
 			       "Base driver '%s' could not be loaded!\n",
 			       base_hash_name);
-			err = PTR_ERR(fallback_tfm);
+			err = PTR_ERR(base_hash);
 			goto err_bad_base;
 		}
 	}
