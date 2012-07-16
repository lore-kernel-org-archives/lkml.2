Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2GPDAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 23:00:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44337 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2GPDAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 23:00:32 -0400
Date: Mon, 16 Jul 2012 13:00:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20120716130021.b533be019b0f0295f45aec06@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Jul_2012_13_00_21_+1000_8p_sBtuBHrJZpwYc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Jul_2012_13_00_21_+1000_8p_sBtuBHrJZpwYc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_display.c between commit 7aa1e7f06d6e ("Revert
"drm/i915: allow PCH PWM override on IVB"") from Linus' tree and commit
8090c6b9daa0 ("drm/i915: wrap up gt powersave enabling functions") from
the drm tree.

Just context changes (I think).  I fixed it up (see below) and can carry
the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_display.c
index a8538ac,0972f49..0000000
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@@ -6921,22 -7172,31 +7172,16 @@@ static void i915_disable_vga(struct drm
  	POSTING_READ(vga_reg);
  }
 =20
 -static void ivb_pch_pwm_override(struct drm_device *dev)
 -{
 -	struct drm_i915_private *dev_priv =3D dev->dev_private;
 -
 -	/*
 -	 * IVB has CPU eDP backlight regs too, set things up to let the
 -	 * PCH regs control the backlight
 -	 */
 -	I915_WRITE(BLC_PWM_CPU_CTL2, BLM_PWM_ENABLE);
 -	I915_WRITE(BLC_PWM_CPU_CTL, 0);
 -	I915_WRITE(BLC_PWM_PCH_CTL1, BLM_PCH_PWM_ENABLE | BLM_PCH_OVERRIDE_ENABL=
E);
 -}
 -
  void intel_modeset_init_hw(struct drm_device *dev)
  {
- 	struct drm_i915_private *dev_priv =3D dev->dev_private;
+ 	intel_prepare_ddi(dev);
 =20
  	intel_init_clock_gating(dev);
 =20
- 	if (IS_IRONLAKE_M(dev)) {
- 		ironlake_enable_drps(dev);
- 		ironlake_enable_rc6(dev);
- 		intel_init_emon(dev);
- 	}
+ 	mutex_lock(&dev->struct_mutex);
+ 	intel_enable_gt_powersave(dev);
+ 	mutex_unlock(&dev->struct_mutex);
 =20
- 	if ((IS_GEN6(dev) || IS_GEN7(dev)) && !IS_VALLEYVIEW(dev)) {
- 		gen6_enable_rps(dev_priv);
- 		gen6_update_ring_freq(dev_priv);
- 	}
 -	if (IS_IVYBRIDGE(dev))
 -		ivb_pch_pwm_override(dev);
  }
 =20
  void intel_modeset_init(struct drm_device *dev)

--Signature=_Mon__16_Jul_2012_13_00_21_+1000_8p_sBtuBHrJZpwYc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQA4PFAAoJEECxmPOUX5FE4GkP/iPU7MeXUpJJ9ldzGpBILkQ7
+699CdffHlgu92yhgEj3S+wNrp3o3pwwDUzd5Wz1V6G2U1MLKCDBDEc08JDMdhoW
AZ6nJ5ElkL9YKNvPsh/AszV5b2KsTz93kRxLRSTw2+lxU5CuR3TZrhJ6w7F9QLI/
5iHJRwThwDSXy1TatbwQgoe1F9gGnZodz9q+606h7M8TTRxELEptmN5YXf4XUICU
1FkcqgdKXd+avqdMXIFV34DyrePTn/brJK2ScEeSBs+oUWOuFBCibOu9pK9XXvvJ
dy+L70hqMoHB7IZt8x5iRCh4KkbxGl94GRpoJzKFqnjwbfv37ehDe994X8/DxjIm
Lc1AhiPg+ZOXRqr0ZrfjTOqDqWVz6AK9KNvRjrFNvk5y1nLoti5UoX/RTpFXV8Kg
zw+SBijuhjZV6YzqCptuvMWwVPBdbAH/zUhjPMypoCEdQVdcueRNKP2jNrmn1pkk
oYI0Fkori2cl6CH1fq9XsVGVBQ7gRVpkp36fu/Dv+mv0phU0G6qlqq4PVDFVu9KN
XCxGhgEN2GIsybPFWaS9tqZVMD0ezdXJpUG3IyRK92EBT3krJUU3FGmr4KM8vt3c
pSh+4mi6ys2XJAwZb/1U9QemRzDXor/yZltkk/wR8qPN+HSMozu+V47yhGr1dbEP
CdRe48XeVWaOA+hcYJIE
=7MuE
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Jul_2012_13_00_21_+1000_8p_sBtuBHrJZpwYc--
