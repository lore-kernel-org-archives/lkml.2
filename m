Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2B1GGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 01:06:21 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:38549 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab2B1GGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 01:06:20 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v2] parisc: dont unconditionally override CROSS_COMPILE for 64 bit.
Date: Tue, 28 Feb 2012 01:06:20 -0500
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "kyle@mcmartin.ca" <kyle@mcmartin.ca>, "deller@gmx.de" <deller@gmx.de>,
        "dave.anglin@bell.net" <dave.anglin@bell.net>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
References: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com> <201202272004.55187.vapier@gentoo.org> <1330399020.2822.106.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1330399020.2822.106.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2671552.CgOXUbQQLd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201202280106.23643.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2671552.CgOXUbQQLd
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 27 February 2012 22:17:01 James Bottomley wrote:
> On Mon, 2012-02-27 at 20:04 -0500, Mike Frysinger wrote:
> > On Monday 27 February 2012 17:03:10 James Bottomley wrote:
> > > --- a/arch/parisc/Makefile
> > > +++ b/arch/parisc/Makefile
> > >=20
> > > -CROSS_COMPILE	:=3D hppa64-linux-gnu-
> > > +
> > > +# if no default set, try to find the corresponding 64 bit compiler
> > > +ifeq ($(CROSS_COMPILE),)
> > > +CROSS_COMPILE	:=3D $(shell $(CC) -dumpmachine | sed
> > > s/hppa-\\\(.*\\\)/hppa64-\\1-/) +endif
> >=20
> > fails when using "hppa2.0-xxx".  perhaps:
> > CROSS_COMPILE ?=3D $(shell $(CC) -dumpmachine | sed
> > 's/^hppa[^-]*-/hppa64-/')
> >=20
> > don't even need the ifeq check then
>=20
> How is that different from Carlos' suggestion?

sorry, but i'm not seeing any e-mails from Carlos in this thread.  what is =
his=20
suggestion ?

> The reason it doesn't work is the same ... CROSS_COMPILE is defined to be
> empty.

my suggestion was purely an incremental improvement on the patch you posted=
=2E =20
it improves two things:
	- detection when the default tuple is hppa2.0-xxx rather than hppa-xxx
	- one line for set-variable-only-when-its-unset rather than three lines
=2Dmike

--nextPart2671552.CgOXUbQQLd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPTG7fAAoJEEFjO5/oN/WB0yEP/jWUkZIrGVdlh9svcO3Bnd5w
g1uiq5f0ku6DVeAX/yF5zxUXFdvKUECvbVeOFOxxE8TDwJA/6d22vpDEhzA1FW53
8YiHbTUOwRQO999dzPThk6JxI+4tMkBEMHYQDAbUXNki4mY1S+vKtLWJBZ7t0VFB
Lc+oG9hf46maFZM1nPK8Pj2b5rOlx8KE0qJPNx+9xaUZuERfVy+wyCvdq2d3KnmO
83SmZGcr+GJL7iKJTlX+0t+JSJYA3Sbiap9/toQc5WDXYk7lyCy37aCQypzwEtKA
tD4KCRHAOGgW+xAvk+lrjSGc5T80BNvsv3t1IdjvP7Ak6iwyQ86RCUCb/q+QxZZQ
xjd2RshmoUiSj5xR4yH0yjugT32fO0zFjT414qcYJStFx8uphcBp5GpJyq7mj6FH
DIA3BuUotgHWJRKsh2BTkJHVC+DDnCtq6oudd2xXCn74S/dSd3DZo69MKOTUbyqh
1O+w+9UZXkeQWTn8I+Z1tWTioIR7MNfce+kwwwEf0HILVFBsFinQxi5Gy16h/A9J
VJvdi496Aat+26e2763+6UBFQewzTeFlaSoVx2Pyk38fkJcOL82HN/TCu+q3FDN6
Xz+oPQKE22ksVxFGyJLbr0kt14dr9m8pt/KB7tlEXVFD2cYx/oJ2MTRtOb5OISoq
zr+JZCrNOQ8VXc1+GTjV
=lvLb
-----END PGP SIGNATURE-----

--nextPart2671552.CgOXUbQQLd--
