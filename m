Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1KBHbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 03:31:48 -0400
Received: from home.keithp.com ([63.227.221.253]:44765 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1KBHbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 03:31:44 -0400
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4/7] drm/i915: Let panel power sequencing hardware do its job
In-Reply-To: <1320214830-12696-5-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-5-git-send-email-keithp@keithp.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 02 Nov 2011 00:31:40 -0700
Message-ID: <yunwrbjvv37.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue,  1 Nov 2011 23:20:27 -0700, Keith Packard <keithp@keithp.com> wrote:

> -static void ironlake_wait_panel_off(struct intel_dp *intel_dp)
> +#define IDLE_ON_MASK		(PP_ON | PP_READY | PP_SEQUENCE_MASK | 0          =
           | PP_SEQUENCE_STATE_MASK)
> +#define IDLE_ON_VALUE   	(PP_ON | PP_READY | PP_SEQUENCE_NONE | 0       =
              | PP_SEQUENCE_STATE_ON_IDLE)

A bit more testing -- looks like the MacBook Air doesn't mange to get
PP_READY set when it's time to turn the panel on. I should look at this
a bit more closely; there's no reason it shouldn't be set. But, nothing
bad seems to happen if we simply ignore the PP_READY bit

+#define IDLE_ON_MASK		(PP_ON | 0      | PP_SEQUENCE_MASK | 0              =
       | PP_SEQUENCE_STATE_MASK)
+#define IDLE_ON_VALUE   	(PP_ON | 0      | PP_SEQUENCE_NONE | 0           =
          | PP_SEQUENCE_STATE_ON_IDLE)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrDx3DYtFsjWk68qAQhMcQ//U0tyuQcGO2li2Wqd8pXJsRfaWGHG4s/o
PQi6s6+S6FBA47Go3BrhAiGNoIkjM7tdOGbJ430vGM0iVSkRxdFeXKdNl2TTmofr
3WM43h4pO63Tw6b93Rz7juuhX8BWQMk6ApJ3gzS6C7aELxNpjwR+V6ZC2cIrA6/q
f5PHxNz5FK+6HBO3L7lls9KlK0To0KyUfBwbAoOCayLOZ9mQF8UCT+OyF/e+AiGE
mRVIMY/6CdSBAB9cdkLc2dO9qogULDjShP4aJIL6MpSYBzC0GueRABvw4ePPURtv
FJB3MILqDdmt9obKgQolLxrMz8th0vOmkcJL2nYFP6YYAHCIwQl/SDvPjFWSYj1Y
pxOCTzyfBGHAhXs2dwUVs4AdbaYMjQ3f+dBQf1c9OB/VCHsh86N7dsPm6wNEtYBp
uczH7mbvRaYwpAEdKezUrwLZ7U/STx2W69W61atIUz6Cusx0WnwtYwHqPC23mtSj
iJ4A8wdcZt5aSKkIWGnb+Nj9c6mFb2xOl3E0JMfwQhfbArkiYeEe7j+rZgVWaxIv
nUg6UtzHYRmSrs4BF+27f5klDZCZjtrd5uV33H5pMfG+SaD5e5sj7P/xWOjSu75e
EG5EPD3mBWd20kFzwJVRiiDuiNruaV4pueO/b36sI3cJGoTdjXToFQP7XNF+oeNq
gZqCHoTfT48=
=fvwJ
-----END PGP SIGNATURE-----
--=-=-=--
