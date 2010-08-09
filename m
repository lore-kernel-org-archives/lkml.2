Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0HIO0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:26:16 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:46557 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0HIO0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:26:15 -0400
Date: Mon, 9 Aug 2010 10:26:07 -0400
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Miller <davem@davemloft.net>
Cc: segooon@gmail.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: n2 RNG driver bogus cast removal
Message-ID: <20100809142607.GA19862@gondor.apana.org.au>
References: <20100809.004514.73697921.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100809.004514.73697921.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 12:45:14AM -0700, David Miller wrote:
> 
> Kulikov, can you at least build test your patches?  Casts are not
> always incorrect, particularly when private cookies are "unsigned
> long" as is the case here:
> 
> drivers/char/hw_random/n2-drv.c: In function ‘n2rng_data_read’:
> drivers/char/hw_random/n2-drv.c:390: warning: initialization makes pointer from integer without a cast
> 
> Herbert, please revert this change, thanks.  And I suspect there
> might be more of these hwrng driver duds that went into the tree,
> it's worth checking out. :-)

Thanks Dave.  I'll revert it for now.

However, it probably makes sense to change priv into a void *
as most drivers use it as a pointer instead of an integer.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
