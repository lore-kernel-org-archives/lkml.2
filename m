Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2AYUvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 15:51:23 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:42215 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751072Ab2AYUvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 15:51:22 -0500
Date: Wed, 25 Jan 2012 12:51:16 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: Force explicit bpp selection
 for intel_dp_link_required
Message-ID: <20120125125116.5cea2c4b@jbarnes-desktop>
In-Reply-To: <1327508186-26704-2-git-send-email-keithp@keithp.com>
References: <1327508186-26704-1-git-send-email-keithp@keithp.com>
	<1327508186-26704-2-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EFUvum3PebDF2QUdr8xB6Es"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/EFUvum3PebDF2QUdr8xB6Es
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Jan 2012 08:16:25 -0800
Keith Packard <keithp@keithp.com> wrote:

> It is never correct to use intel_crtc->bpp in intel_dp_link_required,
> so instead pass an explicit bpp in to this function. This patch
> only supports 18bpp and 24bpp modes, which means that 10bpc modes will
> be computed incorrectly. Fixing that will require more extensive
> changes, and so must be addressed separately from this bugfix.
>=20
> intel_dp_link_required is called from intel_dp_mode_valid and
> intel_dp_mode_fixup.
>=20
> * intel_dp_mode_valid is called to list supported modes; in this case,
>   the current crtc values cannot be relevant as the modes in question
>   may never be selected. Thus, using intel_crtc->bpp is never right.
>=20
> * intel_dp_mode_fixup is called during mode setting, but it is run
>   well before ironlake_crtc_mode_set is called to set intel_crtc->bpp,
>   so using intel_crtc-bpp in this path can only ever get a stale
>   value.

Yeah, looks like I got this wrong when I added the pipe bpp field.
Wonder if there's a good way to catch this sort of bug with an assert
so we don't get the order mixed up again...

The big downside here is that we'll be very pessimistic about the link
bw requirements for say 16 or 8bpp modes.

I see you have another patch to address some of this, but I wonder if
we have enough info to calculate the bpp at prepare time so it's set
early on for use by both the crtc and encoder code?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/EFUvum3PebDF2QUdr8xB6Es
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIGtEAAoJEIEoDkX4Qk9hjk0QAMn6dWl+WgcLvocQqD64ZkqS
ulvSnSB4b8xBYNbMU+sUEMyJXF15L13Lgs56NPvc86AZHLt+g0L7psNKfc92MHcM
U7aIJVJ+d3xK/IOmoMGqo6V0DKXsW2zI7ylUROfsyxq6LjnjWMU7TldV+Cd29t4w
jqkmkXyTwNFn+ccWaE3CtPFcDLUO86h1fAniKbU8djOjK7qXeEX6HYaYec93F1DI
fYRnDY5RQq51b9htxcgMw4nsHE+Ed9pJgsOKZgfzfJdEmcDEeA2N5oO9LDDQYxjP
Sja+gRfnYYen24nQyya9fqqQ5fORzWx7XaeXaUGoUnj3LluXsvgIG6bTSoaSHNNx
ERRMgk/by5To+kItOb/RXaibzCswX1u+LD4YmjJS5hb/VvwhnSGWo9G2cMX4fEwU
4DI/nvr7AhwSKa/YcVHxe/aL7OQQ7H6OVhbx5IesrqyYIeKilEjLLESNMCEsanwk
PghzESPKP2A+S0THJoHhH2AKdXQGClSGi+zF/QdXcH5aw9+HNDScUC8jY/UWJ9GO
c+2uVNakKJJksE9IgC/7aVU27rxIQkAU0I6rs6NgCcjDdkILJTxhUwO+RggN9zN2
uP2Rxa1HfQBE3hF2Qg5koFmwGTehIRJLcrJdm8JqA/YxBBg7e8zUcbnU7EZiUccO
kb95Un8WJm/p00NBunIS
=OTc/
-----END PGP SIGNATURE-----

--Sig_/EFUvum3PebDF2QUdr8xB6Es--
