Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab1JZMeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 08:34:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55245 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811Ab1JZMeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 08:34:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 26 Oct 2011 14:33:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 25 (crypto)
Message-ID: <20111026143347.462fea95@stein>
In-Reply-To: <20111026062717.GA10230@gondor.apana.org.au>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
	<4EA75759.3050900@xenotime.net>
	<20111026062717.GA10230@gondor.apana.org.au>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 26 Herbert Xu wrote:
> On Tue, Oct 25, 2011 at 05:42:01PM -0700, Randy Dunlap wrote:
> > On 10/25/11 02:36, Stephen Rothwell wrote:
> > > Hi all,
> > 
> > 
> > When CONFIG_NET is not enabled:
> 
> Thanks, I'll add this patch.
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index a8442dc..259dea9 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -103,6 +103,7 @@ config CRYPTO_MANAGER2
>  config CRYPTO_USER
>  	tristate "Userspace cryptographic algorithm configuration"
>  	select CRYPTO_MANAGER
> +	select NET
>  	help
>  	  Userapace configuration for cryptographic instantiations such as
>  	  cbc(aes).
> 
> Cheers,

If you do it this way, you also need to select everything on which NET
depends on.  In v3.1, that would be (only) NLATTR which in turn does not
depend on anything else.

Furthermore, I am noticing in v3.1 that CRYPTO_MANAGER selects
CRYPTO_MANAGER2 which in turn has the following dependencies:

config CRYPTO_MANAGER2
	def_tristate CRYPTO_MANAGER || (CRYPTO_MANAGER!=n && CRYPTO_ALGAPI=y)
	select CRYPTO_AEAD2
	select CRYPTO_HASH2
	select CRYPTO_BLKCIPHER2
	select CRYPTO_PCOMP2

I think you need to copy those dependencies into config CRYPTO_MANAGER.
-- 
Stefan Richter
-=====-==-== =-=- ==-=-
http://arcgraph.de/sr/
