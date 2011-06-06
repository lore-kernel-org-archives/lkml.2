Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1FFXmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:42:04 -0400
Received: from home.keithp.com ([63.227.221.253]:60299 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab1FFXmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:42:02 -0400
From: Keith Packard <keithp@keithp.com>
To: Ben Greear <greearb@candelatech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        barnes@virtuousgeek.org
Subject: Re: 3.0.0-rc2 fails to boot on Atom appliance (bisected, drm/i915)
In-Reply-To: <4DED6221.1060806@candelatech.com>
References: <4DED33DF.8000201@candelatech.com> <4DED6221.1060806@candelatech.com>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 06 Jun 2011 16:41:58 -0700
Message-ID: <yunzkluzfw9.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 06 Jun 2011 16:26:25 -0700, Ben Greear <greearb@candelatech.com> wr=
ote:
> On 06/06/2011 01:09 PM, Ben Greear wrote:
> > Anyone seen something like this?  For what it's worth, it seems
> > that -rc1 had the same problem. I'll start bisecting soon if
> > the problem isn't already resolved somehow...
>=20
> I bisected this problem down to this commit:

This should be fixed by this patch:

=2D------------------- drivers/gpu/drm/i915/intel_display.c ---------------=
------
index f553ddf..bb1b59b 100644
@@ -7675,6 +7675,7 @@ static void intel_init_display(struct drm_device *dev)
 			dev_priv->display.update_wm =3D NULL;
 		} else
 			dev_priv->display.update_wm =3D pineview_update_wm;
+		dev_priv->display.init_clock_gating =3D gen3_init_clock_gating;
 	} else if (IS_G4X(dev)) {
 		dev_priv->display.update_wm =3D g4x_update_wm;
 		dev_priv->display.init_clock_gating =3D g4x_init_clock_gating;

This hasn't been merged yet, but should be soon.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN7WXGQp8BWwlsTdMRAmF2AJ9PkP9MmFOunwoQzcq6XREpsfiDoACfdQTE
NGy4jHrHdLfbQROh/OguFa0=
=rIh8
-----END PGP SIGNATURE-----
--=-=-=--
