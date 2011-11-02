Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab1KBSyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:54:32 -0400
Received: from home.keithp.com ([63.227.221.253]:44934 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933302Ab1KBSy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:54:29 -0400
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most places
In-Reply-To: <1320214830-12696-4-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-4-git-send-email-keithp@keithp.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 02 Nov 2011 11:54:25 -0700
Message-ID: <yunobwuuzha.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue,  1 Nov 2011 23:20:26 -0700, Keith Packard <keithp@keithp.com> wrote:

>  		intel_dp =3D enc_to_intel_dp(encoder);
> -		if (intel_dp->base.type =3D=3D INTEL_OUTPUT_DISPLAYPORT) {
> +		if (intel_dp->base.type =3D=3D INTEL_OUTPUT_DISPLAYPORT || is_pch_edp(=
intel_dp)) {
>  			lane_count =3D intel_dp->lane_count;
>  			break;
> -		} else if (is_edp(intel_dp)) {
> +		} else if (is_cpu_edp(intel_dp)) {
>  			lane_count =3D dev_priv->edp.lanes;
>  			break;

Thinking about this one more time -- if we ever want to use
dev_priv->edp.lanes, we should use it in
intel_dp_max_lane_count. intel_dp_set_m_n should use
intel_dp->lane_count unconditionally as that's the value we've used
everywhere else for mode setting.

Perhaps we should use it for monitors that don't include the
MAX_LANE_COUNT field in the dpcd? Perhaps we should use it on all eDP
monitors?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrGR4jYtFsjWk68qAQgNvRAAznxu+veqm4wCK/LORNY1ZL7jbFxw4FGi
Lud+m7urf6qK9N1tgi7xgaujMRNPt7TYE6E1rgfkbLsSC7bdC0jiFvK7Cci9ra68
0iLtqWdhM8v03tkd2BLwpsbh8503n1KZthAF0s4dsO/L4dGM3Y+AEMwfcC453lQE
U3kM6lP0fDPbYB/SQDedzORR0gadpOK7NCBhZIV4MjHrGC3IG39vqwrOQa9egyZM
LYKRoSNaZgroTe4VBZpMVWTsjxgapukzyHXMbcoyFqDp0DIcxX+r6PDVmaYDqx/y
qIXh+uvWQmVhXcqs5W55OFs67rB0XXE0XNa4YRC1VQ+GcW2sCH3Y9tM9MXy0oULC
jrAcIUOG1OMQfcTIlxIka9zwhKBeYZo9i7vwGkXW9UsgZtE5euFMOhtUU/9IG8na
jy53VenRcLBZpU+HENxrz/E4qDSKDn9ba0V+y7lk2+Ym44/S6v1qE4908Kc7f2f3
DeeP7vyd9CSX+AnskUA6qyA0qEMUVXL0MmwDL4A+a1LUpILYVl0bzUa5zur8ri+X
dPMQfGQdPSDCscW58JQVAd5SqyjOjdHPQ2AX76+yeHV0g2GxR4YS6PzBXuJ2wIjw
Iecn+T23jvxxDilADC8YvnKuX3qBkliwsIz9xJTHeuHeSSXz/B0Qqkduy65YQtNk
AX2zZOvY7Mg=
=FS+f
-----END PGP SIGNATURE-----
--=-=-=--
