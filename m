Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab1AWH5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 02:57:01 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:49306 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab1AWH5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 02:57:00 -0500
Date: Sun, 23 Jan 2011 18:56:46 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Huang Ying <ying.huang@intel.com>,
        Adrian Hoban <adrian.hoban@intel.com>,
        Gabriele Paoloni <gabriele.paoloni@intel.com>,
        aidan.o.mahony@intel.com
Subject: Re: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
	rfc4106_set_hash_subkey().
Message-ID: <20110123075646.GA19175@gondor.apana.org.au>
References: <alpine.LNX.2.00.1101161527440.8049@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1101161527440.8049@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 03:38:47PM +0100, Jesper Juhl wrote:
> There's a small memory leak in 
> arch/x86/crypto/aesni-intel_glue.c::rfc4106_set_hash_subkey(). If the call 
> to kmalloc() fails and returns NULL then the memory allocated previously 
> by ablkcipher_request_alloc() is not freed when we leave the function.
> 
> I could have just added a call to ablkcipher_request_free() before we 
> return -ENOMEM, but that started to look too much like the code we 
> already had at the end of the function, so I chose instead to rework the 
> code a bit so that there are now a few labels at the end that we goto when 
> various allocations fail, so we don't have to repeat the same blocks of 
> code (this also reduces the object code size slightly).
> 
> Please review and consider merging.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
