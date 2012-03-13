Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2CMFLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:11:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33084 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab2CMFLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:11:36 -0400
Date: Tue, 13 Mar 2012 16:11:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, Dave Airlie <airlied@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: linux-next: manual merge of the tip tree with the drm tree
Message-Id: <20120313161124.1d91e04d7507ec249f364270@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_16_11_24_+1100_hfmzkXmOixJ//OaL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_16_11_24_+1100_hfmzkXmOixJ//OaL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/platform/mrst/mrst.c between commit 026abc333205 ("gma500:
initial medfield merge") from the drm tree and commit ecfdb0ac15ba
("x86/mrst: Add msic_thermal platform support") from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/platform/mrst/mrst.c
index b930cc4,721e652..0000000
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@@ -688,19 -670,11 +672,24 @@@ static void *msic_ocd_platform_data(voi
  	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_OCD);
  }
 =20
 +/* tc35876x DSI-LVDS bridge chip and panel platform data */
 +static void *tc35876x_platform_data(void *data)
 +{
 +       static struct tc35876x_platform_data pdata;
 +
 +       /* gpio pins set to -1 will not be used by the driver */
 +       pdata.gpio_bridge_reset =3D get_gpio_by_name("LCMB_RXEN");
 +       pdata.gpio_panel_bl_en =3D get_gpio_by_name("6S6P_BL_EN");
 +       pdata.gpio_panel_vadd =3D get_gpio_by_name("EN_VREG_LCD_V3P3");
 +
 +       return &pdata;
 +}
 +
+ static void *msic_thermal_platform_data(void *info)
+ {
+ 	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_THERMAL);
+ }
+=20
  static const struct devs_id __initconst device_ids[] =3D {
  	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data},
  	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data},

--Signature=_Tue__13_Mar_2012_16_11_24_+1100_hfmzkXmOixJ//OaL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXtb8AAoJEECxmPOUX5FE/cQQAI4fCM2dTuo9wuLJWU+rTabM
Pvs6CccamOXvYWcVj+tsFpcYOOF/hWJuLHEfqwtfHqHfyEVUUn7p0//x616YDBLo
yV2r5GWkRAcQRLVngwyD4nMtvb2ZUaPN6nMbPx+W0K5SfHZ76mtMaUlElrVZ4v7k
CWLajiQ2t6rgMs98EJxRCAmXNWVIcxK1EVRHsL//ITpKjTf3Vb2u/Ly9xpzqTfqi
hVwwSoyR8/xVtZS6FQXPAAzo+SEFP8c20BCaL9bsx2W1HvTcDQ9o6iBCsMcMK9C8
rSKpnyhFD3L9SWoInrZagvNmOJ0gkjxY/0Nywumc8EW+OLDXXpEkwQLeZglImSmi
ovjDAxcmMAVmD6rntXRWbk4bqeGp8qyYS+3Nr9foWAvXbIy33+L5mmUdaO6r8PKH
baQuWXF8mfXSIQ76qP30YoPu75PryLzwhpnSuMiqw4Dow2mEHUVkweRwkAZq3YYJ
HtnuM6Z6mXI2+Wm3IjFCbENwhw+d+POvw6+Reu84SQZvE0C7nbBQFBydMSJxWFk6
ZJ8HF9gBLEIfBU9bBfp6XElg2L7cOmWtFtQJzh3DBp9PfpvGpNJExxeK2FSknxCg
qeNy9jrjcRB+NSBoTcaH9TfYiMMHHVJFdwyIMdZH61+2IUxYRsXCXEK4IRoEaN07
/5N7voo2LVAqyOfnnaqH
=zjWD
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_16_11_24_+1100_hfmzkXmOixJ//OaL--
