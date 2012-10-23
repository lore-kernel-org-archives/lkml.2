Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab2JWX4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:56:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43988 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab2JWX4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:56:54 -0400
Date: Wed, 24 Oct 2012 10:56:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [rfc 0/2] Introducing VmFlags field into smaps output
Message-Id: <20121024105641.1c5a27f34d53d9d3b1c57108@canb.auug.org.au>
In-Reply-To: <1351031574.13456.47.camel@twins>
References: <5085B1A8.4020609@parallels.com>
	<20121022205641.GL2303@moon>
	<20121022213449.GH31440@moon>
	<20121022145158.53bddfc1.akpm@linux-foundation.org>
	<20121023061341.GA7020@moon>
	<20121022233025.09ec2d92.akpm@linux-foundation.org>
	<20121023063430.GB7020@moon>
	<20121023071549.GC7020@moon>
	<20121023143045.183657c4.akpm@linux-foundation.org>
	<20121023214639.GM7020@moon>
	<20121023215907.GB24069@moon>
	<1351031574.13456.47.camel@twins>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__24_Oct_2012_10_56_41_+1100_NnQzyD0/9i.01jQw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Oct_2012_10_56_41_+1100_NnQzyD0/9i.01jQw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Oct 2012 00:32:54 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> =
wrote:
>
> On Wed, 2012-10-24 at 01:59 +0400, Cyrill Gorcunov wrote:
> >                 [ilog2(VM_WRITE)]       =3D { {'w', 'r'} },
>=20
> since we're being awfully positive about crazy late night ideas, how
> about something like:
>=20
> #define MNEM(_VM, _mn) [ilog2(_VM)] =3D {(const char [2]){_mn}}
>=20
> 	MNEM(VM_WRITE, "wr"),

The C standard and gcc allow you to initialise the 2 character array with
a (>=3D2 character) string literal with no casting, so

#define MNEM(_VM, _mn) [ilog2(_VM)] =3D {_mn}

should work.

[ and the the earlier version,=20

[ilog2(VM_READ)]	=3D { "rd" },

etc, does work. ]

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__24_Oct_2012_10_56_41_+1100_NnQzyD0/9i.01jQw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQhy65AAoJEECxmPOUX5FEfMoP+wRhvkT0z4GU42tlNovuNhUp
qDJrzTtexZrTytBq0mqMLZhs1g0qxBHcDpZ7tTlJ7IjTBBN+vquLtz7IU1Vfy91B
7y+Ac+VyOVH0hwqFpvE//c3bkpFKTLmp4x8I6zjzuL8zXHsUwU95FX7k5S6pZNZx
FZjMZ5yFKR8Jn6+k0gUTMw9vl39xTOoWRiAUaEgmChrdlHxZWWIupZlwfOZlrq1F
niPN6UE+lup3RAZL/GCHROLEHiFeXLgFjSEebXR182vDDdCWW47VUC7L6VnQzbJy
mcpDIaKZcOW9PPKCtYJIPkfOWz92q0fz3Cue8DkbD2Hx5tfui5sWoc5K0JzHVEnQ
nQ+TB3245OaIG+jRU3PyNG98tFDagYG+CmhgDf3ZaV0rIyG0v+qW636Cnll3DW48
yeqdZy5ot6pLzEMMbqmMaFOFbOpjIlUwEz1C9zlmeXTYtx5MeihaGR+tnA9x3zUI
pLMKLY/SVh819NYciFumzj7LRscUEUvmJMTpEYDgh3yPgA60b4fiUeWHpW50cex7
O4n07WmD0tuGrZ9RMNy0Jye7wNI5jh37k8DNsKoVM++lswIB3ipVgDkYc5HRyH1q
p6LkMehf9izef03wY1CHh9MjfLgekJwrkpEe8tbjVZlKTcKF/hjCU+CCqBNK4qu4
JLKyIIUXJSc63hZsmGja
=bglx
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Oct_2012_10_56_41_+1100_NnQzyD0/9i.01jQw--
