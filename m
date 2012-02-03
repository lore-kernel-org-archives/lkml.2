Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab2BCJ4C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:56:02 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:53830 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab2BCJz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:55:57 -0500
X-manitu-Original-Sender-IP: 86.32.213.40
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Fri, 3 Feb 2012 10:55:50 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] fs/vfat: add *.cmd to filenames listed as
 executable by mount option "showexec"
Message-ID: <20120203095550.GA12435@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
References: <20120203064055.GA7184@mobil.systemanalysen.net>
 <8762foe543.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <8762foe543.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-02-03 Fr 16:41:16 +0900, OGAWA Hirofumi wrote:
> Roland Eggner <edvx1@systemanalysen.net> writes:
>=20
> > The mount option "showexec" provides a somewhat more native view of vfat
> > filesystems:  only filenames *.exe *.com *.bat are listed as executable=
, rather
> > than all files.  This patch adds filenames *.cmd to those listed as exe=
cutable.
> > *.cmd are usually scripts associated with the shell "cmd.exe", which ha=
s been
> > the default shell in several OS versions of its vendor.
> >
> > Signed-off-by: Roland Eggner <edvx1@systemanalysen.net>
> > ---
>=20
> Hm, this may be good for someone, but this may not be for someone. So,
> this probably should be option if someone really care it.
>=20
> I'm not thinking about how though...
>=20
Think of VM images of recent versions of the FAT originating OS:  currently
"showexec" will miss roughly half of the files, for which it is intended fo=
r.
IMHO this patch provides a very cheap completion of a feature of the vfat k=
ernel
module.  Cheap in terms of only 9 characters additional source code.

If you really see an advantage in the current, incomplete state of the
"showexec" feature, compared to the proposed, completed state:  please elab=
orate
your objection.

> > --- a/Documentation/filesystems/vfat.txt	2011-10-24 09:10:05.000000000 =
+0200
> > +++ b/Documentation/filesystems/vfat.txt	2012-02-03 07:26:30.457441230 =
+0100
> > @@ -114,7 +114,7 @@
> > =20
> >  showexec      -- If set, the execute permission bits of the file will =
be
> >  		 allowed only if the extension part of the name is .EXE,
> > -		 .COM, or .BAT. Not set by default.
> > +		 .COM, .BAT or .CMD.  Not set by default.
> > =20
> >  debug         -- Can be set, but unused by the current implementation.
> > =20
> > --- a/fs/fat/inode.c	2012-02-03 06:23:35.721409360 +0100
> > +++ b/fs/fat/inode.c	2012-01-23 01:35:29.000000000 +0100
> > @@ -326,7 +326,7 @@ struct inode *fat_iget(struct super_bloc
> > =20
> >  static int is_exec(unsigned char *extension)
> >  {
> > -	unsigned char *exe_extensions =3D "EXECOMBAT", *walk;
> > +	unsigned char *exe_extensions =3D "EXECOMBATCMD", *walk;
> > =20
> >  	for (walk =3D exe_extensions; *walk; walk +=3D 3)
> >  		if (!strncmp(extension, walk, 3))

--=20
Roland Eggner <edvx1@systemanalysen.net>

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEUEARECAAYFAk8rryYACgkQdN/hKfT7G/KomgCgor3Oi+7o0UvlhS715nw5yBnX
PcAAmLYx6NkdR9ddeogCBMKRy0e1Gl0=
=JgT9
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
