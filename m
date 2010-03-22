Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab0CVNVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:21:43 -0400
Received: from a.mx.secunet.com ([213.68.205.161]:60577 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab0CVNVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:21:41 -0400
Date: Mon, 22 Mar 2010 14:23:42 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Carpenter <error27@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] pcrypt: handle crypto_get_attr_type() errors
Message-ID: <20100322132342.GJ20508@secunet.com>
References: <20100321092847.GJ5331@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100321092847.GJ5331@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Mar 2010 13:21:39.0038 (UTC) FILETIME=[9ABCBFE0:01CAC9C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 12:28:47PM +0300, Dan Carpenter wrote:
> crypto_get_attr_type() can returns ERR_PTRs if there is a problem. 
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> index 8020124..41bd80f 100644
> --- a/crypto/pcrypt.c
> +++ b/crypto/pcrypt.c
> @@ -322,6 +322,8 @@ static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb)
>  	struct crypto_attr_type *algt;
>  
>  	algt = crypto_get_attr_type(tb);
> +	if (IS_ERR(algt))
> +		return ERR_CAST(algt);
>  
>  	alg = crypto_get_attr_alg(tb, algt->type,
>  				  (algt->mask & CRYPTO_ALG_TYPE_MASK));

I've just noticed that we are calling crypto_get_attr_type already in
pcrypt_alloc, so perhaps we could just pass the type and mask to
pcrypt_alloc_aead. Then we can remove this second call to
crypto_get_attr_type completely.

Steffen
