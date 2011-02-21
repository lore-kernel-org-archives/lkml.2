Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1BUO1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:27:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:33443 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab1BUO1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:27:37 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH] crypto: do not attempt to write to readonly variable
Date: Mon, 21 Feb 2011 15:27:22 +0100
Message-Id: <1298298442-24697-1-git-send-email-dsterba@suse.cz>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit da7f033ddc9fdeb (”crypto: cryptomgr - Add test infrastructure”) added a
const to variable which is later used as target buffer of memcpy.

crypto/tcrypt.c:217:12: warning: passing 'const char (*)[128]' to parameter of type 'void *' discards qualifiers
                                memset(&iv, 0xff, iv_len);


crypto/tcrypt.c:test_cipher_speed()

-       unsigned char *key, iv[128];
+       const char *key, iv[128];
...
        memset(&iv, 0xff, iv_len);

CC: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 crypto/tcrypt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 9aac5e5..e912ea5 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -146,7 +146,8 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 			      unsigned int tcount, u8 *keysize)
 {
 	unsigned int ret, i, j, iv_len;
-	const char *key, iv[128];
+	const char *key;
+	char iv[128];
 	struct crypto_blkcipher *tfm;
 	struct blkcipher_desc desc;
 	const char *e;
-- 
1.7.4

