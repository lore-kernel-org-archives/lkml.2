Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab2A0R2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:28:45 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:46203 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751557Ab2A0R2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:28:43 -0500
Date: Fri, 27 Jan 2012 09:28:40 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Charlie Suffin <charlie.suffin@stratus.com>, stable@kernel.org
Subject: Re: [PATCH] pci: Add quirk for still enabled interrupts on Intel
 Sandy Bridge GPUs
Message-ID: <20120127092840.52e7567e@jbarnes-desktop>
In-Reply-To: <201201101145.52640.thomas.jarosch@intra2net.com>
References: <4EDFD5BB.1050906@intra2net.com>
	<201201101145.52640.thomas.jarosch@intra2net.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//gXEEvKLHF5a7SEIoq9Eo5s"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//gXEEvKLHF5a7SEIoq9Eo5s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Jan 2012 11:45:52 +0100
Thomas Jarosch <thomas.jarosch@intra2net.com> wrote:

> On Wednesday, 7. December 2011 22:08:11 Thomas Jarosch wrote:
> > Some BIOS implementations leave the Intel GPU interrupts enabled,
> > even though no one is handling them (f.e. i915 driver is never loaded).
> > Additionally the interrupt destination is not set up properly
> > and the interrupt ends up -somewhere-.
> >=20
> > These spurious interrupts are "sticky" and the kernel disables
> > the (shared) interrupt line after 100.000+ generated interrupts.
> >=20
> > Fix it by disabling the still enabled interrupts.
> > This resolves crashes often seen on monitor unplug.
>=20
> Happy new year 2012!
>=20
> Any news on the status of this patch?

Did you get my last reply:

Could really be dev_dbg, I think this will be fairly common.  I think we
also need to ack any outstanding interrupts after disabling them in IER
by writing IIR back on itself. Can you test that?

Other than that I'd like to apply it.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_//gXEEvKLHF5a7SEIoq9Eo5s
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIt7IAAoJEIEoDkX4Qk9hjuwQAM8evsv/fdwEU4oC2V+CKOHR
ZJ4sEZ1eFKxFdAxjI8udR3m5F2P2G5A5cwNA2iioV10U+Nde7itKGxO8vYov/eWV
A7OX9rV4f+9TqjCk2cSJaYcp9HUhPKgwN365b9z0M9Ijj4ffN+1C6GiQSVnN67Nt
SKshG8TWoDlhrR2Of5y6lEsT2rYnbwsF6zUDtxe/U4+jyt9P3Cekoaa04JQCrpSV
5v7k4s34m8IMKrD26eK0Q5foKpG4tdoxn0WuRHuBukYorgSlgTJgmJCefo1F5OW2
iQchnC8Zd32/crKo9B6lPOmHscso3qB/7S67mXRfdGU0iATD4Hov0lwV7gM90rWq
oRWhlkoutJXSMdJN9/D9Oqj1qFutsyzaCeZyVZEAyI7LQckc3WWIxQUQlYsJt1m5
aRtEFIP0peNSEuojPn1B5e+VR0ZCbpWZOG6TRHMJc8FpIo9FZdHuck/zVg+eJ8fz
xa6GLgOXAsVsBvNhrVmfx4zpiEOb1SHHfVN0Y370nw1S2gUx+V5qNkPmkpv+mwzK
5h4wEvQO0vRlztJ+GWF0kDnK00Efd1Dx5xo5P/oP7QZcC2y120UGv5kNLyx30jRM
p+YEYyjcB8/VbtmWMOmXxULHhqJgVwOv4AAvYUfZIsVwNIl4q8RuVp1L00L3FLx4
g3VdvHsxvONYILuDx6pR
=Rkbv
-----END PGP SIGNATURE-----

--Sig_//gXEEvKLHF5a7SEIoq9Eo5s--
