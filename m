Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1G1O60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:58:26 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:60045 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab1G1O6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:58:25 -0400
Date: Thu, 28 Jul 2011 22:58:12 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Mathias Krause <minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] crypto, sha1: export sha1_update for reuse
Message-ID: <20110728145812.GA8396@gondor.apana.org.au>
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com> <1311529994-7924-2-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311529994-7924-2-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 07:53:13PM +0200, Mathias Krause wrote:
>
> diff --git a/include/crypto/sha.h b/include/crypto/sha.h
> index 069e85b..7c46d0c 100644
> --- a/include/crypto/sha.h
> +++ b/include/crypto/sha.h
> @@ -82,4 +82,9 @@ struct sha512_state {
>  	u8 buf[SHA512_BLOCK_SIZE];
>  };
>  
> +#if defined(CONFIG_CRYPTO_SHA1) || defined (CONFIG_CRYPTO_SHA1_MODULE)
> +extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
> +			      unsigned int len);
> +#endif

Please remove the unnecessary #if.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
