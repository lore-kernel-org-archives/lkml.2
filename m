Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab0KIR4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:56:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38175 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab0KIR4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:56:19 -0500
Date: Tue, 9 Nov 2010 18:56:17 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Alexey Fisher <bug-track@fisher-privat.net>, linux-kernel@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH 1/2] Introduce fat_msg() for unified kernel messages
Message-ID: <20101109175617.GA28008@pengutronix.de>
References: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net> <1289321718-6373-2-git-send-email-bug-track@fisher-privat.net> <1289323541.1823.73.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <1289323541.1823.73.camel@Joe-Laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joe,

On Tue, Nov 09, 2010 at 09:25:41AM -0800, Joe Perches wrote:
> On Tue, 2010-11-09 at 17:55 +0100, Alexey Fisher wrote:
> > Add fat_msg() function to unify printkas. And use it
> > to report mounts and remounts.
>=20
> Hi Alexey.
>=20
> > new dmesg looks like this:
> > [ 6264.957109] FAT-fs (sdg1): Mounted. Opts: uid=3D1000,gid=3D1000,shor=
tname=3Dmixed,dmask=3D0077,utf8=3D1,showexec,flush
> > [ 6402.175028] FAT-fs (sdg1): re-mounted. Opts: (null)
> >=20
> > Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
> > ---
> >  fs/fat/inode.c |   20 ++++++++++++++++++++
> >  1 files changed, 20 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> > index ad6998a..4699173 100644
> > --- a/fs/fat/inode.c
> > +++ b/fs/fat/inode.c
> > @@ -37,6 +37,20 @@
> >  static int fat_default_codepage =3D CONFIG_FAT_DEFAULT_CODEPAGE;
> >  static char fat_default_iocharset[] =3D CONFIG_FAT_DEFAULT_IOCHARSET;
> > =20
> > +/* unify messages.
> > + * this function is copy of ext4_msg() from fs/ext4/super.c
> > + */
> > +void fat_msg(struct super_block *sb, const char *prefix,
> > +			const char *fmt, ...)
> > +{
> > +	va_list args;
> > +
> > +	va_start(args, fmt);
> > +	printk("%sFAT-fs (%s): ", prefix, sb->s_id);
> > +	vprintk(fmt, args);
> > +	printk("\n");
> > +	va_end(args);
> > +}
>=20
> A few comments:
>=20
> The first patch should put the prototype for fat_msg in
> fs/fat/fat.h file and the body as done here.
>=20
> The prototype should use attribute_ printf so format
> and argument are type checked.
>=20
> This would be better using the %pV extension so a
> single printk call is done and the dmesg log can not be
> interleaved.
>=20
> prefix is a bit misleading, perhaps level is better.

Note that this routine was almost 1:1 taken from ext2, it seems (which is a
sensible approach), so these issues are present more than once.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkzZi0EACgkQD27XaX1/VRuSCQCgv7TiJhx84r3tPF50GLF7MJP1
0bwAoIak188qi9667lC0e4gNyoV9JA9T
=Vt5J
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
