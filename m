Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032281Ab2COUMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:12:05 -0400
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:50239 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032279Ab2COUL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:11:59 -0400
Subject: [PATCH 2/2] crypto: twofish-x86_64-3way - module init/exit functions
 should be static
To: Herbert Xu <herbert@gondor.hengli.com.au>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Mar 2012 22:11:57 +0200
Message-ID: <20120315201157.11667.30754.stgit@localhost6.localdomain6>
In-Reply-To: <4F620F37.4070404@xenotime.net>
References: <4F620F37.4070404@xenotime.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This caused conflict with camellia-x86_64 when compiled into kernel, same
function names and not static.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/twofish_glue_3way.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 408fc0c..922ab24 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -668,7 +668,7 @@ static int force;
 module_param(force, int, 0);
 MODULE_PARM_DESC(force, "Force module load, ignore CPU blacklist");
 
-int __init init(void)
+static int __init init(void)
 {
 	if (!force && is_blacklisted_cpu()) {
 		printk(KERN_INFO
@@ -681,7 +681,7 @@ int __init init(void)
 	return crypto_register_algs(tf_algs, ARRAY_SIZE(tf_algs));
 }
 
-void __exit fini(void)
+static void __exit fini(void)
 {
 	crypto_unregister_algs(tf_algs, ARRAY_SIZE(tf_algs));
 }

