Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1CJS7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:59:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37183 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1CJS7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:59:52 -0500
Message-ID: <4D791FA3.3070100@pengutronix.de>
Date: Thu, 10 Mar 2011 19:59:47 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Dr Andrew John Hughes <ahughes@redhat.com>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
        Trond.Myklebust@netapp.com
Subject: Re: NFS regression in 2.6.37.1 (current stable)
References: <20110310185321.GA22030@rivendell.middle-earth.co.uk>
In-Reply-To: <20110310185321.GA22030@rivendell.middle-earth.co.uk>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEDA031277098FCBB0A1198E1"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEDA031277098FCBB0A1198E1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Andrew,

On 03/10/2011 07:53 PM, Dr Andrew John Hughes wrote:
> [Please CC me on responses as I'm not subscribed]
>=20
> Hi,
>=20
> I seem to have uncovered a regression in the NFS code between 2.6.37 an=
d 2.6.37.1
> caused by this changeset:
>=20
> commit 55ea499d60aefa3d03a77fc8590c26b5881faa92
> Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date:   Sat Jan 8 17:45:38 2011 -0500
> NFS: Don't use vm_map_ram() in readdir
> http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-2.6.37.y.git;a=
=3Dcommit;h=3D6650239a4b01077e80d5a4468562756d77afaa59
>=20
> With this change applied, copying of files between NFS and non-NFS
> mounts seems to be broken.  The easiest way I've found to replicate
> this myself is to use a VCS to do a clone of a tree on a NFS mount to
> a directory on a non-NFS mount.  I used Mercurial, as I had Mercurial
> trees to hand from work on IcedTea, but I assume doing it with a git
> tree such as the linux tree would also work.  The idea is to do
> something which involves copying over a bunch of directories and
> checking the result is readable.
>=20
> $ hg clone $HOME/projects/openjdk/icedtea6-hg
> destination directory: icedtea6-hg
> updating to branch default
> abort:
> data/contrib/templater/hotspot/src/cpu/CPU/vm/bytecodeInterpreter_CPU.i=
nline.hpp.i@16d04ce16287:
> no match found!
>=20
> In the above, $HOME is an NFS mount and $PWD is a local reiserfs
> partition.  I initially hit failures doing builds with source on $HOME
> and the build directory on a local reiserfs partition.  In that
> scenario, it would fail as not being able to find files that should
> have been copied over.
>=20
> Reverting the changeset fixes the issue.  2.6.37.2 still has the bug.
> I haven't checked 2.6.37.3 yet but I didn't see any NFS changes in ther=
e.

Which arch are you using? As this patch is also part of the upcoming
2.6.38, can you check if the latest .38 is affected, too?

cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigEDA031277098FCBB0A1198E1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk15H6UACgkQjTAFq1RaXHMfOQCbBPBokIJjWhab2rX37UdfvgM8
7CkAn2XcIdDRFAncXq+yrd2j7d0TF2Kf
=zwn4
-----END PGP SIGNATURE-----

--------------enigEDA031277098FCBB0A1198E1--
