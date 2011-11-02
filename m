Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab1KBQUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:20:30 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:43629 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932431Ab1KBQU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:20:26 -0400
Date: Wed, 2 Nov 2011 09:20:19 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most
 places
Message-ID: <20111102092019.3a635632@jbarnes-desktop>
In-Reply-To: <1320214830-12696-4-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
	<1320214830-12696-4-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=fux+Y21T..6.BTqp2EHD9J"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=fux+Y21T..6.BTqp2EHD9J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  1 Nov 2011 23:20:26 -0700
Keith Packard <keithp@keithp.com> wrote:

> PCH eDP has many of the same needs as regular PCH DP connections,
> including the DP_CTl bit settings, the TRANS_DP_CTL register.
>=20
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_display.c |    3 +-
>  drivers/gpu/drm/i915/intel_dp.c      |  112 ++++++++++++++++++++++++----=
------
>  2 files changed, 81 insertions(+), 34 deletions(-)
>=20

Might be nice to have some function pointers to handle the different
types better.  But that could be a separate cleanup.  I'd rather have
duplicated code than fragile code...

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

But I was curious about this hunk:

@@ -766,10 +766,10 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_di=
splay_mode *mode,
 			continue;
=20
 		intel_dp =3D enc_to_intel_dp(encoder);
-		if (intel_dp->base.type =3D=3D INTEL_OUTPUT_DISPLAYPORT) {
+		if (intel_dp->base.type =3D=3D INTEL_OUTPUT_DISPLAYPORT || is_pch_edp(in=
tel_dp)) {
 			lane_count =3D intel_dp->lane_count;
 			break;
-		} else if (is_edp(intel_dp)) {
+		} else if (is_cpu_edp(intel_dp)) {
 			lane_count =3D dev_priv->edp.lanes;
 			break;
 		}

I guess this means we can't trust the BIOS settings for PCH eDP?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/=fux+Y21T..6.BTqp2EHD9J
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsW3DAAoJEIEoDkX4Qk9hlOoP/3BLRllQuUbtNPfRGex2ZVdT
sq7JefaQfeGTfNaQ34X8GUbwcsWmEJNBD1PBvy4K031sGy+iCBQCc8upWH39CbwC
aGGlwfOpTjtoPhN2doCSJBoUOoFdnS+B2/igcxKguqi/1S/RnUvuW0o8QAp7tmFn
HwowigrQRK3mldYU4MTZzOYAe4C0urwWQDWjJEGSqp3RTmiF2Kcw/uuxmYjKBY6+
xJRQYIWH7P/ZAxFKCa6GZgIj484HTHGfQallp0/IH7aH6WCk7b3JmzP0I58G7zHa
MQqrEumdka4KYoqrn6vpknD1cYYig1I/JhdFmtx3G2rJhjOBYykmbSq25Rcky+k2
ClmDxrg11Vbwn4wH132fjPcVfYueXnWD4xE01dVckGslUnUhFooz/WU5YJSHebk4
YDVf8VCa51Gys0rMp58DOCqZHtLOIP0+NyDVC5T6G/jDN52J6XpgVUqzMszYJM4L
ClaafDj9RoESeyYfpOsOKHnIQt0gWZ9/IJKFDAbRWKLtCRyIiUbRaw+/heifw/5x
cvADh2GOsBqqUnCt80qEW9N6yhjl/9mfiuudaFLvYWrtuKY9ydNzNRwp6s7RXQo+
fofiUEZzO3cyRMBL/YiYuUn0l/SzC38Kssarho+QWLxdNZx4DXC8x3fadcEMgTbo
xCkp/fcY4qY0y0Zov1PN
=EnaP
-----END PGP SIGNATURE-----

--Sig_/=fux+Y21T..6.BTqp2EHD9J--
