Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189Ab2AFUq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:46:58 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:56893 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752987Ab2AFUq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:46:56 -0500
Date: Fri, 6 Jan 2012 12:46:49 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI fixes
Message-ID: <20120106124649.146001d6@jbarnes-desktop>
In-Reply-To: <CA+55aFz7j8ipEn7e0dGnrG4dskyRiBOx0-ExAx3qnH_cR5mLQw@mail.gmail.com>
References: <20111217092935.2c2e075e@jbarnes-desktop>
	<CAE9FiQWueS=9aSAH4fLz=EpE=A_WanKU6pbfnR2a4gsymWjnDA@mail.gmail.com>
	<dfbb748b-b9de-4390-bb8d-138fc4c5734f@email.android.com>
	<CA+55aFz7j8ipEn7e0dGnrG4dskyRiBOx0-ExAx3qnH_cR5mLQw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FpCkH/x/=WSxyVX_t5/_6UZ"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FpCkH/x/=WSxyVX_t5/_6UZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 18 Dec 2011 14:14:13 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Dec 17, 2011 at 9:52 PM, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:
> >
> > Crap, and after you guys spent so long coming up with a clean version.
> >
> > Linus, can you just apply this one on top? I think it's the one Yinghai=
 and Ram agreed to.
>=20
> Ok, applied, but I have to say that I hate it.
>=20
> Why don't we just move the stupid iov indexes to the end, and then
> ignore them by not counting through them in
> __pci_enable_device_flags()? So the regular PCI code would always walk
> through the resources 0 .. PCI_BRIDGE_RESOURCES_END or something. And
> then the magic IOV code could look at its own ones that the generic
> code apparently doesn't even want to know about.
>=20
> Hmm?

There was some talk awhile back of pulling the SR-IOV resources out of
the pci_dev resource array (adding a separate member to track them only
if CONFIG_PCI_IOV is enabled), that would probably be the way to go.
Then fix up whatever resource walking code that cares about IOV BARs
(there isn't much I think).

Any thoughts Yinghai?

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/FpCkH/x/=WSxyVX_t5/_6UZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPB125AAoJEIEoDkX4Qk9hAw4P/1f9b22hEWv/dlQG+sFO3vga
j+g3S9aK0RWYwtc+GXgDYZIzqpwgCSHcCptpQKJlmI3uvTPX6v7B1KjU/HHLPyJ9
8RdtFAeP+iVo8dQWrked1BVdQRMh39Tc8k2byyBr7t5FLyQh7Uu4BLDNxw7WmSPK
UALkRUdtuJcnvtI9hnDFG+MeHZaf6nIrwksQwKX5MzXBh1YflgfjuL6lwhtrEgxq
LO2yzPDzbRAYAt0Yo+2WIwYpk4sA5Yp52k0PXFR+IA6saY+ZvsSfeqHSnWBTu2lq
gu9KqoZIL4xtzycwS8FWVVPRSCvZ1PBIuIsEbWUQJ1mGtDsJHopi3B4CUsRPmhi0
TbhWwPltbG4dU7oKleHW0u3QBxzxBFwxBCZKNdXGyAcUXzNW0u39AddgHk+ssrBn
h0wUHtfurtfw6hlFYxsc3sDUVsmpXfvNV2LYCPhkvTfdPnLB1lFdwX2ZPtf1/NOe
8JNskSHfEQ3w1Vg8CbAvw+Yser//IiI6gPwgG1mlo/tE3eSymLj8ddaaBkyPi08U
TI8VOKiPtq5LDgy0/P9EFkfz+332bvlRFL+/ZZexlmmgNxkh0cOqQleU6DHSO89n
ZIvCnaN7HOeffPa6fOpwyPGwsaAmIrgsqIOTKe6TX4DQMtTvwWpBgCg889c++xS8
YyKxd7C76UG36mZv3UU8
=BNoN
-----END PGP SIGNATURE-----

--Sig_/FpCkH/x/=WSxyVX_t5/_6UZ--
