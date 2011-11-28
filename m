Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1K1Cgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 21:36:53 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:35887 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab1K1Cgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 21:36:52 -0500
Date: Mon, 28 Nov 2011 13:36:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: linux-next: build warning after merge of the drm tree
Message-Id: <20111128133641.f847eab9b122d999786b382f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Nov_2011_13_36_42_+1100_7NJKFobTk9kt9N8B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Nov_2011_13_36_42_+1100_7NJKFobTk9kt9N8B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/gpu/drm/gma500/framebuffer.c: In function 'psb_framebuffer_init':
drivers/gpu/drm/gma500/framebuffer.c:264:2: warning: passing argument 2 of =
'drm_helper_mode_fill_fb_struct' from incompatible pointer type [enabled by=
 default]
include/drm/drm_crtc_helper.h:121:12: note: expected 'struct drm_mode_fb_cm=
d2 *' but argument is of type 'struct drm_mode_fb_cmd *'

Caused by commit 4d8d096e9ae8 ("gma500: introduce the framebuffer support
code") interacting with commit 308e5bcbdb10 ("drm: add an fb creation
ioctl that takes a pixel format v5").  The version in staging was fixed
up, but not this version (which should been done during commit
b63e0f9cb433 ("Merge branch 'drm-gma500-alanc' into drm-core-next")).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Nov_2011_13_36_42_+1100_7NJKFobTk9kt9N8B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO0vO6AAoJEECxmPOUX5FE6FsQAKa93RhQX4Lb8Bn82jSOLYTI
KMo61Y4HufKjmWMZ/R5+0laf8U6VVFO5wbBVPBLSJde7KKx3/KogQzrTNhUjOpYC
tuYsNm577HDPZzJq2sgEJVZpwV3D0RFVjALEgj1pjTghd6MgozrEOEfwago49lpo
gA4cwZorLSZcbXm42ehSDjJh1/qtkozpibYU2LBHuNSOwY6LFB0E6trCnjnG1OUD
hULY2fcG8hQGpcGvxwpdelccDwOQCvvOvjkGyTKXGDDugGf+qSBkBngcub1VMBsH
1EmRhCeial52de4wGVzAkJmVGqijsn9NVKTMkGIvbEzrVzvPWhsQLrfx40iELtKa
5sop4wzRNwTWcHAE6H7smIpsUiSpiyp7xbMOutWxsLxuHNj+w0pQF25vcAwofgSs
MLZfLxB2+QXhUgnBRW+XfOVCf6PEl7v2u2qnxdmWcN1++MYGGDT8u6FC0il8UxCJ
BDkPX/Sxf6hd2qTlCiXCCWKNfH7iSj0H74ZeUhm91o7OpzzKC805yoUSICIXfuJh
G8tjscEiuOTgJ7wBrjYu0AbpFZ9xXH7nMboDXiYjdxE3QDkEUmEMzOjD/T5C89vW
y9NLEtDZsbvpaeVUVkEXsqA9W2EGjMDHkYpuZTHYY50IBrV0OOc9YY8KARxyHwuq
kM263uEDgOivbuzWhcxz
=Lhtk
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Nov_2011_13_36_42_+1100_7NJKFobTk9kt9N8B--
