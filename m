Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab1KCKuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 06:50:18 -0400
Received: from onza.mythic-beasts.com ([93.93.131.30]:42205 "EHLO
	onza.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab1KCKuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 06:50:16 -0400
X-Greylist: delayed 2052 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Nov 2011 06:50:15 EDT
Date: Thu, 3 Nov 2011 10:15:54 +0000
From: Luis Henriques <henrix@camandro.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the crypto-current
	tree
Message-ID: <20111103101554.GA17569@onza.mythic-beasts.com>
References: <20111101115851.2e37ac680db78bdba0661691@canb.auug.org.au> <20111102200900.GA3454@hades> <20111102233936.GA10058@gondor.apana.org.au> <20111103055824.GC22141@secunet.com> <20111103061628.GA12678@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103061628.GA12678@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 05:16:28PM +1100, Herbert Xu wrote:
> On Thu, Nov 03, 2011 at 06:58:24AM +0100, Steffen Klassert wrote:
> > On Thu, Nov 03, 2011 at 10:39:36AM +1100, Herbert Xu wrote:
> > > On Wed, Nov 02, 2011 at 08:09:13PM +0000, Luis Henriques wrote:
> > > >
> > > > I'm not sure if this is related, but I am currently unable to build mainline
> > > > kernel when disabling CONFIG_NET.  This seems to be due to the patch serie:
> > > > 
> > > > http://news.gmane.org/gmane.linux.kernel.cryptoapi/cutoff=6228
> > > > 
> > > > For instance, commit 6ad414fe710d4fd3a8c8c6c2ad8fefcfcc207968 adds a dependency
> > > > over function nla_put(), which is only defined when CONFIG_NET is enabled.
> > > 
> > > Indeed, I missed the dependency in the report functions which
> > > is built even when CRYPTO_USER is turned off.
> > > 
> > > Does this patch fix the problem for you?
> > > 
> > 
> > Hm, did you forget to add the patch to the mail?
> 
> Probably :)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 527a857..cdba95c 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -38,6 +38,7 @@ config CRYPTO_ALGAPI
>  
>  config CRYPTO_ALGAPI2
>  	tristate
> +	select NLATTR
>  
>  config CRYPTO_AEAD
>  	tristate

No, this did not solved the problem; build still fails.  The problem is
that, in lib/nlattr.c, we have:

#ifdef CONFIG_NET
...
EXPORT_SYMBOL(nla_put);
...
#endif

So, I still have an undefined reference to nla_put.

BTW, I'm not talking about the -next tree, so this problem may or may not
be the same one reported by Stephen.

Cheers,
--
Luis Henriques

