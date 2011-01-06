Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1AFNfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 08:35:52 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:38177 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab1AFNfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 08:35:51 -0500
Date: Fri, 7 Jan 2011 00:35:41 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20110106133541.GA22030@gondor.apana.org.au>
References: <20110104123824.GA31557@gondor.apana.org.au> <20110104125722.GC27114@darkside.kls.lan> <20110104224238.GA4978@gondor.apana.org.au> <20110104230644.GJ27114@darkside.kls.lan> <20110105003020.GA5751@gondor.apana.org.au> <20110105035222.GA8762@darkside.kls.lan> <20110105054735.GA7773@gondor.apana.org.au> <20110105131621.GA24769@darkside.kls.lan> <20110106061241.GA18939@gondor.apana.org.au> <20110106131516.GB8803@darkside.kls.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106131516.GB8803@darkside.kls.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 02:15:16PM +0100, Mario 'BitKoenig' Holbe wrote:
>
> The patch helps. No crashes, meaningful random data - perfect.
> I still have 2 small annotations...

Thanks for testing!

> 1. Having ECX on the clobber-list is not really necessary.
> XSTORE doesn't touch ECX at all.
> REP XSTORE would touch it, but for this ECX would be an input anyways.

The documentation wasn't clear whether ECX would be updated without
the REP prefix so I included it to be on the safe side.  Unfortunately
my only VIA machine is on another continent at the moment so I can't
test it myself.  Can you verify that ECX isn't changed without the
REP prefix?

> 2. Would you mind doing the same for EDX as you did for EDI?
> This doesn't really change anything currently, but will probably help
> avoiding a debug-session like ours somewhere in the future :)

According to my documentation EDX isn't be modified (nor would it
make sense as it would break REP XSTORE).  Are you seeing anything
different?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
