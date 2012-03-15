Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab2COHYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 03:24:49 -0400
Received: from mail.gw90.de ([188.40.100.199]:57892 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab2COHYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 03:24:47 -0400
Message-ID: <1331796281.3718.10.camel@mattotaupa>
Subject: Re: [V2 PATCH 2/2] drivers-gpu-drm-i915-invert-backlight-brightness
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Carsten Emde <C.Emde@osadl.org>
Cc: David Airlie <airlied@linux.ie>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 15 Mar 2012 08:24:41 +0100
In-Reply-To: <20120314234830.227490545@osadl.org>
References: <20120314233544.629616190@osadl.org>
	 <20120314234830.227490545@osadl.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-hUM2jMyJqjavO5f8CEn7"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hUM2jMyJqjavO5f8CEn7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Donnerstag, den 15.03.2012, 00:35 +0100 schrieb Carsten Emde:
> Einfaches Textdokument-Anlage
> (drivers-gpu-drm-i915-invert-backlight-brightness.patch)

quilt also does not adapt the subject line of the message correctly to
the one of the patch.

> Following the documentation of the Legacy Backlight Brightness (LBB)
> Register in the configuration space of some Intel PCI graphics adapters,
> setting the LBB register with the value 0x0 causes the backlight to be
> turned off, and 0xFF causes the backlight to be set to 100% intensity
> (http://download.intel.com/embedded/processors/Whitepaper/324567.pdf).
> At least one of our test systems, however, turns the backlight off at
> 0xFF and sets it to maximum intensity at 0. In consequence, the screen
> of this systems becomes dark at an early boot stage which makes it
> unusable. The same inversion applies to the BLC_PWM_CTL I915 register.
> This problem was introduced in kernel version 2.6.38 when the PCI device
> of this system was first supported by the i915 KMS module.
>=20
> This patch adds a module parameter to invert the backlight brightness
> value before writing and after reading which makes the affected notebook
> usable again.
>=20
> Signed-off-by: Carsten Emde <C.Emde@osadl.org>
>=20
> ---
>  Documentation/kernel-parameters.txt |    9 +++++++++
>  drivers/gpu/drm/i915/intel_panel.c  |   14 ++++++++++++++
>  2 files changed, 23 insertions(+)
>=20
> Index: linux-3.3-rc6/Documentation/kernel-parameters.txt
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-3.3-rc6.orig/Documentation/kernel-parameters.txt
> +++ linux-3.3-rc6/Documentation/kernel-parameters.txt
> @@ -966,6 +966,15 @@ bytes respectively. Such letter suffixes
> =20
>  	i810=3D		[HW,DRM]
> =20
> +	i915.invert_brightness
> +			[DRM] Invert the sense of the variable that is used to
> +			set the brightness of the panel backlight. Normally a
> +			value of 0 indicates backlight switched off, and the
> +			maximum value sets the backlight to maximum brightness.
> +			If this parameter is specified, a value of 0 sets the
> +			backlight to maximum brightness, and the maximum value
> +			switches the backlight off.
> +
>  	i8k.ignore_dmi	[HW] Continue probing hardware even if DMI data
>  			indicates that the driver is running on unsupported
>  			hardware.
> Index: linux-3.3-rc6/drivers/gpu/drm/i915/intel_panel.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-3.3-rc6.orig/drivers/gpu/drm/i915/intel_panel.c
> +++ linux-3.3-rc6/drivers/gpu/drm/i915/intel_panel.c
> @@ -28,6 +28,7 @@
>   *      Chris Wilson <chris@chris-wilson.co.uk>
>   */
> =20
> +#include <linux/moduleparam.h>
>  #include "intel_drv.h"
> =20
>  #define PCI_LBPC 0xf4 /* legacy/combination backlight modes */
> @@ -191,6 +192,10 @@ u32 intel_panel_get_max_backlight(struct
>  	return max;
>  }
> =20
> +static bool brightness_inverted;
> +MODULE_PARM_DESC(brightness_inverted, "Backlight brightness value is inv=
erted "
> +	"(0 =3D max brightness, max value =3D dark)");

Could you elaborate somewhere for example by giving an example what
`dark` means? As a normal user it is not clear to me.

> +module_param_named(brightness_inverted, brightness_inverted, bool, 0600)=
;
>  u32 intel_panel_get_backlight(struct drm_device *dev)
>  {
>  	struct drm_i915_private *dev_priv =3D dev->dev_private;
> @@ -212,6 +217,10 @@ u32 intel_panel_get_backlight(struct drm
>  	}
> =20
>  	DRM_DEBUG_DRIVER("get backlight PWM =3D %d\n", val);
> +	if (brightness_inverted) {
> +		u32 max =3D intel_panel_get_max_backlight(dev);
> +		val =3D max - val;
> +	}
>  	return val;
>  }
> =20
> @@ -229,6 +238,11 @@ static void intel_panel_actually_set_bac
> =20
>  	DRM_DEBUG_DRIVER("set backlight PWM =3D %d\n", level);
> =20
> +	if (brightness_inverted) {
> +		u32 max =3D intel_panel_get_max_backlight(dev);
> +		level =3D max - level;
> +	}
> +
>  	if (HAS_PCH_SPLIT(dev))
>  		return intel_pch_panel_set_backlight(dev, level);


Thanks,

Paul

--=-hUM2jMyJqjavO5f8CEn7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk9hmTkACgkQPX1aK2wOHVgzZgCeP5U80uH++9MJxcWzifBil/zU
q5wAoIBp60qq9b71mWyqnoO0nAyX03MA
=/+Jl
-----END PGP SIGNATURE-----

--=-hUM2jMyJqjavO5f8CEn7--

