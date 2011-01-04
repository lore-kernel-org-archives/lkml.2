Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab1ADXfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:35:21 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:48890 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1ADXfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:35:19 -0500
Date: Wed, 5 Jan 2011 00:35:05 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20110104233505.GA1815@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
References: <4D1D27E7.7030301@lwfinger.net>
 <20101231022550.GA2512@darkside.kls.lan>
 <20101231024653.GA24879@gondor.apana.org.au>
 <20101231085103.GA31935@darkside.kls.lan>
 <20110104043338.GA27604@gondor.apana.org.au>
 <20110104121957.GA27114@darkside.kls.lan>
 <20110104123824.GA31557@gondor.apana.org.au>
 <20110104125722.GC27114@darkside.kls.lan>
 <20110104224238.GA4978@gondor.apana.org.au>
 <20110104230644.GJ27114@darkside.kls.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20110104230644.GJ27114@darkside.kls.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 05, 2011 at 12:06:44AM +0100, Mario 'BitKoenig' Holbe wrote:
> On Wed, Jan 05, 2011 at 09:42:38AM +1100, Herbert Xu wrote:
> > Can you please try this patch against vanilla to print out the
> > raw output of xstore?
> 00000000  00 ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |............=
=2E...|

Btw: the same with vanilla 2.6.37-rc7 and only the printk in xstore()
=66rom your 2nd patch:

# hexdump -n 16 -C /dev/hwrng
00000000  2b f3 16 07 e8 57 1a a9  d2 3e 7f ad 0e 78 75 7f  |+....W...>...x=
u.|
00000010
#=20


kern.log meanwhile (lines numbered):

     1  Jan  5 00:27:09 ideapad kernel: [  122.489475] 0x25ba3b2b
     2  Jan  5 00:27:09 ideapad kernel: [  122.489486] 0xe68ae2f3
     3  Jan  5 00:27:09 ideapad kernel: [  122.489489] 0x0
     4  Jan  5 00:27:09 ideapad kernel: [  122.489502] 0x75621016
     5  Jan  5 00:27:09 ideapad kernel: [  122.489505] 0x0
     6  Jan  5 00:27:09 ideapad kernel: [  122.489518] 0x727edc07
     7  Jan  5 00:27:09 ideapad kernel: [  122.489520] 0x0
     8  Jan  5 00:27:09 ideapad kernel: [  122.489534] 0x851b82e8
     9  Jan  5 00:27:09 ideapad kernel: [  122.491241] 0xfba49c57
    10  Jan  5 00:27:09 ideapad kernel: [  122.491245] 0x0
    11  Jan  5 00:27:09 ideapad kernel: [  122.491258] 0xc63eca1a
=2E..
  8156  Jan  5 00:27:10 ideapad kernel: [  122.782215] 0x0
  8157  Jan  5 00:27:10 ideapad kernel: [  122.782228] 0xb736d99b
  8158  Jan  5 00:27:10 ideapad kernel: [  122.782230] 0x0
  8159  Jan  5 00:27:10 ideapad kernel: [  122.782243] 0x339211fd
  8160  Jan  5 00:27:10 ideapad kernel: [  122.782246] 0x0
  8161  Jan  5 00:27:10 ideapad kernel: [  122.782258] 0x12f898d1
  8162  Jan  5 00:27:10 ideapad kernel: [  122.782261] 0x0
  8163  Jan  5 00:27:10 ideapad kernel: [  122.782273] 0xc73fcdda


Mario
--=20
The question of whether a computer can think is no more interesting than
the question of whether a submarine can swim.          -- E. W. Dijkstra

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTSOuqRS+e2HeSPbpAQJ6pAf/Ss89leAKaMHfemOMWO9ldJmOi7WlPvsv
z8JlPlfHlfZI7LAdtL6Vaz1JW/HfVmychmE8tA19wVcax84a1FsiJKWXuQ1WQBxf
iKoJ+7VM9790L4P0wF8niTDjP24Uczq9Aovt7U3btzrUDn/AhIgERlEAfR6zjYik
v8219tehAH3K4MycDz8S1zwRPfRTScEPfsIrwlgEioat3ChVjLIRSHUJfnEw5V/a
cTLtg6S5Dp0ddJuabEifPQYjBlDHHj6Bu8efxNwfgbvxzNiK9CWdhXHIMFgKDy71
pKc4REpjncw9N03CQFpZhwmOaJFSyRhZjik35yE4Vg3uNyRuLC67zQ==
=HIXo
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
