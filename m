Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0IYWLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 18:11:09 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50824 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0IYWLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 18:11:07 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [TuxOnIce-devel] [linux-pm] [PATCH] Hibernate: 
 =?iso-8859-1?q?Implement=09readahead_when?= resuming
Date: Sun, 26 Sep 2010 00:10:54 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.5-tp42-vmembase-0-pm-avoid-oom-dirty; KDE/4.5.1; i686; ; )
Cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <1285416056-9735-1-git-send-email-nigel@tuxonice.net> <201009252158.28439.Martin@lichtvoll.de> <4C9E68A9.6090603@tuxonice.net> (sfid-20100925_235951_865640_006D16F6)
In-Reply-To: <4C9E68A9.6090603@tuxonice.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5497096.sb7RpXDohP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009260011.04070.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5497096.sb7RpXDohP
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Nigel.

Am Samstag 25 September 2010 schrieb Nigel Cunningham:
> On 26/09/10 05:58, Martin Steigerwald wrote:
> > Am Samstag 25 September 2010 schrieb Martin Steigerwald:
> >> Hi Nigel and Rafael,
> >>=20
> >> Am Samstag 25 September 2010 schrieb Nigel Cunningham:
> >>> Add support for submitting reads before they're needed. This
> >>> greatly improves the speed of resuming:
> >>>=20
> >>> From
> >>>=20
> >>> PM: Image read at 66 MB/s.
> >>>=20
> >>> to
> >>>=20
> >>> PM: Image read at 229 MB/s.
> >>>=20
> >>> ...and removes the need for the sync_read flag.
> >>=20
> >> So
> >>=20
> >> martin@shambhala:~/Computer/Shambhala/Kernel/2.6.36/tuxonice-head>=20
> >> git branch -av | grep for-rafael
> >> * for-rafael                      d4e7490 Hibernate: Implement
> >> readahead when resuming
> >>=20
> >>    remotes/origin/for-rafael       d4e7490 Hibernate: Implement
> >>=20
> >> readahead when resuming
> >=20
> > [...]
> >=20
> >> basically seems to work.
> >=20
> > [...]
> >=20
> >> I tried 5 times:
> >>=20
> >> - one with just kdm started worked nicely and really rather fast!
> >>=20
> >> - four with a full blown KDE 4.5.1 session with OpenGL compositing
> >>=20
> >>    - one seemed to hang prior to reinitializing the Radeon KMS DRM
> >>    setup - three other worked just fine
> >>=20
> >> I do not think that the hang is related to your changes, Nigel. The
> >> kernel remained stuck at the lower initial resolution and didn't
> >> seem to initialize the radeon KMS framebuffers at 1400x1050
> >> properly. I didn't see this with 2.6.35 and userspace software
> >> suspend.
> >=20
> > I am not so sure anymore.
> >=20
> > I got another one of these hangs with the 2.6.36-rc5 mentioned above.
> > See IMG_3871.jpg for the exact display were it hung. I was able to
> > switch view with Alt-F1 or something like that. And then got
> > IMG_3873.jpg. But nothing happened anymore. Find these on:
> >=20
> > http://martin-steigerwald.de/tmp/tuxonice/hang-after-resume-with-pm-
> > patches-for-rafael/
> >=20
> > I now tried in kernel suspend to disk with
> >=20
> > martin@shambhala:~>  cat /proc/version
> > Linux version 2.6.35.5-tp42-vmembase-0-pm-avoid-oom-dirty
> > (martin@shambhala) (gcc version 4.4.5 20100728 (prerelease) (Debian
> > 4.4.4-8) ) #4 PREEMPT Sat Sep 25 13:29:53 CEST 2010
> >=20
> > which doesn't contain your patches, Nigel, for about 5 or 6 times and
> > I did not see that hang.
> >=20
> > So maybe something in your patches, even if just the debug output I
> > mentioned, or something in 2.6.36-rc5 triggers that hang.
> >=20
> > I will test 2.6.35.5 for a bit longer to make sure that there is no
> > hang on resume prior to loading. I need to reboot this one now too,
> > cause after one of the resume attempts USB stopped working with:
> >=20
> > Sep 25 21:36:47 shambhala kernel: usb 1-3: New USB device found,
> > idVendor=3D1307, idProduct=3D0330
> > Sep 25 21:36:47 shambhala kernel: usb 1-3: New USB device strings:
> > Mfr=3D1, Product=3D2, SerialNumber=3D3
> > Sep 25 21:36:47 shambhala kernel: usb 1-3: Product: Mass Storage
> > Device Sep 25 21:36:47 shambhala kernel: usb 1-3: Manufacturer:
> > Generic Sep 25 21:36:47 shambhala kernel: usb 1-3: SerialNumber:
> > 00000000000006 Sep 25 21:36:47 shambhala kernel: scsi3 : usb-storage
> > 1-3:1.0 Sep 25 21:36:48 shambhala kernel: BUG: unable to handle
> > kernel NULL pointer dereference at 0000002c
> > Sep 25 21:36:48 shambhala kernel: IP: [<c125b5de>]
> > cfq_get_queue+0x33e/0x550
> > Sep 25 21:36:48 shambhala kernel: *pde =3D 00000000
> > Sep 25 21:36:48 shambhala kernel: Oops: 0000 [#1] PREEMPT
[...]
> > exited with preempt_count 1
> >=20
> > Maybe the USB system has an powermanagement related issue that in
> > kernel suspend triggers more easily than userspace software suspend?
> > I didn't see this one before. But well, this is a bug I will report
> > in
> > bugzilla.kernel.org.
> >=20
> > Ciao,
>=20
> Okay. Can you try without the last patch, and confirm that it's
> reliable (albeit slower) then?

Well as I told already (later on) the USB problem seems to be related to=20
my testing of systemd in Debian - I do not get how this could be the case,=
=20
but it works, when I remove init=3D/bin/systemd. I think I will report this=
=20
as a kernel bug nonetheless, cause when I apply that "userspace shouldn't=20
be able to let the kernel oops" paradigm then its a kernel bug.

Should I test without the readahead patch regarding whether that hang=20
after resume, prior to activating Radeon KMS framebuffer is fixed as well?

I am a bit unsure on what to test next. My current thoughts are:

=2D Test whether 2.6.35.5 is stable with unpatched in kernel suspend.=20
Currently in progress. Cause before that I only know its stable with=20
userspace software suspend.

=2D Apply your patches on top of 2.6.35.5 and test that.
  - If that works, it appears to be a problem introduced by 2.6.36-rc5
    - Then I'd possibly test 2.6.36-rc5 with unpatched in kernel suspend.
  - If that doesn't work, it appears to be an issue with your patches
    - Then I test without readahead patch.

Tell me when you have any different suggestions.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart5497096.sb7RpXDohP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyec28ACgkQmRvqrKWZhMdXfwCgoqmH+U0ExXrNILZqazoxhs6u
8o0AniAIVz0wtzmCotcFkHHVMVCTOx7g
=los8
-----END PGP SIGNATURE-----

--nextPart5497096.sb7RpXDohP--
