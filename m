Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1CJThP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:37:15 -0500
Received: from home.keithp.com ([63.227.221.253]:39645 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab1CJThN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:37:13 -0500
From: Keith Packard <keithp@keithp.com>
To: Takashi Iwai <tiwai@suse.de>, Indan Zupancic <indan@nul.nu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Alex Riesen <raa.lkml@gmail.com>, Tino Keitel <tino.keitel@tikei.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Subject: Re: [PATCH] drm/i915: Revive combination mode for backlight control
In-Reply-To: <s5hr5afm8mj.wl%tiwai@suse.de>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com> <20110216192658.GA7225@blimp.localdomain> <20110217221329.GA3332@x61.home> <3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl> <AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com> <AANLkTik3ECs5z5td6GYuDExrc74_18mC-bk-hsq4e1+i@mail.gmail.com> <AANLkTik9XHcDUbPTPh6t--TwQompeQBY9TNuuBRk++-6@mail.gmail.com> <20110222130440.21a27714@jbarnes-desktop> <20110222223120.GA3567@x61.home> <AANLkTimLBo4REwrCJfy3U_z-SJ8uoOurO7c66D5RpZRh@mail.gmail.com> <3e6f092bd0aa54fd6b9eb524f6c87ecf.squirrel@webmail.greenhost.nl> <AANLkTimyQ30ELw9Sm57NXgetiXnzJMHby2BE3GsynJLs@mail.gmail.com> <1a06e2711df021a802d609ad1a75db17.squirrel@webmail.greenhost.nl> <s5h4o7btnxq.wl%tiwai@suse.de> <s5hy64ns7pq.wl%tiwai@suse.de> <a04bdafb8c7a97d92593e980b01b37fd.squirrel@webmail.greenhost.nl> <s5hr5afm8mj.wl%tiwai@suse.de>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Thu, 10 Mar 2011 11:36:51 -0800
Message-ID: <yunr5ae4vjg.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Mar 2011 14:02:12 +0100, Takashi Iwai <tiwai@suse.de> wrote:
> This reverts commit 951f3512dba5bd44cda3e5ee22b4b522e4bb09fb
>=20
>     drm/i915: Do not handle backlight combination mode specially
>=20
> since this commit introduced other regressions due to untouched LBPC
> register, e.g. the backlight dimmed after resume.
>=20
> In addition to the revert, this patch includes a fix for the original
> issue (weird backlight levels) by removing the wrong bit shift for
> computing the current backlight level.
> Also, including typo fixes (lpbc -> lbpc).
>=20
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=3D34524
> Acked-by: Indan Zupancic <indan@nul.nu>
> Cc: <stable@kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

This looks good, and ensures that LBPC ranges from 0 - 0xfe as required.

The one thing we want is a comment that explains

> +			val &=3D ~1;

The reason for this is that some ancient platforms wire this bit to
be "go to max backlight", or at least that's why this was in the 2D
driver from which this code was derived.

Reviewed-by: Keith Packard <keithp@keithp.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNeShTQp8BWwlsTdMRArtPAKCvLOuseWRkdIEHb5ncDMVFjAlIFQCfcnSK
UnIpAwX0o3OTEVIWr7xmxiQ=
=+uEn
-----END PGP SIGNATURE-----
--=-=-=--
