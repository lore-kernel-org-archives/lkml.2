Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab2BNQp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:45:57 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:56741 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754659Ab2BNQpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:45:54 -0500
Date: Tue, 14 Feb 2012 08:45:51 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: linux-next: build failure after merge of the pci tree
Message-ID: <20120214084551.6d6ca6cf@jbarnes-desktop>
In-Reply-To: <20120213132125.a292c8832d031d5694b62a8c@canb.auug.org.au>
References: <20120213132125.a292c8832d031d5694b62a8c@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/D85p6pBGIXgUb49YkicH0TF"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/D85p6pBGIXgUb49YkicH0TF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Feb 2012 13:21:25 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jesse,
>=20
> After merging the pci tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> drivers/pci/quirks.c: In function 'do_one_fixup_debug':
> drivers/pci/quirks.c:2915:2: error: implicit declaration of function 'tas=
k_pid_nr' [-Werror=3Dimplicit-function-declaration]
> drivers/pci/quirks.c:2916:2: error: implicit declaration of function 'kti=
me_get' [-Werror=3Dimplicit-function-declaration]
> drivers/pci/quirks.c:2916:11: error: incompatible types when assigning to=
 type 'ktime_t' from type 'int'
> drivers/pci/quirks.c:2918:10: error: incompatible types when assigning to=
 type 'ktime_t' from type 'int'
>=20
> Caused by commit 49107584a885 ("PCI: Annotate PCI quirks in
> initcall_debug style"). Some missing include files ...
>=20
> I have used the pci tree from next-20120210 for today.

I pushed a v2 of the patch with the right #includes, hopefully it'll
build across arches this time.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/D85p6pBGIXgUb49YkicH0TF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOo+/AAoJEIEoDkX4Qk9hbFIP/3X94otBvFifiROkDyFiWuOA
aZMxMmBXpRIuEJ+oSdr6MOwWcwwi7o4SO7LuDOWbKNqCuN4CXF8/6RBJ/gFlQcBA
29id3wX5wwdkyMiL3sFIulIFTkXuKrWTX3rqwk+F+1ExxqjAPfDPh6Xn3olI0rbH
GEZrqOwd8/L6Irm4cNMJnI6xQ7vmq05pIR5+B4cT0X6hOUTJ8oNUgP9PwB2OzIkQ
knDcZZ2wbMdcvETCDnL3zQU+5QlFGHJlZTPXYp84IymgjqfyiSjqBekMGYBSLAgi
5o3sWGRFx2gUKZlk+LFEr9mKxWOzc3cQl+HsVySZpbw6cATR1MD1BoJif6VICJvl
s6AYYVItaAetH3mT00vQDyMjho8a/By5EhlK5Rd38Vr9PJ0cuvv17Ja9UY6AV2l1
NsgWI60kC8RrPGLyfN7xxY6m1ChDUhXWywCwXlU30G1RAT8xxPDjFjfJc6+nFJCq
hQKqriYYidxhh28dCPkX6vMPJu09pXSvMSUW2J5a8+Fok+q01nIcokbB1UMnbqCP
bgg/l3mFj+km8cGEJU3gIDbMxWqG7qtXEBzfsUmSexwh3m56Fru+p2kKebokacrQ
noMEXSwpDXCRddUjlaAvy20rz8iFJvlvBF9MSDy3Zpjt7BvFprZwKlK423aTG//H
YUJb75P8wPahTXl5OpaV
=puzd
-----END PGP SIGNATURE-----

--Sig_/D85p6pBGIXgUb49YkicH0TF--
