Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1L1Cxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 21:53:32 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:52913 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab1L1Cx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 21:53:29 -0500
Date: Wed, 28 Dec 2011 13:53:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20111228135319.7d08ed1842abe09943cd2c67@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_13_53_19_+1100_vWe7NRLPjQJKr9T_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_13_53_19_+1100_vWe7NRLPjQJKr9T_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/vmwgfx/vmwgfx_kms.c between commit 8a78389651b3 ("vmwgfx:
fix incorrect VRAM size check in vmw_kms_fb_create()") from Linus' tree
and commit 308e5bcbdb10 ("drm: add an fb creation ioctl that takes a
pixel format v5") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index f94b33a,c4bdef3..0000000
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@@ -1093,17 -1093,25 +1093,25 @@@ static struct drm_framebuffer *vmw_kms_
  	struct vmw_surface *surface =3D NULL;
  	struct vmw_dma_buffer *bo =3D NULL;
  	struct ttm_base_object *user_obj;
+ 	struct drm_mode_fb_cmd mode_cmd;
 -	u64 required_size;
  	int ret;
 =20
+ 	mode_cmd.width =3D mode_cmd2->width;
+ 	mode_cmd.height =3D mode_cmd2->height;
+ 	mode_cmd.pitch =3D mode_cmd2->pitches[0];
+ 	mode_cmd.handle =3D mode_cmd2->handles[0];
+ 	drm_fb_get_bpp_depth(mode_cmd2->pixel_format, &mode_cmd.depth,
+ 				    &mode_cmd.bpp);
+=20
  	/**
  	 * This code should be conditioned on Screen Objects not being used.
  	 * If screen objects are used, we can allocate a GMR to hold the
  	 * requested framebuffer.
  	 */
 =20
 -	required_size =3D mode_cmd.pitch * mode_cmd.height;
 -	if (unlikely(required_size > (u64) dev_priv->vram_size)) {
 +	if (!vmw_kms_validate_mode_vram(dev_priv,
- 					mode_cmd->pitch,
- 					mode_cmd->height)) {
++					mode_cmd.pitch,
++					mode_cmd.height)) {
  		DRM_ERROR("VRAM size is too small for requested mode.\n");
  		return ERR_PTR(-ENOMEM);
  	}

--Signature=_Wed__28_Dec_2011_13_53_19_+1100_vWe7NRLPjQJKr9T_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+oSfAAoJEECxmPOUX5FENHgQAJ9wwYm9k5F0eFSLWd9rXU0m
0Z1D6h1yVV5nCeHSkAdO3rgjhQFfVBTftorfWi33J7+3xznPtp634Yy1CrAKVKP3
7bRH+fh0Ev141br4bhPzK+kzP7ESLnTWR86fRu8dPKsrmpubILIhzNYxm1hoJ591
2WSmzYhjmK1w7UiVfI+brlKag1l5RadAOCoyjpqwZ+CvHpQpXQ4jOooHxcUnUD/b
A7MZF5MSL2c+TvaXpvjL2oHq6aPmLt89NlEy27dqnCzg14+YM6U+tFJ1iGuR5VFk
TgBKo2RVH5ecaEja3ucGZPWw/gCBmyqy8tazca9TVE1Ovu2W88R/u6agxPmLWNns
TUQUgUjON1AeiyAGJXRLrwsG6HI56tWl42xaPwdkdwKd61JTKi8wX8vNveWA2Ic3
7Ws6jqJbz+jqUwz7rOvCNg7RK2uViKy19A9xDVCWJ+FuK6wXEToRZSrC44G6oSKZ
gqf7LHIC3C4luZlirKQC6CfLfhocPG3CIiFqwZCvz+os3mNEEAa8AioU58r6bpPV
8z7SfYAaU92sySxDSnSq/ck17mXnkAWYXL6h8C8ZCJrEt+pu8t2uYQecS4euEVoi
oLcNKNBcy6qhDu77XtrdtLcR/HlUT02Fp1HWDywNuiUN7ILvpexC3Yvl7jtIbqnD
D75hvQ+rg1WofwuNm9Do
=kE86
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_13_53_19_+1100_vWe7NRLPjQJKr9T_--
