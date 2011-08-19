Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab1HSIMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 04:12:18 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:45638 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1HSIMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 04:12:12 -0400
Date: Fri, 19 Aug 2011 16:12:08 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aesni-intel - Add ivsize to ablk_ecb_alg
Message-ID: <20110819081207.GA3954@gondor.apana.org.au>
References: <20110811164040.GB2167@zod.bos.redhat.com> <20110815071528.GA29656@gondor.apana.org.au> <20110815115038.GA2227@zod.bos.redhat.com> <20110816123227.GB9413@gondor.apana.org.au> <20110818174425.GN2227@zod.bos.redhat.com> <20110819000229.GA1076@gondor.apana.org.au> <20110819021516.GU2227@zod.bos.redhat.com> <20110819073224.GA3658@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819073224.GA3658@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 03:32:24PM +0800, Herbert Xu wrote:
> 
> Meanwhile I'll make a patch that ensures cryptd is registered
> before aesni.

Please try this patch.  Thanks!

commit 9d4c522a113f6caa8b792ae829a25490fa87b1a2
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Aug 19 16:11:23 2011 +0800

    crypto: cryptd - Use subsys_initcall to prevent races with aesni
    
    As cryptd is depeneded on by other algorithms such as aesni-intel,
    it needs to be registered before them.  When everything is built
    as modules, this occurs naturally.  However, for this to work when
    they are built-in, we need to use subsys_initcall in cryptd.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index e46d21a..671d4d6 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -945,7 +945,7 @@ static void __exit cryptd_exit(void)
 	crypto_unregister_template(&cryptd_tmpl);
 }
 
-module_init(cryptd_init);
+subsys_initcall(cryptd_init);
 module_exit(cryptd_exit);
 
 MODULE_LICENSE("GPL");
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
