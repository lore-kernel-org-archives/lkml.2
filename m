Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab0C2MVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:21:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56421 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab0C2MVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:21:36 -0400
Date: Mon, 29 Mar 2010 23:21:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL linux-next] break implicit percpu.h -> slab.h
 dependency
Message-Id: <20100329232129.46c85f93.sfr@canb.auug.org.au>
In-Reply-To: <4BAFFBBC.5040402@kernel.org>
References: <4BAFFBBC.5040402@kernel.org>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Mar_2010_23_21_29_+1100_/JpX2DNkgFKm0ILu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Mar_2010_23_21_29_+1100_/JpX2DNkgFKm0ILu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Mon, 29 Mar 2010 10:00:44 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> Can you please pull the following into linux-next?
>=20
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git slabh
>=20
> The tree breaks implicit slab.h inclusion from percpu.h.  It turned
> out that a lot of .c files assumed slab/gfp availability w/o actually
> including the respective header, so the conversion ended up modifying
> includes on over 4000 files.
>=20
> I don't expect there to be a lot of conflicts and the ones which
> happen should be straight forward to resolve.  Albeit large in volume,
> the changes being mostly trivial, I'm hoping to push this into Linus
> tree soonish (ie. during this devel cycle), so the tree hopefully will
> go away soon.
>=20
> Please read the following thread for details.
>=20
>  http://thread.gmane.org/gmane.linux.kernel/965549

As you are aware, I included your tree in linux-next today :-)

There were a few conflicts:

CONFLICT (content): Merge conflict in drivers/char/sysrq.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/radeon/r300.c
CONFLICT (content): Merge conflict in drivers/hid/hid-wacom.c
CONFLICT (content): Merge conflict in drivers/media/video/soc_camera.c
CONFLICT (content): Merge conflict in drivers/net/wireless/wl12xx/wl1271_cm=
d.c
CONFLICT (content): Merge conflict in drivers/net/wireless/wl12xx/wl1271_ma=
in.c
CONFLICT (content): Merge conflict in drivers/net/wireless/wl12xx/wl1271_sp=
i.c
CONFLICT (content): Merge conflict in drivers/pcmcia/pcmcia_resource.c
CONFLICT (content): Merge conflict in drivers/s390/char/vmcp.c
CONFLICT (content): Merge conflict in drivers/staging/cx25821/cx25821-audio=
-upstream.c
CONFLICT (content): Merge conflict in kernel/audit_watch.c
CONFLICT (content): Merge conflict in net/mac80211/scan.c
CONFLICT (delete/modify): sound/soc/codecs/ad1938.c deleted in HEAD and mod=
ified in slabh/slabh. Version slabh/slabh of sound/soc/codecs/ad1938.c left=
 in tree.

Almost all of these were simple and I just fixed them up.

And you saw the reports for the build errors.  Some of these have already
been fixed.  The rest I can carry until (hopefully) they are picked up by
their respective maintainers.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Mon__29_Mar_2010_23_21_29_+1100_/JpX2DNkgFKm0ILu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuwm0kACgkQjjKRsyhoI8yhtwCgixV5JrDMZxVpmTEyP7OE2vMH
x70AoIyXsgZAGMuTja3w1gPdO63aYbLG
=Bs91
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Mar_2010_23_21_29_+1100_/JpX2DNkgFKm0ILu--
