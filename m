Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab0HKX7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:35 -0400
Received: from kroah.org ([198.145.64.141]:43635 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759265Ab0HKX7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:12 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:03 2010
Message-Id: <20100811235503.744306589@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Song Youquan <youquan.song@intel.com>,
        Hang Ying <ying.huang@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [089/111] crypto: testmgr - Fix complain about lack test for internal used algorithm
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Song Youquan <youquan.song@intel.com>

commit 863b557a88f8c033f7419fabafef4712a5055f85 upstream.

When load aesni-intel and ghash_clmulni-intel driver,kernel will complain no
 test for some internal used algorithm.
The strange information as following:

alg: No test for __aes-aesni (__driver-aes-aesni)
alg: No test for __ecb-aes-aesni (__driver-ecb-aes-aesni)
alg: No test for __cbc-aes-aesni (__driver-cbc-aes-aesni)
alg: No test for __ecb-aes-aesni (cryptd(__driver-ecb-aes-aesni)
alg: No test for __ghash (__ghash-pclmulqdqni)
alg: No test for __ghash (cryptd(__ghash-pclmulqdqni))

This patch add NULL test entries for these algorithm and driver.

Signed-off-by: Song Youquan <youquan.song@intel.com>
Signed-off-by: Hang Ying <ying.huang@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/testmgr.c |   84 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1477,9 +1477,54 @@ static int alg_test_cprng(const struct a
 	return err;
 }
 
+static int alg_test_null(const struct alg_test_desc *desc,
+			     const char *driver, u32 type, u32 mask)
+{
+	return 0;
+}
+
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
 	{
+		.alg = "__driver-cbc-aes-aesni",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
+		.alg = "__driver-ecb-aes-aesni",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
+		.alg = "__ghash-pclmulqdqni",
+		.test = alg_test_null,
+		.suite = {
+			.hash = {
+				.vecs = NULL,
+				.count = 0
+			}
+		}
+	}, {
 		.alg = "ansi_cprng",
 		.test = alg_test_cprng,
 		.fips_allowed = 1,
@@ -1623,6 +1668,30 @@ static const struct alg_test_desc alg_te
 			}
 		}
 	}, {
+		.alg = "cryptd(__driver-ecb-aes-aesni)",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
+		.alg = "cryptd(__ghash-pclmulqdqni)",
+		.test = alg_test_null,
+		.suite = {
+			.hash = {
+				.vecs = NULL,
+				.count = 0
+			}
+		}
+	}, {
 		.alg = "ctr(aes)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
@@ -1668,6 +1737,21 @@ static const struct alg_test_desc alg_te
 				}
 			}
 		}
+	}, {
+		.alg = "ecb(__aes-aesni)",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
 	}, {
 		.alg = "ecb(aes)",
 		.test = alg_test_skcipher,


