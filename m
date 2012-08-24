Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab2HXNeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:34:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:41532 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab2HXNeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:34:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,304,1344236400"; 
   d="asc'?scan'208";a="184941933"
Message-ID: <1345815532.2848.313.camel@sauron.fi.intel.com>
Subject: Re: [RFC] [PATCH] vfs: remount all file-systems R/O on emergency
 remount.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Date: Fri, 24 Aug 2012 16:38:52 +0300
In-Reply-To: <50377FA7.50708@gmail.com>
References: <1345793166-14230-1-git-send-email-dedekind1@gmail.com>
	 <50377FA7.50708@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-tK9HP5S7W45txacEnfOG"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tK9HP5S7W45txacEnfOG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-24 at 15:20 +0200, Marco Stornelli wrote:
> Il 24/08/2012 09:26, Artem Bityutskiy ha scritto:
> > From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> >
> > Currently the emergency remount (triggered by Sysrq-u) re-mounting only
> > those file-systems R/O, which have an associated block device (sb->s_bd=
ev).
> > This does not work for file-systems like UBIFS and JFFS2 which work on =
top
> > of MTD devices (character devices) and always have sb->s_bdev =3D NULL.
> >
> > This also does not work for tmpfs.
> >
> > Most probably the intention was to avoid re-mounting R/O file-systems l=
ike
> > procfs, sysfs, cgroup, and debugfs. However, I do not really see why no=
t
> > to remount them R/O as well in case of emergency.
> >
> > This patch removes the 'sb->s_bdev !=3D NULL' check from
> > 'do_emergency_remount()', so _all_ file-systems will be re-mounted R/O.
> >
> > Tested in Fedora - all file-systems (ext4, ubifs, procfs, sysfs, cgroup=
, and
> > debugfs) become R/O on Sysrq-u with this patch.
> >
> > Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>=20
> Does it make sense to remount r/o for example debugfs in this case?=20
> Maybe if there is something wrong I want enable something to catch debug=
=20
> info. Similar things for other pseudo-fs. Sure, the s_bdev seems a=20
> strong check. We could add a new flag to know if the emergency remount=
=20
> should be happen. It would give us the fs granularity, and maybe it=20
> could be turned on/off with the mount.

May be. Or may be you are in situation that you really want all
processes top modifying anything in debugfs. This depends on the
"emergency" you deal with. You can always re-mount debugfs back to rw by
hands using something like:

	mount -t debufs -o remount,rw none /sys/kernel/debug

--=20
Best Regards,
Artem Bityutskiy

--=-tK9HP5S7W45txacEnfOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQN4PsAAoJECmIfjd9wqK0GGwQAIbZjUNCtB5bvhJXTPxooESw
jL/QWyUTLIeJhEnhP4vGsPnwQK+Dm7OERUpLGxOT9x7SvIGqrRiI6iLdGFiADSbd
6PAMF051VBXAHflZ69pyKTP0rbDuRR6xvfV8qXM70hkp6W08zDxXwQT9dNAr9gXd
xzTnxuS/X2qCELlRt1D7M2MN5ltxog+PPnijICXf3MZdkNtZD55TCgRCfH92eknA
1s54BB2nl8a8roynmVDTsq9WSe6ZTgUWATLor5xqoXkPZVWMfW4Z8gw2VDQ2mR3l
y3FoxxLagOzaXuxU9hsqjp34Fc0ly6PHIGl5UCB964gWyJEgrt/0rh59DoZOlNAp
iWOtt95BOxMoDqghIy8GHwd/PXt/IcQgDAQjYRiVL5ssGm7d6JEZr577DNAvGfDl
MMTvlW7SSkc00l2NLdssKDXHEwpYjBT0eE12EtTvh4721740j0TMO4yomg6KCKHG
JrDg6QzxEjbZBlAEq3cjFnsc17njaBo6O9Vkww4ukVqfGFNXxQFhuvG1WILOyVGH
oyS7nvyGxXGN06P1+/rl4yw/foUnIzt5/HNjCnFWFNkAbDsBIEz4xgmqDH83NDzW
CxmdesWWg2TVqWJG381zNGpoa/254nCzqprY4rFd+I1xNTdCilsfLKp5gs1Ys4vt
fzZ917QkCzItzSMzR7Y0
=BCMh
-----END PGP SIGNATURE-----

--=-tK9HP5S7W45txacEnfOG--

