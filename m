Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab2AYW4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:56:45 -0500
Received: from home.keithp.com ([63.227.221.253]:56224 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab2AYW4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:56:44 -0500
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915: Select DP BPC at mode set, rather than mode validate
In-Reply-To: <20120125221100.GK3896@phenom.ffwll.local>
References: <1327508186-26704-1-git-send-email-keithp@keithp.com> <1327508186-26704-3-git-send-email-keithp@keithp.com> <20120125221100.GK3896@phenom.ffwll.local>
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 25 Jan 2012 14:56:40 -0800
Message-ID: <864nvjcrx3.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Jan 2012 23:11:00 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:

> I'm a bit unhappy how generic code in intel_display.c calls function out
> of intel_dp.c. And choose_pipe_bpp_dither already has special cases for
> quite a few other encoders ... Could we add an ->adjust_bpc function to
> intel_encoder to separate this in a cleaner fashion?

Yeah, seems quite reasonable.

I can't find any reason why the lane count and link bw values are set in
fixup_mode and not just in intel_dp_set_mode. If we moved that, we could
use the bpp value computed in intel_display.c.

There's a weird mixture of code in ironlake_crtc_mode_set where it calls
intel_edp_link_config and uses those values when setting the CPU M/N
values for non-PCH eDP panels. That would also need fixing.

> I know that this isn't really the only layering violation in
> intel_display.c, but functions in that file have an uncanny ability to
> grow without bounds ;-)

The more we clean things up, the easier fixing bugs is in the future.

> As you've already said in another mail, this PCH_SPLIT here looks a bit
> strange. Could we unify these two paths here a bit?

The simple way to unify them would be to use
intel_choose_pipe_bpp_dither from the i9xx_crtc_mode_set path. Perhaps
that function could codify the currently simplistic rule used on i9xx?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTyCIqDYtFsjWk68qAQhNXA/+NqOiZoTqcFt06xG5DmOhVfCG6oy2x9UV
RERNZt5orLWcqov9Y3h6WxqdtEvUqAWdjnpuEelvcRx8tVC/yQm6Fk3jK9nZ0X6O
5MIuWweqKeIwKb2n35n3mAWOz3dx9cddPcW+dVPXRXgqpGclTdodBLnVkhgSn75f
aRP3yBHcV5WsbA5w97rF63WHeY72b3PApW+AtgpXAwdE9vyohC3Kicp1i4/cje/h
yVLBYrI/ptdWDUaZPDNlGJShZ2+DDgaFTspXDh+tDf0+YTZkLeNAGGp6vpJrVsth
N0IuX3N20izYA1H3k7Lb60zXDqCBojPeJ0Dvj2rVq+qYu0hQ/a82/S+ntP/thqlY
ir1Ufkx5BvgS8k1RDZvKftf0mnoThu41wUuFPR1gHkJOKpdWDoBs+07NXUQDJY9y
fwLH0ekXntOj7SkQ2PnFahbvDpB9eqHIYPF6lt/WvnYM4bbq8Mvfnz3I9EupzaWh
rnI4ZTgGwUmdFf8b58kGx1KN5LvGW1cAyPDOUO3BDYlxe8Kd8w+HAiYvcWnLt748
NZ1hzEeFJ6eVPGrPkcGzIawzNtxsVPqJk7+rifPt3oUjnm+ODt2TNvgC7cSp1TGx
DKb9Jr/qBRxnVLnLqUhsBX9VOfI8MMaEpJv5HTMfAS/0NGEjhqetwfLzT1gyal1x
8rbOp4JJUpU=
=6vCO
-----END PGP SIGNATURE-----
--=-=-=--
