Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab1KBRKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:10:25 -0400
Received: from home.keithp.com ([63.227.221.253]:55947 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120Ab1KBRKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:10:24 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most places
In-Reply-To: <20111102092019.3a635632@jbarnes-desktop>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-4-git-send-email-keithp@keithp.com> <20111102092019.3a635632@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 02 Nov 2011 10:10:20 -0700
Message-ID: <yunobwuwiv7.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Nov 2011 09:20:19 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> But I was curious about this hunk:
>=20
> @@ -766,10 +766,10 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_=
display_mode *mode,
>  			continue;
>=20=20
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
>  		}
>=20
> I guess this means we can't trust the BIOS settings for PCH eDP?

I'm pretty sure this isn't the right place to look at this value in any
case; we're setting the m/n ratios after already deciding how many lanes
to use. Getting this wrong means sending the wrong timing to the
monitor, not setting a different mode.

In any case, my AIO box sets the BIOS value to 1, when it needs 2 lanes
for the mode it uses.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrF5fDYtFsjWk68qAQh4Eg/9HL22sclyyn37jDFO+PcpXVP4VscfIMCZ
FSKtE8WeipHR7/kq4ztSB4IMIJTTgVgs+gQzFklQvvo6FckW7grmvNS+mc3PWPPy
HAgElk6DdCtn2p3dAmzrNpVkBcpztFc03KaVV0+Amj8qARGtkcL1+e0qFzRpThIE
ifUmPvlyHCFPBsbRAA8YAXVJR0M0GdNKRogd7OEJ68Db0obYSLXhG/CV8/aLm0Rq
O1j2AqhiGjM/JvVSuvAlSSyE81hrXUGtASNcR9aZQKS8DpMgofOtHg8HRZyM1OgA
oDtTT3NEojU1p5Gjt4adFdnMexIa9gesu2/eS5GA+NTWej3IohqPvwvkjCXme6jF
HGNdM0VXh3E+zsw0XJMaThvLXwMNYnw65RT14hLSTXXrDl+5x//W9fAzjgZhUnoD
+p2NUr0YRF1pCevGO66aB7d/3ki8Z7XS0etj3s6EbV6F2ZEF2F5a3JnHYE65L7dq
RAtF/T+jLnZ+TWKBgr9daiGM7EL1XKjjS78RpelUmH9ko9aJ14gEC81Yc/3miIz1
q+49VEtijMB3gek1M2B4qmBsLFLZoyNOVWFQ+reGCDqt+3DQmWTLJrLlQOAEIaIk
F0tTGzQaHV/POVIYOIu02iTG8eRaPIyBb+XPfQV1WizJiUlOqcOsQVYzzepqpHXs
GVa//NJGY5I=
=sj0k
-----END PGP SIGNATURE-----
--=-=-=--
