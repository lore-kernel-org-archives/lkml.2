Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1KUQzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:55:51 -0500
Received: from home.keithp.com ([63.227.221.253]:59199 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab1KUQzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:55:50 -0500
From: Keith Packard <keithp@keithp.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang\, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "dri-devel\@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 v2] drm/i915: hot plug/unplug notification to HDMI audio driver
In-Reply-To: <20111121063749.GA23450@localhost>
References: <20111121063749.GA23450@localhost>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 21 Nov 2011 08:55:43 -0800
Message-ID: <86hb1xife8.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Nov 2011 14:37:49 +0800, Wu Fengguang <fengguang.wu@intel.com> w=
rote:
> On monitor hot plug/unplug, update ELD and set/clear SDVO_AUDIO_ENABLE
> or DP_AUDIO_OUTPUT_ENABLE accordingly.  So that the audio driver will
> receive hot plug events and take action to refresh its device state and
> ELD contents.
>=20
> A new callback ->hotplug() is added to struct drm_connector_funcs which
> will be called immediately after ->detect() knowing that the monitor is
> either plugged or unplugged.
>=20
> It's noticed that X may not call ->mode_set() at monitor hot plug, so it's
> necessary to call drm_edid_to_eld() earlier at ->detect() time rather than
> in intel_ddc_get_modes(), so that intel_write_eld() can see the new ELD
> in ->hotplug.

The X environment will eventually call mode_set when the user
environment decides to use the monitor. Any audio bits can, and should,
await the user's choice of a video mode before choosing the audio format
to use. We should not be adding eld information until the monitor is in
use.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsqCkDYtFsjWk68qAQij6A/+P9X96i9kvw2EzL+YuNzDZFsBUPOcX+2o
gMGwq4BscA+GQMlAh/zszwSMTLriRwMsQn9E+rpRDRVvefvr3ejqqV8x/bEgtUi4
6kM6Y+Bdm7DwjdgNGtUNmufu2QiKoIic/pjr7vNPvl1meJA8/VuTSGF5jzi6UrPs
DRoctHadne5A6/aCgUKwUbfOUewRYvi38DIYPb3/PEaozuSNVq2zH5Z85JtIrfmx
Vnt59+CPo8LhbzCg2TbQoMcLf/M0AsWqlbuN1Z6hiIUiQqwmCTf0JIR9UDIKGfuE
8VrhehW0r5IK9wvq435EorH7baDJC1c4LxeENl8WAVMWdDEm9orTQRrmoyYH/Onq
C0ddjgNFWOn3Z8HWOBAfCDNdLUAdCQ/rSuzzsWlDO97rijVxGt8FRmuyIo1asM4e
lq4pLgvdzAgkRySHq0gwzPj2/ZPwLOCPOQi9FdDFMdd55qnpOkE86B86GzKibl2x
huGLgrTVdz5FrS4iMrlpGtd6+QxZ1PPnlPerZXoRryIQOvJTgDq1szCC8qo635lR
R81m7d1Rgzt9M4k2/gFR3kJcMezQo8SUZ96t8KW3k2xOHcgeaNNIVAxxiUZe7Vd/
nf6M2nce5fnwSvns4bEhJ5VxD+Wofq3ge+sKF3xe7q4IcCycJbJrDBgwSBfzl+oE
AzNxTOQ+MbY=
=2U2Q
-----END PGP SIGNATURE-----
--=-=-=--
