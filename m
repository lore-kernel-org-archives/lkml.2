Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab0IGWzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 18:55:42 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59223 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab0IGWzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 18:55:40 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Alex Deucher <alexdeucher@gmail.com>
Subject: Re: Bisecting radeon kms freeze bug: Almost there, please help with choosing next commit
Date: Wed, 8 Sep 2010 00:55:08 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.33-tp42-00028-g30d6c72; KDE/4.4.5; i686; ; )
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
References: <201009071635.11110.Martin@lichtvoll.de> <AANLkTi=o7f9_u9BpJ2ORA-WSv5YV_H5hZSMbLzN+g0TF@mail.gmail.com> (sfid-20100908_004416_151529_6CE64D7B)
In-Reply-To: <AANLkTi=o7f9_u9BpJ2ORA-WSv5YV_H5hZSMbLzN+g0TF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8395243.0ytDIrv5jT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009080055.16598.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8395243.0ytDIrv5jT
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Dienstag 07 September 2010 schrieb Alex Deucher:
> On Tue, Sep 7, 2010 at 10:34 AM, Martin Steigerwald=20
<Martin@lichtvoll.de> wrote:
> > Hello Alex and und Dave,
> >=20
> > please excuse typing errors. The machine is abysmally slow with that
> > kernel.
> >=20
> > I am almost there with bisecting Bug 16376, random - possibly Radeon
> > DRM KM related - freezes. I think I found the merge where is issue
> > has been introduced and I am now testing
> >=20
> > martin@shambhala:~/Computer/Shambhala/Kernel/2.6.33-2.6.34-
> > bisect/linux-2.6> git log | head
> > commit 6ad86c311a8b8a6d856527a1b6ba21790ab7054b
> > Author: Alex Deucher <alexdeucher@gmail.com>
> > Date:   Thu Feb 11 10:47:52 2010 -0500
> >=20
> >    drm/radeon/kms: remove HDP flushes from fence emit (v2)
> >=20
> >    r600_ioctl_wait_idle() now handles this.
> >=20
> >    v2: update blit fence counts
> >=20
> > Unfortunately it has some other issues that has been fixed later on
> > prior to 2.6.34 already:
> >=20
> > 7.9.2010 - 2.6.32-tp42-00514-g6ad86c3
> > 6ad86c311a8b8a6d856527a1b6ba21790ab7054b
> > - Sluggy desktop. Short pauses, locks of about a second.
> > - Slow scroll performance on tty.
> > - No complete freeze yet.
> > - Much CPU time used in system:70-90%
> >=20
> > You know the changes in that merge better than me. Can you recommend
> > which commits to test next? Som commits may require other ones and
> > thus it might be wise to choose the next commits with that in mind.
> > Maybe you already have an idea which one it could be. I thought
> > about the memory controllr v2 changes, but I really don't have the
> > foggiest.
>=20
> This might be a duplicate of:
> https://bugs.freedesktop.org/show_bug.cgi?id=3D28402
> Does the patch there help?

Which of the patches mentioned in the bug report?

The ones mentioned in:

https://bugs.freedesktop.org/show_bug.cgi?id=3D28402#c44

Or your patch from

https://bugs.freedesktop.org/show_bug.cgi?id=3D28402#c47

?

I am already testing the next bisect kernel and I am quite close 10-15=20
commits in exactly the area described in the bug report. If=20
30d6c72c4a760cfc9069ee100786e4d6cf6de59d turns out to be good, like it=20
seems, then the issue must have been introduced between it and the sluggy=20
6ad86c311a8b8a6d856527a1b6ba21790ab7054b mentioned below.

Thanks,
Martin

> Alex
>=20
> > Here is excerpt from atop which shows ridicully high system CPU usage
> > with that kernel.
> >=20
> > ATOP - shambhala          2010/09/07  16:11:22               10
> > seconds elapsed
> > PRC | sys   8.66s | user   1.30s | #proc    195 | #zombie    0 |
> > #exit 0 |
> > CPU | sys     85% | user     11% | irq       4% | idle      0% | wait
> > 0% |
> > CPL | avg1   3.39 | avg5    3.80 | avg15   3.25 | csw    18458 | intr
> > 11472 |
> > MEM | tot    2.0G | free  543.1M | cache 759.6M | buff   95.0M | slab
> > 37.8M |
> > SWP | tot    3.8G | free    3.8G |              | vmcom   1.3G |
> > vmlim 4.8G |
> > DSK |         sda | busy      3% | read       1 | write     95 | avio
> >    2 ms |
> >=20
> > I wrote by mail since bugzilla has too many MySQL connections again.
> > Maybe bug can be switched to mail?
> >=20
> > Rebooting and testing this kernel another time whether it hard
> > freezes, --
> > Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> > GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7


=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart8395243.0ytDIrv5jT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyGwswACgkQmRvqrKWZhMdT+gCeOT403L0F6dL5dpyT1k0XcI5v
2HsAmgJC13yi4m9eMJT/rzXwdw00BSoM
=6vFa
-----END PGP SIGNATURE-----

--nextPart8395243.0ytDIrv5jT--
