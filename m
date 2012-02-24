Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab2BXRdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:33:53 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:60460 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755525Ab2BXRdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:33:52 -0500
Date: Fri, 24 Feb 2012 09:33:47 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eugeni Dodonov <eugeni.dodonov@intel.com>
Cc: intel-gfx@lists.freedesktop.org, just.for.lkml@googlemail.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH 1/1] drm/i915: fix operator precedence when enabling
 RC6p
Message-ID: <20120224093347.15a2d5cf@jbarnes-desktop>
In-Reply-To: <1330048626-16861-1-git-send-email-eugeni.dodonov@intel.com>
References: <CAPVoSvSvQv14dM6EWTi3YxUtxNWB8+kypDHSwkYTiWpBxL2eug@mail.gmail.com>
	<1330048626-16861-1-git-send-email-eugeni.dodonov@intel.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9Zor=VgLof+1OP==SV1wtlG"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/9Zor=VgLof+1OP==SV1wtlG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Feb 2012 23:57:06 -0200
Eugeni Dodonov <eugeni.dodonov@intel.com> wrote:

> As noticed by Torsten Kaiser, the operator precedence can play tricks with
> us here.
>=20
> CC: Dave Airlie <airlied@redhat.com>
> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
> ---
>  drivers/gpu/drm/i915/intel_display.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/=
intel_display.c
> index e654f32..4871ba0 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -8194,7 +8194,7 @@ void gen6_enable_rps(struct drm_i915_private *dev_p=
riv)
> =20
>  	if (intel_enable_rc6(dev_priv->dev))
>  		rc6_mask =3D GEN6_RC_CTL_RC6_ENABLE |
> -			(IS_GEN7(dev_priv->dev)) ? GEN6_RC_CTL_RC6p_ENABLE : 0;
> +			((IS_GEN7(dev_priv->dev)) ? GEN6_RC_CTL_RC6p_ENABLE : 0);
> =20
>  	I915_WRITE(GEN6_RC_CONTROL,
>  		   rc6_mask |

ugg yeah, with the old code we'd never end up enabling rc6 at all.
Pushed.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/9Zor=VgLof+1OP==SV1wtlG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPR8n7AAoJEIEoDkX4Qk9hdfAP/1XLmklSdz1BUdZU6GX88zE/
JBfpKnf2nnYHPn79NQ22PZcFQturqC7V5dunCiOPHs3eF5FmKMfpdShJyitbHni8
1XKJ3A2qnf7i6tkSy1b6bpVChIvP9sGNwYTRzsC6P+u9HF10a00KC7RhYpK4B5wv
k9oPxuk5UX8Cf29GXKN0pLWBSbqiHSh9KarOZbX/Ax+J1aYTSRfdvlCzmW5vfITE
VOjQFXQoXJay91rnmAxlGSsW0RISso6Qa/YGjlFQAihVzwMmwaJP5o3r55LPzWU6
++c8Ac7lOgoIlkRwCdjvXxIFfqRndEQ8SW0GFqYVNDBQHJK/DOcL5Lx4T3E0YaZd
U1jbslVMF73mD8PqvvshdgWxn3NeiY2mqZfm+yieep6x+KSGxImamtfJJtgdnevY
STjVHu5jGqaKRrswD4mqUhKaxd7RINrNR3PdaYzPVPFowywSZ5wpvmvXtkZkkcfW
BmUOqyzxTW4BN2DWILxlJvmEq5o4R/dmlxKdRdEsaQ9zCWjrrr5AfGX6tX90u6YI
JabG1ad0alochxhaSwJESOsOeDcNUA50I0NaYbzFcDkPeUiZNw81vMO5bLTkGMUB
+Q1Dvj79QBJKMttVhSzGYkZFXk/AvO2HWMMKVtbZnhwpgl/SqfKEQ2Z+4P8miC0W
DNxeEKfE/guk/qOFBEUB
=/C2N
-----END PGP SIGNATURE-----

--Sig_/9Zor=VgLof+1OP==SV1wtlG--
