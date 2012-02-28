Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965559Ab2B1PVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 10:21:09 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56954 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964962Ab2B1PVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 10:21:06 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH v2] parisc: dont unconditionally override CROSS_COMPILE for 64 bit.
Date: Tue, 28 Feb 2012 10:21:02 -0500
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "kyle@mcmartin.ca" <kyle@mcmartin.ca>, "deller@gmx.de" <deller@gmx.de>,
        "dave.anglin@bell.net" <dave.anglin@bell.net>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
References: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com> <201202280106.23643.vapier@gentoo.org> <1330438245.2822.114.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1330438245.2822.114.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1859382.OvXdmgvv1I";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201202281021.05897.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1859382.OvXdmgvv1I
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 28 February 2012 09:10:45 James Bottomley wrote:
> On Tue, 2012-02-28 at 01:06 -0500, Mike Frysinger wrote:
> > On Monday 27 February 2012 22:17:01 James Bottomley wrote:
> > > On Mon, 2012-02-27 at 20:04 -0500, Mike Frysinger wrote:
> > > > On Monday 27 February 2012 17:03:10 James Bottomley wrote:
> > > > > --- a/arch/parisc/Makefile
> > > > > +++ b/arch/parisc/Makefile
> > > > >=20
> > > > > -CROSS_COMPILE	:=3D hppa64-linux-gnu-
> > > > > +
> > > > > +# if no default set, try to find the corresponding 64 bit compil=
er
> > > > > +ifeq ($(CROSS_COMPILE),)
> > > > > +CROSS_COMPILE	:=3D $(shell $(CC) -dumpmachine | sed
> > > > > s/hppa-\\\(.*\\\)/hppa64-\\1-/) +endif
> > > >=20
> > > > fails when using "hppa2.0-xxx".  perhaps:
>=20
> Is that a valid prefix?  I was thinking hppa32 might be, but hppa2.0 is
> supposed to be hppa-xxx with -mpa-risc-2-0.

we've been using hppa2.0 for years.  gnuconfig certainly recognizes it:
$ grep hppa /usr/share/gnuconfig/config.sub=20
        | h8300 | h8500 | hppa | hppa1.[01] | hppa2.0 | hppa2.0[nw] | hppa6=
4 \
        | hppa-* | hppa1.[01]-* | hppa2.0-* | hppa2.0[nw]-* | hppa64-* \

and i've seen diff projects key off of the hppa2.0* to enable newer feature=
s by=20
default.

> But anyway, I think being clever and removing unused stuff is likely
> orthogonal to the first patch which is just making it all work.

sure, but your new patch added the sed :)

> > > The reason it doesn't work is the same ... CROSS_COMPILE is defined to
> > > be empty.
> >=20
> > my suggestion was purely an incremental improvement on the patch you
> > posted.
> >=20
> > it improves two things:
> > 	- detection when the default tuple is hppa2.0-xxx rather than hppa-xxx
> > 	- one line for set-variable-only-when-its-unset rather than three lines
>=20
> It can't be done ... defined but empty is different from not defined in
> makefiles (ifdef or ?=3D only checks for not defined).  CROSS_COMPILE gets
> automatically defined by the top level Makefile ... that's why we need a
> check for empty not a check for not defined.

yeah, OK ... this behavior changed from what i was remembering.  ?=3D used =
to=20
work until the top level Makefile was improved.
=2Dmike

--nextPart1859382.OvXdmgvv1I
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPTPDhAAoJEEFjO5/oN/WBtdUP/0MI0sDoAUuzasH5CqWbnLXX
9Gg45A5+isNxsptOF8IedVdyQuapd6Zu+ahQR9aRTKpT/gc/2gz+qx/zFlFnxa6e
6K/BJIuRbTQh2eYNTWN/5JM8PKROOAdqulbgxwjlggH68NEerB5Ml+Vwn79isBCR
GrJFyCRGNoowdxlwdEuE3lrF3RbxUKGKEqMGkk6OoMzdGDCZSWFH6qqw2BBfR/3n
oFANwujOAza0QtkNRsnGc0MAPDQ9wG6QosXA7HMyBKxXXN6UXzIJmqeqYJeya0th
Kfgd3mctu3XF9xtQWOiAgyYdLtjplQ/9wJ3tl7n/dTpgKkk0KcNzr7WkgNR93s0y
D8r4DfwX3fr56Z/JUF+nbxiisgTMUdzLmLOThQEhF7Zpw9l7RgGaMAbukdv/QQaD
zc/sj9wzSELGCwurVVdSmA5tS4RUC727iHX86d2XnjrssHIzvGizKP3WRXKAw/Dw
bGcApPRpPTO3qZXzlToFQDnKyAujExkuDIWroilOXN1qmUzWVEgRV3/5z9Ls04VP
eDlzig/3baGYRDO84Nyu4sB13+yuScJrRSQpyXJvf/r9NWlI7gRgj6KOs4g9uDpl
xfwjIz4mokOLXWPP1QKZAG/H8TQUM81rYCcgZzRj2T9pR879C0vbeTP/ZEdHEWCy
L8xVjtcIf9tz4go5+0In
=UefJ
-----END PGP SIGNATURE-----

--nextPart1859382.OvXdmgvv1I--
