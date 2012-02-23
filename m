Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab2BWTy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:54:56 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:54164 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753833Ab2BWTyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:54:54 -0500
Date: Thu, 23 Feb 2012 11:54:48 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] PCI: Retry on type IORESOURCE_IO allocation.
Message-ID: <20120223115448.702e4e76@jbarnes-desktop>
In-Reply-To: <1328916832-6588-5-git-send-email-yinghai@kernel.org>
References: <1328916832-6588-1-git-send-email-yinghai@kernel.org>
	<1328916832-6588-5-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=m6=5Kqf3R+Ni4NiT/CPDnH"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=m6=5Kqf3R+Ni4NiT/CPDnH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Feb 2012 15:33:49 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> During reenabling pci reallocating for pci bridge by clean the small size=
 in
> bridge and assign with requested + optional size for first several try,
> Ram mention could have problem with one case
> 	https://bugzilla.kernel.org/show_bug.cgi?id=3D15960
>=20
> After checking the booting log in
> 	https://lkml.org/lkml/2010/4/19/44
> 	[regression, bisected] Xonar DX invalid PCI I/O range since 977d17bb174
>=20
> We should not stop too early for io ports.
> 	Apr 19 10:19:38 [kernel] pci 0000:04:00.0: BAR 7: can't assign io (size =
0x4000)
> 	Apr 19 10:19:38 [kernel] pci 0000:05:01.0: BAR 8: assigned [mem 0x804000=
00-0x805fffff]
> 	Apr 19 10:19:38 [kernel] pci 0000:05:01.0: BAR 7: can't assign io (size =
0x2000)
> 	Apr 19 10:19:38 [kernel] pci 0000:05:02.0: BAR 7: can't assign io (size =
0x1000)
> 	Apr 19 10:19:38 [kernel] pci 0000:05:03.0: BAR 7: can't assign io (size =
0x1000)
> 	Apr 19 10:19:38 [kernel] pci 0000:08:00.0: BAR 7: can't assign io (size =
0x1000)
> 	Apr 19 10:19:38 [kernel] pci 0000:09:04.0: BAR 0: can't assign io (size =
0x100)
> and clear 00:1c.0 to retry again.
>=20
> The patch remove the IORESOUCE_IO checking, and try one more time.
> and we will have chance to get allocation for 00:1c.0 io port range becau=
se
> from 0x4000 to 0x8000 could be used.

This one no longer applies, can you send an update against my
linux-next branch later today or tomorrow when I've pushed?

I'm still a little worried about the automatic re-alloction stuff, but
since it's under a new config option it ought to be ok.  See my other
mails for comments there.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/=m6=5Kqf3R+Ni4NiT/CPDnH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRpmIAAoJEIEoDkX4Qk9hAU4QAL29y/pPkDYQJBqg2Xb7fKsE
zTJxNwyZ/XCYL+fdXWPlzUv6L44uikdEzNXR/Bw1ALxpKRrJjliaob3C9quRJL1e
1L1DNj2gE+pm3Cg0NnTZdOqoXViNvb51XmAirZ91SQ7nuGromd73I31HrP/7Ueq+
Yb92MA0bTY3KbdBku9y1voiYLRhJ9AjK0PiQV6APUhaDZl4+Nq576PNNYcNCjQmU
2CDOAt20ofHxZey0g0nPFsFXOPmjzcg2TQiiZ7hm//cXOrCisfNRIXGPSutCVrg5
2Dv8E36fzbR+6AEuzAAIzvYjgD5r9uorBwAdsSKtfdGLXf2ig7NpbUji/AYPPapj
ij/CvpXUgpwcfii1ptKZRIX8sKicXWz/tFzOqNBeerkvHUJXtz0U7wQepLQp7Upo
zjNiWKQ5praw6lZN5iVMERI75GncL9bEdh9YWClYLy2xspz4y7F9BFOZXFut1bvH
BmN8VzZwtGfttKGgO7+Uq0TkEV/4AWLL6gqch6GtjvopvIPbcaiPDgS7icHOg8W/
XY+nDsmw4YnH9fFWHuRILJJ58i8y9+UJyNWWwsuDLVD++YUeqARAgoTXORAmLHKc
sphOMNKNBITlp3bbu/BVlipnAJBGNPKt5LzC6Y8FIQvP3u43Qz0ASkmSA1ytc1Cq
8jaHetV1yWc7fA4PR8+f
=jjnJ
-----END PGP SIGNATURE-----

--Sig_/=m6=5Kqf3R+Ni4NiT/CPDnH--
