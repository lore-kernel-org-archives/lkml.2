Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab1BQRbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:31:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46600 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab1BQRbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:31:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hy0hQO+LBKm18xM3eMpE3DvnLFTQx5PQokBpo8X3T4saxRFVU6NdzR37TRKkfW3kcq
         bvzFaRGnyg5ziiM9aRZOJst7Rgs261SPxmn1iCOqg5NxYCoSzOdOjkpvDnx8XrSh/jUG
         dgAPiESg+rdPKlIaGAc6MwOatBvqoqfl6torI=
Date: Thu, 17 Feb 2011 19:31:18 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Jerome Glisse <jglisse@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: bisected: 5b40ddf888398ce4cccbf3b9d0a18d90149ed7ff is the first
 bad commit
Message-ID: <20110217173118.GA4334@swordfish.minsk.epam.com>
References: <20110217141858.GA4746@swordfish.minsk.epam.com>
 <AANLkTimLEUxpya8yku4Re=MQZrGVH9bTWubj3+fbw1Dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <AANLkTimLEUxpya8yku4Re=MQZrGVH9bTWubj3+fbw1Dc@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (02/17/11 12:04), Alex Deucher wrote:
> > Commit 5b40ddf888398ce4cccbf3b9d0a18d90149ed7ff has broken video output=
 on my Radeon HD 5470 --
> > see screenshot attached.
>=20
> Should be fixed in this commit:
> http://git.kernel.org/?p=3Dlinux/kernel/git/airlied/drm-2.6.git;a=3Dcommi=
tdiff;h=3D9f4283f49f0a96a64c5a45fe56f0f8c942885eef
>=20

Works for me, thanks.

	Sergey

