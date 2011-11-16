Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab1KPAaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:30:22 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60309 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab1KPAaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:30:20 -0500
Date: Wed, 16 Nov 2011 11:30:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Rob Clark <rob.clark@linaro.org>
Subject: linux-next: build failure after merge of the drm tree
Message-Id: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_Nov_2011_11_30_07_+1100_ot3Ry=Letkw9J.Q+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Nov_2011_11_30_07_+1100_ot3Ry=Letkw9J.Q+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/staging/gma500/framebuffer.c: In function 'psb_user_framebuffer_cre=
ate':
drivers/staging/gma500/framebuffer.c:558:44: error: 'struct drm_mode_fb_cmd=
2' has no member named 'handle'

Caused by commit 308e5bcbdb10 ("drm: add an fb creation ioctl that takes
a pixel format v5").  Please build test *before* publishing code.  :-(

I have used the drm tree from next-20111115 for today.

I also get the following warnings in that file:

drivers/staging/gma500/framebuffer.c: In function 'psb_framebuffer_init':
drivers/staging/gma500/framebuffer.c:297:2: warning: passing argument 2 of =
'drm_helper_mode_fill_fb_struct' from incompatible pointer type [enabled by=
 default]
include/drm/drm_crtc_helper.h:121:12: note: expected 'struct drm_mode_fb_cm=
d2 *' but argument is of type 'struct drm_mode_fb_cmd *'
drivers/staging/gma500/framebuffer.c:564:2: warning: passing argument 2 of =
'psb_framebuffer_create' from incompatible pointer type [enabled by default]
drivers/staging/gma500/framebuffer.c:314:32: note: expected 'struct drm_mod=
e_fb_cmd *' but argument is of type 'struct drm_mode_fb_cmd2 *'

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Nov_2011_11_30_07_+1100_ot3Ry=Letkw9J.Q+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOwwQPAAoJEECxmPOUX5FEKXcP/RQ5heVejXzDR8ko5jQRrsl1
+m9JIJBbK/n2C3AATE1WQa/3TvMAcfVFMNH/ePlajK0l+tQoacewSrkoC5dqP9BE
80fCERaHPlPZnS8EQsWRbLfkHngKoKM6Pq6ndZO4zUIkIXL+p8CpLabRJkgbXFVS
HqMpZR/5IV3VPj+XLHR2Jhh8Gwx0g9UeVFesL9Ym04hBYCB2HsS42d4JVKaaqBC3
dQjgblVYe2gE4hArqWQTDDb3/UOGKlFawbU5BjAqh4mrEVP0SNo6N9kM2VoL4W0z
ZS30YjYGk+F0oEuh+HyQjb9MGK3J2To3jQOOshikzhhO0o2OV0HzUbwlBGDjSMLL
3FDG3qcJG3KGLAuxRf9Yql4Va4l7nF69x+xPE1OfDUM1TXCCrJ+/HtuKrymoaHJQ
YTvoEbsdGn2g5viEAEaaQSBn0gSDNrO+AMYMiL5dvzw39+UypZyGh4i2zUXhHS2R
6kxDhdVFAA8fWQ5yXxxnK2936Am7+B/SYyblUgc8frizaaAjFudOVDxGadZnjC7+
7lXSI2mNYupK5KI6KvEO0x7qiTwwT0c/4t1gB3UfayhJOuC92mg/P/FQo6bO7C2R
GaBgNdv0/sMApziy87u0pBhXM3iyxkwTG2CdvQmlgu8yYfk2NsSvcM8kWV19cN6l
juNYVXPVVptcpnzm4jMN
=Y9/9
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Nov_2011_11_30_07_+1100_ot3Ry=Letkw9J.Q+--
