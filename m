Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1KCGQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 02:16:41 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:42509 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab1KCGQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 02:16:37 -0400
Date: Thu, 3 Nov 2011 17:16:28 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Luis Henriques <henrix@camandro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the crypto-current
	tree
Message-ID: <20111103061628.GA12678@gondor.apana.org.au>
References: <20111101115851.2e37ac680db78bdba0661691@canb.auug.org.au> <20111102200900.GA3454@hades> <20111102233936.GA10058@gondor.apana.org.au> <20111103055824.GC22141@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103055824.GC22141@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 06:58:24AM +0100, Steffen Klassert wrote:
> On Thu, Nov 03, 2011 at 10:39:36AM +1100, Herbert Xu wrote:
> > On Wed, Nov 02, 2011 at 08:09:13PM +0000, Luis Henriques wrote:
> > >
> > > I'm not sure if this is related, but I am currently unable to build mainline
> > > kernel when disabling CONFIG_NET.  This seems to be due to the patch serie:
> > > 
> > > http://news.gmane.org/gmane.linux.kernel.cryptoapi/cutoff=6228
> > > 
> > > For instance, commit 6ad414fe710d4fd3a8c8c6c2ad8fefcfcc207968 adds a dependency
> > > over function nla_put(), which is only defined when CONFIG_NET is enabled.
> > 
> > Indeed, I missed the dependency in the report functions which
> > is built even when CRYPTO_USER is turned off.
> > 
> > Does this patch fix the problem for you?
> > 
> 
> Hm, did you forget to add the patch to the mail?

Probably :)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 527a857..cdba95c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -38,6 +38,7 @@ config CRYPTO_ALGAPI
 
 config CRYPTO_ALGAPI2
 	tristate
+	select NLATTR
 
 config CRYPTO_AEAD
 	tristate

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
