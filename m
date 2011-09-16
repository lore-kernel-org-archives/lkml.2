Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1IPEx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 00:53:26 -0400
Received: from home.keithp.com ([63.227.221.253]:32970 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab1IPExZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 00:53:25 -0400
From: Keith Packard <keithp@keithp.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alex Deucher <alexdeucher@gmail.com>
Cc: linux-fbdev@vger.kernel.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Archit Taneja <archit@ti.com>, "Clark\, Rob" <rob@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
In-Reply-To: <4E724659.5080709@gmx.de>
References: <1316088425.11294.78.camel@lappyti> <yunboul7sx7.fsf@aiko.keithp.com> <1316100594.23214.65.camel@deskari> <yun8vpp7qk7.fsf@aiko.keithp.com> <4E72320B.6020000@gmx.de> <CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com> <4E724659.5080709@gmx.de>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 15 Sep 2011 21:53:21 -0700
Message-ID: <yunsjnxulz2.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Sep 2011 18:39:21 +0000, Florian Tobias Schandinat <FlorianSchan=
dinat@gmx.de> wrote:

> Well, I'm not against sharing the code and not against taking DRM's curre=
nt
> implementation as a base but the steps required to make it generally acce=
ptable
> would be to split it of, probably as a standalone module and strip all DRM
> specific things off. Than all things that require EDID can use it, DRM ca=
n add
> DRM-specific things on top and fb can add fb-specific things.

The rendering portions of the DRM drivers are all device-specific. The
core DRM ioctls are largely about providing some sharing control over
the device, mapping memory around and mode setting.

> One of my biggest problems with KMS is that it has (naturally) a lot more
> complexity than the fb API which leads to instability.

The mode setting portions are of necessity the same. The KMS API exposes
more functionality for mode setting, but doesn't actually require any
additional hardware-specific knowledge. You still have to be able to
bring the hardware up from power on and light up every connected
monitor.

However, if you want acceleration, you're going to run into bugs that
crash the machine. It's a sad reality that graphics hardware just isn't
able to recover cleanly in all cases from programmer errors, and that
includes errors that come from user mode.

Hardware is improving in this area, and reset is getting more reliable
than it used to be. But, until we can context switch the graphics
hardware at arbitrary points during execution, we're kinda stuck with
using the really big reset hammer when programs go awry.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOctZBQp8BWwlsTdMRAh50AKCnOL5Xc5vMOOoslnd3Ms+sW2c3EQCg2pls
Zu8aFtj9cbvUdfEggfd/mgk=
=fH74
-----END PGP SIGNATURE-----
--=-=-=--
