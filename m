Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1KCWlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:41:32 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:35228 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752954Ab1KCWlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:41:31 -0400
Date: Thu, 3 Nov 2011 15:41:25 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 5/7] drm/i915: Make DP prepare/commit
 consistent with DP dpms
Message-ID: <20111103154125.1fdaff5c@jbarnes-desktop>
In-Reply-To: <yunipn0rg7y.fsf@aiko.keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
	<1320214830-12696-6-git-send-email-keithp@keithp.com>
	<20111103130011.7946090a@jbarnes-desktop>
	<yunipn0rg7y.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TTwxyYHj.52/ahrGaEtupnd"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TTwxyYHj.52/ahrGaEtupnd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 03 Nov 2011 15:30:57 -0700
Keith Packard <keithp@keithp.com> wrote:

> On Thu, 3 Nov 2011 13:00:11 -0700, Jesse Barnes <jbarnes@virtuousgeek.org=
> wrote:
>=20
> > A few comments on this one (also, is it strictly required to fix your
> > bug)?
>=20
> I think so; the panel definitely was not happy when I turned the link
> off while the panel power was on. Having the mode setting and DPMS paths
> doing things in different orders definitely doesn't seem reasonable
> though. I nearly managed to share code between the two paths, but there
> are subtle differences in requirements and so I didn't bother.
>=20
> > Ok so you're making sure the panel has power to down the link, I think
> > that's fine.
>=20
> No, I'm turning the panel off *before* turning off the link.  The panel
> goes nuts if you down the link before turning its power off; lots of
> technicolor.

Except for VDD??  That does come on... and shouldn't be any different
than a full power sequence as far as link training etc go...

> Downing the link doesn't require any communication with the panel, so
> there's no issue with losing connectivity at this point:
>=20
> 	ironlake_edp_backlight_off(intel_dp);
> 	ironlake_edp_panel_off(intel_dp);               <=3D panel off
>=20
> 	/* Wake up the sink first */
> 	ironlake_edp_panel_vdd_on(intel_dp);
> 	intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_ON);
> 	intel_dp_link_down(intel_dp);                   <=3D link down
> 	ironlake_edp_panel_vdd_off(intel_dp, false);
>=20
> > But here it looks like you're shutting it off, then downing the link?
> > Should this be reordered?
>=20
> Nope, it's in the same order:
>=20
> 	ironlake_edp_backlight_off(intel_dp);
> 	ironlake_edp_panel_off(intel_dp);               <=3D panel off
>=20
> 	ironlake_edp_panel_vdd_on(intel_dp);
> 	intel_dp_sink_dpms(intel_dp, mode);
> 	intel_dp_link_down(intel_dp);                   <=3D link down
> 	ironlake_edp_panel_vdd_off(intel_dp, false);
>=20
> The only difference in these two code paths is that dp_prepare turns the
> sink to DPMS_ON, while dp_dpms turns the sink to DPMS_OFF.

Oh missed the vdd on, which is in this path too...  So I'm still
confused by the panel off, vdd on sequence, but at least they're
consistent.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/TTwxyYHj.52/ahrGaEtupnd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsxiVAAoJEIEoDkX4Qk9h3V0P/3RKsY6aNwPWCOyNmxlzB5pR
N9tgdMSCPslq6Acnt3sAaRnVdZDuTQcN4yGnTFNL60xgyad2j5Cv5CB3KRvMfVEs
KITgELtQaOjulp7EEWJWf0Z0VS1mH3X8qtYMERn54UHV49JOrgQNpot82RYjQBlw
wWuOw263xGu+JY3OuVW+4NvUxWSQN5iUlDQqzBBJoLWc2CheKfuIjtm1uBL3oZdg
VsVzkrvPAvt80CSQYs4ZIzkWlh+iZ4SYFL60aEfmMTfjsbwOjmjdmUDfkFRVwkE1
TV+dT17A4T8H+lWKNS4JAETfM+FmMoSajM/HXrdpSbrW7A+Iy9DbvZNiap7BkA7C
HcYNJs02PO0h2V2Fj8yYNpTrkswHEg0QL5Y+UyoUzAH02gB8Mb2icWU5yDzJ75wb
GljYk3kSRcFYuGHNAzk06FdeFoqnHoy2mLLhNuzwsqfhJARp2Ci7eI5UeuDush1z
emWMnSWZMxeYiPxuzvXrCOWnlaKhqyW/nUwbYns6PjTZNXZgqHEZ9zzdNSvTTON3
yeL4w1iBRQWB/7Oa0tfKY1/+I01G3pt1EbwyIhfU9LvO843py58L9EI0rZ0w5gK5
T847yyx7QqpTB74lpaWODlbqM+pbgFFOn+O/UjP7ds1IhbG1VfVBGS3ilbURrtcO
nOhdaABqSg1HKMrJ82we
=qdxc
-----END PGP SIGNATURE-----

--Sig_/TTwxyYHj.52/ahrGaEtupnd--
