Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1GZSs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:48:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032Ab1GZSsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:48:22 -0400
Subject: Re: [Intel-gfx] drm/i915: A selection of display port fixes
From: Adam Jackson <ajax@redhat.com>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Date: Tue, 26 Jul 2011 14:48:13 -0400
In-Reply-To: <1311662194-4050-1-git-send-email-keithp@keithp.com>
References: <1311662194-4050-1-git-send-email-keithp@keithp.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-87jTVUvTKwAM1TcvFgLV"
Message-ID: <1311706099.1723.22.camel@atropine>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-87jTVUvTKwAM1TcvFgLV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-07-25 at 23:36 -0700, Keith Packard wrote:
> [PATCH 1/5] drm/i915: Use dp_detect_common in hotplug helper
>  [PATCH 2/5] drm/i915: Rename i915_dp_detect_common to
>  [PATCH 3/5] drm/i915: In intel_dp_init, replace read of DPCD with
>=20
> These three are simple cleanups to centralize all places where the
> DPCD block was read from the device. Now everyone shares the same
> function, and that function retries the reads.

Reviewed-by: Adam Jackson <ajax@redhat.com>

>  [PATCH 4/5] drm/i915: Delay 250ms before running the hotplug code
>=20
> I was experimenting with DP hotplugging -- moving the plug in and out
> of the jack very slowly and discovered that the hotplug interrupt
> occurred well before or after the link for the aux data channel was
> connected or disconnected. The result of this was that a sufficiently
> rapid cycle back through user mode could easily beat the motion of the
> plug and cause the hotplug detection to get the wrong status. Sticking
> a 250ms delay before doing anything gives the user sufficient time to
> actually get the plug connected or disconnected.

At the very least this should instead be queue_delayed_work().  But if
we're going to delay, can we instead set up PCH_PORT_HOTPLUG to do a
100ms delay for us?  I'll try this locally, at any rate.

>  [PATCH 5/5] drm/i915: DP_PIPE_ENABLED must check transcoder on CPT
>=20
> <snip>
>
> Turns out the bug wasn't that the mode setting code was doing it wrong
> and turning the DP2 output off intentionally as a part of the mode
> change. Instead, the intel driver was trying to adjust the PCH link
> for the LVDS1 output and thought it needed to turn the DP2 output off
> because it mistakenly believed the DP2 output was sharing the same
> pipe as the LVDS1 output. Just a matter of using the wrong mechanism
> to detect which pipe the DP2 output was connected to.

Reviewed-by: Adam Jackson <ajax@redhat.com>

- ajax

--=-87jTVUvTKwAM1TcvFgLV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk4vC+0ACgkQW4otUKDs0NMazACeIDRvSvB9VNSH1AUmgjV2CSCV
sC0AoMh60Z/wBJNLQuFiIfXGwfcy0uM4
=yObZ
-----END PGP SIGNATURE-----

--=-87jTVUvTKwAM1TcvFgLV--

