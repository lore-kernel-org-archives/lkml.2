Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab0CUJ3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 05:29:00 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:53744 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab0CUJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 05:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=cj/b64PxIh4No89o5Fyi2bEAwbOufEXK9hK00sR4drjv451vAs4jTQBCfQJWiCGGTH
         m8mGuuRjKFLfvUBfLeNT/xMTua7vkWKUuaS6ZVW5dI2nArOnN66MDciVqdw3avq/oXSE
         mKdN4+8SnFpkSeA/nWOo1k3B4pwcQnLP7puwI=
Date: Sun, 21 Mar 2010 12:28:47 +0300
From: Dan Carpenter <error27@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
       Steffen Klassert <steffen.klassert@secunet.com>,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] pcrypt: handle crypto_get_attr_type() errors
Message-ID: <20100321092847.GJ5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crypto_get_attr_type() can returns ERR_PTRs if there is a problem. 

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 8020124..41bd80f 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -322,6 +322,8 @@ static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb)
 	struct crypto_attr_type *algt;
 
 	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return ERR_CAST(algt);
 
 	alg = crypto_get_attr_alg(tb, algt->type,
 				  (algt->mask & CRYPTO_ALG_TYPE_MASK));
