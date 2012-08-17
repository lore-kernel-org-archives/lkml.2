Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2HQPLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:11:30 -0400
Received: from home.keithp.com ([63.227.221.253]:50909 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757532Ab2HQPLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:11:20 -0400
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2012 11:11:20 EDT
From: Keith Packard <keithp@keithp.com>
To: "Lespiau\, Damien" <damien.lespiau@intel.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 2/7] drm/i915: FDI B/C share 4 lanes on Ivybridge
In-Reply-To: <CAPX-8+8euppecLhZu3XR95uM5e9m_kYmbJ6vmgBU=d03cs=RWA@mail.gmail.com>
References: <1344918891-6283-1-git-send-email-keithp@keithp.com> <1344918891-6283-3-git-send-email-keithp@keithp.com> <CAPX-8+8euppecLhZu3XR95uM5e9m_kYmbJ6vmgBU=d03cs=RWA@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.4.1 (i486-pc-linux-gnu)
Date: Fri, 17 Aug 2012 08:00:58 -0700
Message-ID: <86lihdbm1h.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

"Lespiau, Damien" <damien.lespiau@intel.com> writes:

> On Tue, Aug 14, 2012 at 5:34 AM, Keith Packard <keithp@keithp.com> wrote:
>
> @@ -3728,7 +3728,8 @@ static inline bool intel_panel_use_ssc(struct
> drm_i915_private *dev_priv)
>   */
>  static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
>                                          unsigned int *pipe_bpp,
> -                                        struct drm_display_mode *mode)
> +                                        struct drm_display_mode *mode,
> +                                        int max_fdi_bpp)
>
> There's some kernel-doc for this function, maybe add a @max_fdi_bpp
> there?

Will do

> This chunk is being moved around in a later patch in the series,
> merging the two patches in one looks like a good idea?

Or at least move this into its final position in this patch.

> I guess this does not cover the case of pipe B using 3 lanes meaning
> pipe C can use 1?

It didn't look like that was a supported mode from the docs.

> This duplicates the code just that is just a few lines away, instead
> how about moving the logic to set target_clock up in front of this
> whole if()?

It's not the same, it's the inverse -- computing bpp from lanes+clock
clock instead of computing lanes from bpp+clock. But, yeah, it would be
nice to have these merged somehow. I couldn't figure out a good way though.

> This chunk is also reworked in a later commit in this series.

I'll see if I can't avoid that as it's confusing. Thanks for your review!

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUC5cqjYtFsjWk68qAQgVxw//aRrK0o6w4/U4gXZsZ2EXaWtNohE9TCmv
8NJQSn6m5qsnvRKTC33tIFjdidlwI/PtUdgw6NFr1DvHT4oF6MoyKlBFaAItLf67
rGS/7Hr0o5prh7mJdQcz3sPD5FUeLFn0RUKEGMqVmOJ6GJ03IFT7wvofSAP0mauW
l+QbAHR+1+6ILt8oNBg+qNL24h6QAx5vxE2rWTY7yIcXDqM4c4/X0LdLV73mv1rG
lsmvSnddGSBwCGvzLfY01Cl2s8SNHtiEInSIL55RMeVOr7E+ipI+80sEXOrms/vI
Jcj7pgR9GXCnRlkFhgPPSSoHIs0yNAQxfZpSWZG2AbD6f4iojZ2hwy4u+1ivPUjS
YxCkb0uHqzQIOgeqzrkQAwq1kQBkQQK5FUtsRki3WVmFrm0DNj1Mwub/pvpLAITq
bUiE/h7evwGhDSMIvf60sSL1WKxVzpa3WzqIBvuakWyM78XT9kvpp08t+S6Fss2k
pTGIwc0+4w2TgP80ZSdBUtKyXiNE1JU35//dQWlrAXGU08IdOyC1ZY35fEKFDzNm
qS2z8r17IoNd4S0mgssoYD4lcAFoJzMfhqimnw+FKN8851qjOAkS6brgcWWWDxr5
zbFa1O+p/cbOUzY2HUo6y5wojvgYUIkAoLokuqPgC1u8o9HeBfoYfX52lf1xIDJ7
Ip2zA+eK2nE=
=hFTu
-----END PGP SIGNATURE-----
--=-=-=--
