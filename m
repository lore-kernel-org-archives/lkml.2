Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab1KCW7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:59:22 -0400
Received: from home.keithp.com ([63.227.221.253]:54476 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab1KCW7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:59:21 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 5/7] drm/i915: Make DP prepare/commit consistent with DP dpms
In-Reply-To: <20111103154125.1fdaff5c@jbarnes-desktop>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-6-git-send-email-keithp@keithp.com> <20111103130011.7946090a@jbarnes-desktop> <yunipn0rg7y.fsf@aiko.keithp.com> <20111103154125.1fdaff5c@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 03 Nov 2011 15:59:09 -0700
Message-ID: <yun62j0rewy.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Nov 2011 15:41:25 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> Except for VDD??  That does come on... and shouldn't be any different
> than a full power sequence as far as link training etc go...

Oh, that's a good point. Doing things in this order essentially forces
yet another full panel power sequence delay at this point. Hrm. I'll
have to test again when I get a chance, but perhaps we can turn the sink
DPMS on before we turn the panel power off.

> Oh missed the vdd on, which is in this path too...  So I'm still
> confused by the panel off, vdd on sequence, but at least they're
> consistent.

Right, I'll try doing the sink_dpms before turning the panel off; that
should work just fine, and should make the sequence a bit faster.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrMcvTYtFsjWk68qAQgeTg//XV2CYNnT8QLFi/uuHTCiAPcHuLb2alXx
AAwoObA+frVRgdQvX6HPCMxRiVhfMnL+prhiwo9aQiEdjR65yt0aZg9qfSGbtOaj
7B/e4TGlVXbiyosQlxxZ8UiWlDuFUv5uKvnqiRZTA0ZSanK8XalHiaLz7ydO/e9T
5CdxsEakaS9jvp19+rjB+Uc2hadITkGV5WWPx5M8BoauDyL7zgxx9MrjB6+Y+j/o
M5uwNaI2w6FAmvRs8GHXrEhNHNADqN+Hq4JCbXwdvMABgdTO/JhDY+poJUUYV4ai
oWI8X/GHzyqOO//B2tGbj2j1QXDMkWr0mlP3wTf+DVFnlNfR4SceaYPQSHtnyNfu
QZQY5T3FCUudqQjIAvFMqlQIxCvYa6PrZ4hCLma244IL6yiM7XiCqtQaG6hQQsT8
c3YUOMIzCg5krU0B29QwoUzAkFfcbEjeOjirFN8cMu9NgEMC/rYR7vF8oDzkHZyj
7/m1Ev03YL7Kfvfu4U/u6gsd8Ch9qq8UhshLI1jA4lEeBeYV0sNb5AxHEge2H/nf
xwa3UjZEVFBWTnAp96LUxz7PJ5SozRgCtKTJlFDXRICz0PdvQJJVypU2/Lp5KhHV
1tU5tqzjYEeMbVTAnZ+d6ViUYTtH65SGlA3WuVvm9CEhXnN2xMYIMHU2j9tRG7Pd
/c1Z+ldfixg=
=sXZQ
-----END PGP SIGNATURE-----
--=-=-=--