>=20
>=20
> >
> > bisect log:
> > git bisect start '--' 'drivers/gpu/drm/radeon/'
> > # bad: [e53b2057d8fccc3394cc38463171df948ce43aaa] Merge branch 'master'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
> > git bisect bad e53b2057d8fccc3394cc38463171df948ce43aaa
> > # good: [87364760de5d631390c478fcbac8db1b926e0adf] drm/radeon/kms: fix =
s/r issues with bios scratch regs
> > git bisect good 87364760de5d631390c478fcbac8db1b926e0adf
> > # good: [4eace7fdfa1f8ac2f0a833e12bd07eeb453ec9ef] drm/radeon/kms: 6xx/=
7xx big endian fixes
> > git bisect good 4eace7fdfa1f8ac2f0a833e12bd07eeb453ec9ef
> > # good: [501834349e872ed4115eea3beef65ca9eeb5528e] drm/radeon/kms: fix =
tracking of BLENDCNTL, COLOR_CHANNEL_MASK, and GB_Z on r300
> > git bisect good 501834349e872ed4115eea3beef65ca9eeb5528e
> > # good: [c2049b3d29f47ed3750226dc51251a3404c85876] drm/radeon/kms: impr=
ove 6xx/7xx CS error output
> > git bisect good c2049b3d29f47ed3750226dc51251a3404c85876
> > # good: [265aa6c8d8822c9074a2174e8c9f31a37fa02e50] drm/radeon/kms: fix =
a few more atombios endian issues
> > git bisect good 265aa6c8d8822c9074a2174e8c9f31a37fa02e50
> > # good: [a4b40d5d97f5c9ad0b7f4bf2818291ca184bb433] drm/radeon/kms: add =
bounds checking to avivo pll algo
> > git bisect good a4b40d5d97f5c9ad0b7f4bf2818291ca184bb433
> > # bad: [5b40ddf888398ce4cccbf3b9d0a18d90149ed7ff] drm/radeon/kms: hopef=
ully fix pll issues for real (v3)
> > git bisect bad 5b40ddf888398ce4cccbf3b9d0a18d90149ed7ff
> >
> >
> > 5b40ddf888398ce4cccbf3b9d0a18d90149ed7ff is the first bad commit
> > commit 5b40ddf888398ce4cccbf3b9d0a18d90149ed7ff
> > Author: Alex Deucher <alexdeucher@gmail.com>
> > Date: =A0 Mon Feb 14 11:43:11 2011 -0500
> >
> > =A0 =A0drm/radeon/kms: hopefully fix pll issues for real (v3)
> >
> > =A0 =A0The problematic boards have a recommended reference divider
> > =A0 =A0to be used when spread spectrum is enabled on the laptop panel.
> > =A0 =A0Enable the use of the recommended reference divider along with
> > =A0 =A0the new pll algo.
> >
> > =A0 =A0v2: testing options
> >
> > =A0 =A0v3: When using the fixed reference divider with LVDS, prefer
> > =A0 =A0min m to max p and use fractional feedback dividers.
> >
> > =A0 =A0Fixes:
> > =A0 =A0https://bugzilla.kernel.org/show_bug.cgi?id=3D28852
> > =A0 =A0https://bugzilla.kernel.org/show_bug.cgi?id=3D24462
> > =A0 =A0https://bugzilla.kernel.org/show_bug.cgi?id=3D26552
> > =A0 =A0MacbookPro issues reported by Justin Mattock <justinmattock@gmai=
l.com>
> >
> > =A0 =A0Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
> > =A0 =A0Cc: stable@kernel.org
> > =A0 =A0Signed-off-by: Dave Airlie <airlied@redhat.com>
> >
> > :040000 040000 8736f993b97cc8370fd29048761a1e0da4969306 657bdb221e3f4da=
6efdfec02f8f348db5a537b29 M =A0 =A0 =A0drivers
> >
> >
> > =A0kernel: [ =A0 =A02.292708] [drm] Initialized drm 1.1.0 20060810
> > =A0kernel: [ =A0 =A02.292954] [drm] radeon defaulting to kernel modeset=
ting.
> > =A0kernel: [ =A0 =A02.293028] [drm] radeon kernel modesetting enabled.
> > =A0kernel: [ =A0 =A02.293156] radeon 0000:01:00.0: power state changed =
by ACPI to D0
> > =A0kernel: [ =A0 =A02.293238] radeon 0000:01:00.0: power state changed =
by ACPI to D0
> > =A0kernel: [ =A0 =A02.293322] radeon 0000:01:00.0: PCI INT A -> GSI 16 =
(level, low) -> IRQ 16
> > =A0kernel: [ =A0 =A02.293404] radeon 0000:01:00.0: setting latency time=
r to 64
> > =A0kernel: [ =A0 =A02.296184] [drm] initializing kernel modesetting (CE=
DAR 0x1002:0x68E0).
> > =A0kernel: [ =A0 =A02.296406] [drm] register mmio base: 0xB4000000
> > =A0kernel: [ =A0 =A02.296477] [drm] register mmio size: 131072
> > =A0kernel: [ =A0 =A02.296835] ATOM BIOS: Acer
> > =A0kernel: [ =A0 =A02.297009] radeon 0000:01:00.0: VRAM: 512M 0x0000000=
000000000 - 0x000000001FFFFFFF (512M used)
> > =A0kernel: [ =A0 =A02.297103] radeon 0000:01:00.0: GTT: 512M 0x00000000=
20000000 - 0x000000003FFFFFFF
> > =A0kernel: [ =A0 =A02.298370] [drm] Detected VRAM RAM=3D512M, BAR=3D256M
> > =A0kernel: [ =A0 =A02.298450] [drm] RAM width 64bits DDR
> > =A0kernel: [ =A0 =A02.298800] [TTM] Zone =A0kernel: Available graphics =
memory: 1946448 kiB.
> > =A0kernel: [ =A0 =A02.298876] [TTM] Initializing pool allocator.
> > =A0kernel: [ =A0 =A02.299366] [drm] radeon: 512M of VRAM memory ready
> > =A0kernel: [ =A0 =A02.299440] [drm] radeon: 512M of GTT memory ready.
> > =A0kernel: [ =A0 =A02.299581] [drm] Supports vblank timestamp caching R=
ev 1 (10.10.2010).
> > =A0kernel: [ =A0 =A02.299659] [drm] Driver supports precise vblank time=
stamp query.
> > =A0kernel: [ =A0 =A02.299831] radeon 0000:01:00.0: irq 41 for MSI/MSI-X
> > =A0kernel: [ =A0 =A02.299840] radeon 0000:01:00.0: radeon: using MSI.
> > =A0kernel: [ =A0 =A02.299995] [drm] radeon: irq initialized.
> > =A0kernel: [ =A0 =A02.300066] [drm] GART: num cpu pages 131072, num gpu=
 pages 131072
