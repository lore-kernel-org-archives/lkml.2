Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937791Ab0CPLGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 07:06:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:55306 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937756Ab0CPLGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 07:06:36 -0400
Date: Tue, 16 Mar 2010 12:06:35 +0100
From: Petr Uzel <petr.uzel@suse.cz>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sys_umount() returns EBUSY when doing: sh -c "mount /dev/sdc1
 /mnt; umount /mnt"
Message-ID: <20100316110635.GB23066@foxbat.suse.cz>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <38b2ab8a1003130056u4b025839i556a797ccad894de@mail.gmail.com>
 <4B9D0D1E.3010404@gmail.com>
 <38b2ab8a1003150509i4a9e7e1dqce2bfb11557d403d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
Content-Disposition: inline
In-Reply-To: <38b2ab8a1003150509i4a9e7e1dqce2bfb11557d403d@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 15, 2010 at 01:09:30PM +0100, Francis Moreau wrote:
> On Sun, Mar 14, 2010 at 5:21 PM, Robert Hancock <hancockrwd@gmail.com> wr=
ote:
> > On 03/13/2010 02:56 AM, Francis Moreau wrote:
> >> Hello
> >>
> >> I've some shell scripts which try to find out the filesystem hosted by
> >> a block device.
> >>
> >> They basically do this:
> >>
> >> =A0 =A0 mount /dev/sdc1 /mnt
> >> =A0 =A0 fs=3D$(stat -f -c %T $mount_point)
> >> =A0 =A0 umount /mnt
> >>
> >> It happens to work but since an unknown upgrade (kernel, libs or tools
> >> upgrade), umount(8) returns -EBUSY.
> >>
> >> I found that it's actually the sys_umount() which return -EBUSY.
> >>
> >> So the question, is this expected or is this a regression ?
> >>
> >> If it's expected then which operation should I add between the
> >> mount(8) and umount(8) to make the mount operation completely finish
> >> (inside the kernel) so the next umount won't return -EBUSY ?
> >
> > If no other process were involved I would say it's likely a bug. Howeve=
r, my
> > guess is that some other process (HAL, something in GNOME, etc.) detect=
s the
> > mount and decides to start accessing the drive. Then when you immediate=
ly
> > try to unmount, it fails because it's busy. I suspect if you try this in
> > single-user mode with no unnecessary processes running you won't see th=
is.
> >

I have experienced something similar when I did addpart, immediately
followed by delpart. The delpart command failed with EBUSY, because
the first command triggered some hal subprocess that accessed the
device.

> You're right, I don't see this anymore if I'm booting in a single user mo=
de.

You can try to put 'lsof /dev/sdc1' between mount and umount to see
what (if anything) is accessing the device.

>=20
> So I need to find out how to wait until these other processes stop
> accessing the drive.

If it is hal what causes EBUSY, you could 'killall -SIGSTOP haldaemon'
before mount and SIGCONT after umount.


Petr

--
Petr Uzel, openSUSE Boosters Team
IRC: ptr_uzl @ freenode

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAkufZjsACgkQnZxG0T6qDD2XUwCfVZpNFtVAW3WBxJwT/a09DVu7
MuIAnAoD82YlG73pgKnUPEWFQVKGcFdy
=7qtr
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
