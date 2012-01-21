Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab2AUWba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 17:31:30 -0500
Received: from home.keithp.com ([63.227.221.253]:53670 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab2AUWb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 17:31:29 -0500
From: Keith Packard <keithp@keithp.com>
To: Chris Diamand <chris.diamand@gmail.com>
Cc: linux-kernel@vger.kernel.org, tiwai@suse.de, melchior.franz@gmail.com
Subject: Re: i915/kms/backlight-combo mode problem
In-Reply-To: <4F1B2D64.7020705@gmail.com>
References: <4F1AF145.2090407@gmail.com> <86k44kkity.fsf@sumi.keithp.com> <4F1B2D64.7020705@gmail.com>
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 21 Jan 2012 14:31:24 -0800
Message-ID: <86bopwk7r7.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jan 2012 21:25:56 +0000, Chris Diamand <chris.diamand@gmail.com>=
 wrote:

> 0x00 is the brightest. It gets very gradually dimmer up to about 0xB0,=20
> when the gaps between
> brightness levels are slightly bigger.
> 0xFE is very low but still works.
> Barely any difference between 0x80 and 0x7f, same with 0x00 and 0x01,
> etc.

Here's a patch which just flips the interpretation of that value over;
does this work?

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/inte=
l_panel.c
index 04d79fd..43faa9d 100644
=2D-- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -207,6 +207,7 @@ u32 intel_panel_get_backlight(struct drm_device *dev)
                        u8 lbpc;
=20
                        pci_read_config_byte(dev->pdev, PCI_LBPC, &lbpc);
+                       lbpc =3D 0xff - lbpc;
                        val *=3D lbpc;
                }
        }
@@ -238,7 +239,7 @@ static void intel_panel_actually_set_backlight(struct d=
rm_device *dev, u32 level
=20
                lbpc =3D level * 0xfe / max + 1;
                level /=3D lbpc;
=2D               pci_write_config_byte(dev->pdev, PCI_LBPC, lbpc);
+               pci_write_config_byte(dev->pdev, PCI_LBPC, 0xff - lbpc);
        }
=20
        tmp =3D I915_READ(BLC_PWM_CTL);


=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTxs8vDYtFsjWk68qAQiepw//TnBIPVitHA2vYjNfDa3W8m7S5YmT5tPF
8CXAawOOUyT+fU+pxRJ18FeZF0JmYGKj+NiDV3A8GLD1yBKbjUXft8jI0DMXwW2F
YmC5KPpRkJsSAaQHLZahGl//BmT1vLlY58yeOf624G7qLN9cH9XgqXOYDIXwrcgw
Xa+4cVYbhS3E1iyQ0YYB0u61yUYYacqLBI7z/8y5evSz2hxx9H4PHAsgWVFYby/I
KfSjjV0kDt2Tu+lXKrbDm52jXu4xxG46oLCmZDvEzZAh1r+7LijXk1vOUbuf8Imy
oydFjV5erE+4QR4YoYrqnJP/tT44poED5dX873vzQy/bv1idKVB2JK+m0qNwczVy
viipDaQQ1lugaDT1vOrWy7iH8a0biuyDxVBY41qWLz2ypw1UFx8MdOs0/JwfbQUS
ykutilhESPV2W21Pw5vBzebImWF5L7LrI7a0a8bn4U83qo7UOJFvL/0ezESRT85K
aqr6bG4KjZkHqg360EPXo4+zRKC35dYG10DkRGttoW9DIW97XNtfqe8fmvVGFXS9
cK8UVYwYTRNi1fHLaMB4Q0kHSspcCRsFP0EMEOOQpS3RVqgwTw+E8VR3Z2G4B0gf
ypjLpFkdW1aBGOeRn25VDEambS8oMMMr8AiWS1kmre8yIT/N0gVIyQXw6vMAqiI4
u7Ei31cTaRI=
=2Eh8
-----END PGP SIGNATURE-----
--=-=-=--
