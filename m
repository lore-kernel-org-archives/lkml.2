Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab1KBQzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:55:46 -0400
Received: from home.keithp.com ([63.227.221.253]:53817 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120Ab1KBQzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:55:45 -0400
From: Keith Packard <keithp@keithp.com>
To: Adam Jackson <ajax@redhat.com>, "Wang\, Zhenyu" <zhenyuw@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most places
In-Reply-To: <4EB161F1.5090003@redhat.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-4-git-send-email-keithp@keithp.com> <4EB161F1.5090003@redhat.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 02 Nov 2011 09:55:41 -0700
Message-ID: <yunr51qwjjm.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 02 Nov 2011 11:29:53 -0400, Adam Jackson <ajax@redhat.com> wrote:

> Redundant.  You've already done the link_configuration |=3D above in the=
=20
> common code.  You can drop the second if chunk altogether.

Thanks for catching this mistake; cut&paste programming without the cut par=
t...

> In related news, the corresponding section for this in TRANS_DP_CTL=20
> setup appears to turn on enhanced framing unconditionally.  This is=20
> probably not a big deal, I don't think I've ever seen a display not=20
> support it, but.

Yeah, it's actually a huge pain because TRANS_DP_CTL is set up in
ironlake_pch_enable, which is part of the crtc enable path not the
encoder mode set path, and getting to the appropriate intel_dp structure
takes a walk through all of the encoders to find the matching one.

I think we could move the TRANS_DP_CTL code into intel_dp.c where it
belongs; this chunk was stuck inside ironlake_crtc_dpms by Zhenyu last
year when DP/eDP support for Sandybridge and Cougarpoint was added in
commit e3421a189447c0b8cd0aff5c299f53b5ab7c38f6.

Most of the TRANS_DP_CTL chunk inside ironlake_pch_enable should just
get moved to intel_dp_mode_set, but I don't know if the
TRANS_DP_OUTPUT_ENABLE bit needs to be set before
intel_enable_transcoder is called; if it does, then we'd need to
preserve that piece inside ironlake_pch_enable, otherwise that bit would
move to intel_dp_commit.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrF2DTYtFsjWk68qAQj5aRAAnND64+AD5Z+Xnq1AsxBF1gHeU/ZGwK68
PmDDs36Wyue7uaXd/JYi08V/kqf9Yi3QtB/HQV+gNZ1j6vutrg1RYayXrtgFN3S6
R+2OrcoaYJjX340w724Xvv1bQIaYh9h9POQnRxWCq0sL+eMT9NGjscK3B9ZbHeP9
yCgpN8ghpmWQdwWP1OeetRZjlzktTUpCobgzEMZtd/t26yrOxpKtqpKjllN1twaY
kPQcOFG1RT/ZE71AFEvRJNM36sH0HEP50Wnor63tHhK7hwbP668Wljvhwo1MSIsU
BWta+y/beeVX81lp2pmP84kM3TwB7m5fIKFqrEPj/h4NPdZD1Bdf/FCA5xV0EPma
7aDalBgIzIehLw82kzvPRDyOzQQcTxIa49/6wuYHHMDY3yYD4dUxtUOGTtrSOD3p
lkb1iLEIW2aPjvp6qS984klFV1WHqiXV7QGBx2G+mCR4vIq64kmmrbdwllDQ9Byt
t15GN9kVtCK+qh4hAW+gduKlEcMNgLUaKTHuK2Ok1j1wjjUuRnSGoG0kvQS2hcXQ
mT4t6WeVVKrbc66wol36lkS1VYoc+nJrb/lmnt+2rcdsk5trPz22gXNSbvLf5dnX
ZiNNn3ZS2cDYXQrBNVfNTBjI1seQOcAuAD+qn2S7rlGZUlZHLXuIMFmsq0YoiarU
ZRU9epoDYoY=
=wqKe
-----END PGP SIGNATURE-----
--=-=-=--
