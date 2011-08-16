Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1HPGEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 02:04:16 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:53666 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab1HPGEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 02:04:14 -0400
Date: Tue, 16 Aug 2011 14:04:10 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: Re: linux-next: build warning after merge of the final tree
Message-ID: <20110816060410.GA7013@gondor.apana.org.au>
References: <20110816152234.26afbea89bfe896d95177ad7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816152234.26afbea89bfe896d95177ad7@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 03:22:34PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) produced this warning:
> 
> In file included from security/integrity/ima/../integrity.h:16:0,
>                  from security/integrity/ima/ima.h:27,
>                  from security/integrity/ima/ima_policy.c:20:
> include/crypto/sha.h:86:10: warning: 'struct shash_desc' declared inside parameter list
> include/crypto/sha.h:86:10: warning: its scope is only this definition or declaration, which is probably not what you want
> 
> Introduced by commit 7c390170b493 ("crypto: sha1 - export sha1_update for
> reuse").  I guess you need to include crypto/hash.h in crypto/sha.h.

Thanks for the report.

Does this patch fix the problem?

commit 4619b6bdb71362d95810f475cc61a6de9d0b1904
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Aug 16 14:03:05 2011 +0800

    crypto: sha - Fix build error due to crypto_sha1_update
    
    On Tue, Aug 16, 2011 at 03:22:34PM +1000, Stephen Rothwell wrote:
    >
    > After merging the final tree, today's linux-next build (powerpc
    > allyesconfig) produced this warning:
    >
    > In file included from security/integrity/ima/../integrity.h:16:0,
    >                  from security/integrity/ima/ima.h:27,
    >                  from security/integrity/ima/ima_policy.c:20:
    > include/crypto/sha.h:86:10: warning: 'struct shash_desc' declared inside parameter list
    > include/crypto/sha.h:86:10: warning: its scope is only this definition or declaration, which is probably not what you want
    >
    > Introduced by commit 7c390170b493 ("crypto: sha1 - export sha1_update for
    > reuse").  I guess you need to include crypto/hash.h in crypto/sha.h.
    
    This patch fixes this by providing a declaration for struct shash_desc.
    
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 83e6be5..c6c9c1f 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -82,6 +82,8 @@ struct sha512_state {
 	u8 buf[SHA512_BLOCK_SIZE];
 };
 
+struct shash_desc;
+
 extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len);
 
Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
