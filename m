Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab1AEBqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 20:46:03 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:46829 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1AEBqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 20:46:01 -0500
Date: Wed, 5 Jan 2011 02:45:39 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20110105014538.GK27114@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
References: <20101231022550.GA2512@darkside.kls.lan>
 <20101231024653.GA24879@gondor.apana.org.au>
 <20101231085103.GA31935@darkside.kls.lan>
 <20110104043338.GA27604@gondor.apana.org.au>
 <20110104121957.GA27114@darkside.kls.lan>
 <20110104123824.GA31557@gondor.apana.org.au>
 <20110104125722.GC27114@darkside.kls.lan>
 <20110104224238.GA4978@gondor.apana.org.au>
 <20110104230644.GJ27114@darkside.kls.lan>
 <20110105003020.GA5751@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="umrsQkkrw7viUWFs"
Content-Disposition: inline
In-Reply-To: <20110105003020.GA5751@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--umrsQkkrw7viUWFs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 05, 2011 at 11:30:20AM +1100, Herbert Xu wrote:
> OK, so xstore really is producing crap.  Can you try this path
> (also against vanilla) to print out some extra info?
>=20
>  	irq_ts_restore(ts_state);
> +	printk(KERN_DEBUG "%p 0x%x 0x%x\n", addr, *addr, eax_out);
>  	return eax_out;

# dd if=3D/dev/hwrng bs=3D16 count=3D1 | hexdump -C
1+0 records in
1+0 records out
16 bytes (16 B) copied, 0,000288649 s, 55,4 kB/s
00000000  00 ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |..............=
=2E.|
00000010
#                                                                          =
        =20

Jan  5 02:25:00 ideapad kernel: [  112.073759] f3cc3f38 0x0 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073770] f3cc3f38 0xffffffff 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073774] f3cc3f30 0x0 0x0
Jan  5 02:25:00 ideapad kernel: [  112.073788] f3cc3f38 0xffffffff 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073791] f3cc3f30 0x0 0x0
Jan  5 02:25:00 ideapad kernel: [  112.073805] f3cc3f38 0xffffffff 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073808] f3cc3f30 0x0 0x0
Jan  5 02:25:00 ideapad kernel: [  112.073821] f3cc3f38 0xffffffff 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073825] f3cc3f30 0x0 0x0
Jan  5 02:25:00 ideapad kernel: [  112.073838] f3cc3f38 0xffffffff 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073841] f3cc3f30 0x0 0x0
Jan  5 02:25:00 ideapad kernel: [  112.073855] f3cc3f38 0xffffffff 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073858] f3cc3f30 0x0 0x0
Jan  5 02:25:00 ideapad kernel: [  112.073872] f3cc3f38 0xffffffff 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073875] f3cc3f30 0x0 0x0
Jan  5 02:25:00 ideapad kernel: [  112.073888] f3cc3f38 0xffffffff 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073892] f3cc3f30 0x0 0x0
Jan  5 02:25:00 ideapad kernel: [  112.073905] f3cc3f38 0xffffffff 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073908] f3cc3f30 0x0 0x0
Jan  5 02:25:00 ideapad kernel: [  112.073922] f3cc3f38 0xffffffff 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073925] f3cc3f30 0x0 0x0
Jan  5 02:25:00 ideapad kernel: [  112.073938] f3cc3f38 0xffffffff 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073942] f3cc3f30 0x0 0x0
Jan  5 02:25:00 ideapad kernel: [  112.073955] f3cc3f38 0xffffffff 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073959] f3cc3f30 0x0 0x0
Jan  5 02:25:00 ideapad kernel: [  112.073972] f3cc3f38 0xffffffff 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073975] f3cc3f30 0x0 0x0
Jan  5 02:25:00 ideapad kernel: [  112.073989] f3cc3f38 0xffffffff 0x8
Jan  5 02:25:00 ideapad kernel: [  112.073992] f3cc3f30 0x0 0x0
Jan  5 02:25:00 ideapad kernel: [  112.074005] f3cc3f38 0xffffffff 0x8


Mario
--=20
Oh Du mein Koenig ... Eine Netzgroesse schrieb mal sinngemaess:
Du musst es so lesen wie ich es meine, nicht so wie ich es schreibe.
Ich meine es natuerlich so, wie Du es schreibst 8--)
                              -- O.G. Schwenk in de.comm.chatsystems

--umrsQkkrw7viUWFs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTSPNQhS+e2HeSPbpAQKMTQf/XwxdO5rRae+5/npST+w/Nj0hHz5kVUbn
Ai0xz4Ea0+0q+dj2WQrFFGzHQPcHhW+sGa9JdFmlvEkpiyxMkUEjZu3F8Os7n9Be
XUSBjnlBlkFRTvnwMPTif+9x6nQNzETVUTfFM8ZJfWAAfDURfaQALrpKCzD2uS89
pY/rItQpAOZx4hUgXnEgHqo9EpsMo4NN+v4QnjCONEVPuLp0czgpwpyW6CVJxN+6
j8IItiRh4ZK2Ivo18Dj2mkp5L0Me7ocmsUTmmgMIeybSGpadIreDnYA03EUdzoZL
h+5kca+NCjl5u+Oql0X7QaRTyevTn8lfZfsI7eesztLHqA1OjFGmsw==
=bajl
-----END PGP SIGNATURE-----

--umrsQkkrw7viUWFs--
