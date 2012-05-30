Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab2E3WeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 18:34:17 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:35532 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757055Ab2E3WeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 18:34:15 -0400
Date: Thu, 31 May 2012 08:34:02 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?Q?M=FCller?= 
	<Tilo.Mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler
 implementation
Message-ID: <20120530223402.GA15637@gondor.apana.org.au>
References: <20120527145112.GF17705@kronos.redsun>
 <m2396il7xc.fsf@firstfloor.org>
 <20120530103025.19252e1urui8sfb4@www.81.fi>
 <20120530113235.GO17705@kronos.redsun>
 <20120530153949.GS27374@one.firstfloor.org>
 <20120530212911.GA14884@gondor.apana.org.au>
 <20120530214006.GZ27374@one.firstfloor.org>
 <20120530214448.GA15031@gondor.apana.org.au>
 <20120530215537.GA27374@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530215537.GA27374@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 11:55:37PM +0200, Andi Kleen wrote:
> On Thu, May 31, 2012 at 07:44:48AM +1000, Herbert Xu wrote:
> > On Wed, May 30, 2012 at 11:40:06PM +0200, Andi Kleen wrote:
> > >
> > > > What we could do is to use the cpuid-based probing when an algorithm
> > > > is needed to selectively load the relevant implementations instead
> > > > of all of them.  However, for most algorithms it won't make that
> > > > big a difference since all the available ones will be loaded anyway.
> > > 
> > > Yes cpuid probing does that.
> > 
> > I was under the impression that using cpuid meant that the algorithm
> > would be loaded regardless of whether it has been requested, as long
> > as the cpuid matches.
> 
> It loads it always correct.

You mean with cpuid it'll always load the algorithm if it is
available even if noone is using it? Then it's probably not a
good fit for serpent.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
