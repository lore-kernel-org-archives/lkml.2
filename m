Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab1ADMU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 07:20:26 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:48919 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1ADMUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 07:20:25 -0500
Date: Tue, 4 Jan 2011 13:19:57 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20110104121957.GA27114@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
References: <20101230143406.GA23219@darkside.kls.lan>
 <4D1CD161.4040107@lwfinger.net>
 <20101230204522.GC23219@darkside.kls.lan>
 <4D1D0C61.9050800@lwfinger.net>
 <20101231003735.GA24101@gondor.apana.org.au>
 <4D1D27E7.7030301@lwfinger.net>
 <20101231022550.GA2512@darkside.kls.lan>
 <20101231024653.GA24879@gondor.apana.org.au>
 <20101231085103.GA31935@darkside.kls.lan>
 <20110104043338.GA27604@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20110104043338.GA27604@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Herbert,

On Tue, Jan 04, 2011 at 03:33:38PM +1100, Herbert Xu wrote:
> Can you please test the following patch?
> diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/vi=
a-rng.c

Hmmm, yes - the patch fixes the crashes, i.e. no more crashes with
either sequence of module-loading, cat rng_available works as well,
but...

Having this patch active rngd complains:
	rngd[1435]: rngd 2-unofficial-mt.13 starting up...
	rngd[1435]: block failed FIPS test: 0x1f
	rngd[1435]: block failed FIPS test: 0x1f
	...
	rngd[1435]: stats: entropy added to kernel pool: 0
	rngd[1435]: stats: FIPS 140-2 successes: 0
	rngd[1435]: stats: FIPS 140-2 failures: 10

It doesn't do this without the patch.
The only available rng was via, I did blacklist the others just to be
sure.


regards
   Mario
--=20
The social dynamics of the net are a direct consequence of the fact that
nobody has yet developed a Remote Strangulation Protocol.  -- Larry Wall

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTSMQbRS+e2HeSPbpAQLQxggAgp/V6UfheJo2VYVPQgh5aVw7U/9wpiyh
wL4cVWDXAqKlf4iTA2ArHpwd/l5idgiEAfhMo733Wb7mG31un8hFQ5n0zDHh7nmt
qt+ArghURZyLxNyU7hsm58gv0j77sI0daOkUDBzIfXI8V2efKgZ7KV1vRyWQ/L//
Q7qnPJliWGrXMYx4+ebAft/pf78On+hQvrNrPN3qq/W4m9rTsg2sbI5MWLU8FFJw
Pu4LId1sPaIxO3NBrrydeBkdoLqvM9oBCcjMfMbgdAc9Ip/EZphOwYPEEwSBFzm6
KrnNqsDhdf4NUslWm1aX1w0bmfo1/T7dp2l0/RwgpXDQvRO53jUyPA==
=P0Ex
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