> > =A0kernel: [ =A0 =A02.300953] [drm] Loading CEDAR Microcode
> > =A0kernel: [ =A0 =A02.303973] radeon 0000:01:00.0: WB enabled
> > =A0kernel: [ =A0 =A02.320988] [drm] ring test succeeded in 0 usecs
> > =A0kernel: [ =A0 =A02.321411] [drm] radeon: ib pool ready.
> > =A0kernel: [ =A0 =A02.324453] [drm] ib test succeeded in 0 usecs
> > =A0kernel: [ =A0 =A02.327055] [drm] Radeon Display Connectors
> > =A0kernel: [ =A0 =A02.327126] [drm] Connector 0:
> > =A0kernel: [ =A0 =A02.327193] [drm] =A0 LVDS
> > =A0kernel: [ =A0 =A02.327259] [drm] =A0 DDC: 0x6560 0x6560 0x6564 0x656=
4 0x6568 0x6568 0x656c 0x656c
> > =A0kernel: [ =A0 =A02.327348] [drm] =A0 Encoders:
> > =A0kernel: [ =A0 =A02.327414] [drm] =A0 =A0 LCD1: INTERNAL_UNIPHY
> > =A0kernel: [ =A0 =A02.327483] [drm] Connector 1:
> > =A0kernel: [ =A0 =A02.327551] [drm] =A0 HDMI-A
> > =A0kernel: [ =A0 =A02.327617] [drm] =A0 HPD1
> > =A0kernel: [ =A0 =A02.327683] [drm] =A0 DDC: 0x6430 0x6430 0x6434 0x643=
4 0x6438 0x6438 0x643c 0x643c
> > =A0kernel: [ =A0 =A02.327772] [drm] =A0 Encoders:
> > =A0kernel: [ =A0 =A02.327839] [drm] =A0 =A0 DFP1: INTERNAL_UNIPHY1
> > =A0kernel: [ =A0 =A02.327909] [drm] Connector 2:
> > =A0kernel: [ =A0 =A02.328004] [drm] =A0 VGA
> > =A0kernel: [ =A0 =A02.328071] [drm] =A0 DDC: 0x6460 0x6460 0x6464 0x646=
4 0x6468 0x6468 0x646c 0x646c
> > =A0kernel: [ =A0 =A02.328159] [drm] =A0 Encoders:
> > =A0kernel: [ =A0 =A02.328226] [drm] =A0 =A0 CRT1: INTERNAL_KLDSCP_DAC1
> > =A0kernel: [ =A0 =A02.334272] [drm] Internal thermal controller with fa=
n control
> > =A0kernel: [ =A0 =A02.334709] [drm] radeon: power management initialized
> > =A0kernel: [ =A0 =A02.734897] [drm] fb mappable at 0xA0141000
> > =A0kernel: [ =A0 =A02.734968] [drm] vram apper at 0xA0000000
> > =A0kernel: [ =A0 =A02.735037] [drm] size 4325376
> > =A0kernel: [ =A0 =A02.735104] [drm] fb depth is 24
> > =A0kernel: [ =A0 =A02.735170] [drm] =A0 =A0pitch is 5632
> > =A0kernel: [ =A0 =A02.820545] Refined TSC clocksource calibration: 2261=
=2E390 MHz.
> > =A0kernel: [ =A0 =A02.820560] Switching to clocksource tsc
> > =A0kernel: [ =A0 =A03.727928] Console: switching to colour frame buffer=
 device 170x48
> > =A0kernel: [ =A0 =A03.730609] fb0: radeondrmfb frame buffer device
> > =A0kernel: [ =A0 =A03.730611] drm: registered panic notifier
> > =A0kernel: [ =A0 =A03.730684] [drm] Initialized radeon 2.8.0 20080528 f=
or 0000:01:00.0 on minor 0
> > =A0kernel: [ =A0 =A03.736754] brd: module loaded
> >
> >
> >
> > =A0 =A0 =A0 =A0Sergey
>=20

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk1dW2YACgkQfKHnntdSXjQy2wP/WIbJLEURb5o3qzCULdDntC5E
+WdNwgNbPOXW7mADJM4QZfp+xCOROmrUsFKPBZSreZ3d/1oYe+7zZWOjO3ybfjMS
hTu95aHFYGOFDrvYmVbNL00T+PHSyrb/etOuAeWwZUll+ddZ8lTYKhz4ypCyDqAA
CbZ10lEFqEvscZS6q2E=
=hKPH
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
