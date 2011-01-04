Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab1ADMig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 07:38:36 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:42579 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1ADMif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 07:38:35 -0500
Date: Tue, 4 Jan 2011 23:38:24 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20110104123824.GA31557@gondor.apana.org.au>
References: <4D1CD161.4040107@lwfinger.net> <20101230204522.GC23219@darkside.kls.lan> <4D1D0C61.9050800@lwfinger.net> <20101231003735.GA24101@gondor.apana.org.au> <4D1D27E7.7030301@lwfinger.net> <20101231022550.GA2512@darkside.kls.lan> <20101231024653.GA24879@gondor.apana.org.au> <20101231085103.GA31935@darkside.kls.lan> <20110104043338.GA27604@gondor.apana.org.au> <20110104121957.GA27114@darkside.kls.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104121957.GA27114@darkside.kls.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 01:19:57PM +0100, Mario 'BitKoenig' Holbe wrote:
>
> Hmmm, yes - the patch fixes the crashes, i.e. no more crashes with
> either sequence of module-loading, cat rng_available works as well,
> but...
> 
> Having this patch active rngd complains:
> 	rngd[1435]: rngd 2-unofficial-mt.13 starting up...
> 	rngd[1435]: block failed FIPS test: 0x1f
> 	rngd[1435]: block failed FIPS test: 0x1f
> 	...
> 	rngd[1435]: stats: entropy added to kernel pool: 0
> 	rngd[1435]: stats: FIPS 140-2 successes: 0
> 	rngd[1435]: stats: FIPS 140-2 failures: 10
> 
> It doesn't do this without the patch.
> The only available rng was via, I did blacklist the others just to be
> sure.

Hmm, can you print out what it's actually producing (e.g., by
stracing rngd)?

Can you also double-check that this doesn't happen with Larry's
patch?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
