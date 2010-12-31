Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab0LaAhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 19:37:47 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:50576 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0LaAhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 19:37:46 -0500
Date: Fri, 31 Dec 2010 11:37:35 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20101231003735.GA24101@gondor.apana.org.au>
References: <4D1A8200.4010609@lwfinger.net> <20101229195440.GD5838@darkside.kls.lan> <4D1BD2B0.4020101@lwfinger.net> <20101230012003.GA2665@darkside.kls.lan> <4D1BF056.3060909@lwfinger.net> <20101230143406.GA23219@darkside.kls.lan> <4D1CD161.4040107@lwfinger.net> <20101230204522.GC23219@darkside.kls.lan> <4D1D0C61.9050800@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1D0C61.9050800@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 04:49:05PM -0600, Larry Finger wrote:
>
> Do you see any problems in the code in drivers/net/wireless/b43/main.c or
> drivers/char/hw_random/via-rng.c. As the latter seems to make b43 fail, I am
> suspecting via-rng, but I have no proof.

My suspicion is that VIA's xstore is writing more than 4 bytes as
the list pointer happens to lie immediately after rng->priv which
is where xstore is writing to.

Harald, do you know whether this is documented or is this a known
errata item?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
