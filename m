Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab2IXDSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 23:18:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45963 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab2IXDSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 23:18:44 -0400
Date: Mon, 24 Sep 2012 13:18:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Wang Xingchao <xingchao.wang@intel.com>
Subject: linux-next: build failure after merge of the drm tree
Message-Id: <20120924131834.348fa5e6ecfa48521391ea62@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_13_18_34_+1000_B0fr62ZiKN4rBZFH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_13_18_34_+1000_B0fr62ZiKN4rBZFH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/gpu/drm/i915/intel_hdmi.c: In function 'intel_enable_hdmi':
drivers/gpu/drm/i915/intel_hdmi.c:633:31: error: 'mode' undeclared (first u=
se in this function)

Caused by commit b98b60167279 ("drm/i915: HDMI - Clear Audio Enable bit
for Hot Plug") from Linus' tree interacting with commit 5ab432ef4997
("drm/i915/hdmi: convert to encoder->disable/enable") from the drm tree.

I added the following merge fix patch (which may be wrong, of course):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 24 Sep 2012 13:14:40 +1000
Subject: [PATCH] drm/i915: HDMI: update for API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpu/drm/i915/intel_hdmi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel=
_hdmi.c
index 2ec9c76..d39ed58 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -630,7 +630,7 @@ static void intel_enable_hdmi(struct intel_encoder *enc=
oder)
 	u32 temp;
 	u32 enable_bits =3D SDVO_ENABLE;
=20
-	if (intel_hdmi->has_audio || mode !=3D DRM_MODE_DPMS_ON)
+	if (intel_hdmi->has_audio)
 		enable_bits |=3D SDVO_AUDIO_ENABLE;
=20
 	temp =3D I915_READ(intel_hdmi->sdvox_reg);
@@ -676,8 +676,7 @@ static void intel_disable_hdmi(struct intel_encoder *en=
coder)
 	u32 temp;
 	u32 enable_bits =3D SDVO_ENABLE;
=20
-	if (intel_hdmi->has_audio)
-		enable_bits |=3D SDVO_AUDIO_ENABLE;
+	enable_bits |=3D SDVO_AUDIO_ENABLE;
=20
 	temp =3D I915_READ(intel_hdmi->sdvox_reg);
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Sep_2012_13_18_34_+1000_B0fr62ZiKN4rBZFH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQX9EKAAoJEECxmPOUX5FEFrUP/1UOqKYRmXP4/ln/iatSj+be
UW7bKd3TsMHFv06vmOZUxeQm7nhkQxvnrif5w8xX/b7eI6nhsL+HmydK3Kmpvk2M
zXHkzXtOP5vXIJ6l4CVjGaB8WhxSXLTVJx5GbQHaCJ7WIGfg8aHqbpJztz2G/9as
xSm5rfACtWsQFAI0VQu3kQRze1cf/uj2Z6/JR+4CBbsCy8qO1325O8zaTvsOIFg/
GHBP5n78Y5OCgKQtqHtBN/kHaagHpDhjpKYncOvC3L5J3kOFdkn0faeMTxPOdkkH
eJcNGADqJWKPuBS6jAk5qDq8m5HcJFL5Zi6AdE+Hu4u7KEW3riYJ+m3pGEjkKhsw
Y1LKslNZsKyaEbF3+7eeMF38jb2OfYyiPHJA1p/M/DuHB/MNNkfwOy1tHrwRR180
ycs7qKtkqgofT3A1hDUax2L0VQvdUX6iqpUJ6TG41uIniQCkntHPzc47N2CxaeH1
MNRU1xTF55ZVWdXlnZJp4T/677a6idtXoQ0P5VU1fQE6cnw0GPlPkyWEvLz4YQAS
qIjWEa2a2PI/pKuTXL7qpMjO/8XciwNqQ4mf7UVHlURMwK9FMZLzMrTyCSXvWc5s
IropfbJnr1XwqDpevQ7P3Nfh6z92tOaNaY7ZXks+iyrw8XW73I6+jgkkMNp/Uu5i
TR5S7Yzb0Fm+H/HYz819
=ikzt
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_13_18_34_+1000_B0fr62ZiKN4rBZFH--
