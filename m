Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab2COHOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 03:14:22 -0400
Received: from mail.gw90.de ([188.40.100.199]:57876 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294Ab2COHOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 03:14:20 -0400
Message-ID: <1331795634.3718.5.camel@mattotaupa>
Subject: Re: [V2 PATCH 1/2] drivers-gpu-drm-allow-to-load-edid-firmware.patch
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Carsten Emde <C.Emde@osadl.org>
Cc: David Airlie <airlied@linux.ie>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 15 Mar 2012 08:13:54 +0100
In-Reply-To: <20120314234829.759638810@osadl.org>
References: <20120314233544.629616190@osadl.org>
	 <20120314234829.759638810@osadl.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-t04FJXdUHutUxAOSeyIU"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-t04FJXdUHutUxAOSeyIU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Carsten,


Am Donnerstag, den 15.03.2012, 00:35 +0100 schrieb Carsten Emde:
> Einfaches Textdokument-Anlage
> (drivers-gpu-drm-allow-to-load-edid-firmware.patch)

somehow your message was send as an attachment. Could you configure your
mailer (quilt) that it is send inline?

> Broken monitors and/or broken graphic boards may send erroneous or no
> EDID data. This also applies to broken KVM devices that are unable to
> correctly forward the EDID data of the connected monitor but invent
> their own fantasy data.
>=20
> This patch allows to specify an EDID data set to be used instead of
> probing the monitor for it. It contains built-in data sets of frequently
> used screen resolutions. In addition, a particular EDID data set may be
> provided in the /lib/firmware directory and loaded via the firmware
> interface. The name is passed to the kernel as module parameter of the
> drm_kms_helper module either when loaded
>   options drm_kms_helper edid_firmware=3Dedid/1280x1024.bin
> or as kernel commandline parameter
>   drm_kms_helper.edid_firmware=3Dedid/1280x1024.bin =20
>=20
> The built-in data sets are
> Resolution    Name
> --------------------------------
> 1024x768      edid/1024x768.bin
> 1280x1024     edid/1280x1024.bin
> 1680x1050     edid/1680x1050.bin
> 1920x1080     edid/1920x1080.bin
>=20
> They are ignored, if a file with the same name is available in the
> /lib/firmware directory.
>=20
> The built-in EDID data sets are based on standard timings that may not
> apply to a particular monitor and even crash it. Ideally, EDID data of
> the connected monitor should be used. They may be obtained through the=
=20
> drm/cardX/cardX-<connector>/edid entry in the /sys/devices PCI directory
> of a correctly working graphics adapter.
>=20
> It is also possible to specify the name of an EDID data set on-the-fly
> via the /sys/module interface, e.g.
> echo edid/myedid.bin >/sys/module/drm_kms_helper/parameters/edid_firmware
> The new screen mode is considered when the related kernel function is
> called for the first time after the change. Such calls are made when the
> X server is started or when the display settings dialog is opened in an
> already running X server.
>=20
> Signed-off-by: Carsten Emde <C.Emde@osadl.org>
>=20
> ---
>  Documentation/EDID/1024x768.S       |   44 ++++++
>  Documentation/EDID/1280x1024.S      |   44 ++++++
>  Documentation/EDID/1680x1050.S      |   44 ++++++
>  Documentation/EDID/1920x1080.S      |   44 ++++++
>  Documentation/EDID/HOWTO.txt        |   39 +++++
>  Documentation/EDID/Makefile         |   25 +++
>  Documentation/EDID/edid.S           |  261 +++++++++++++++++++++++++++++=
+++++++
>  Documentation/EDID/hex              |    1=20
>  Documentation/kernel-parameters.txt |   10 +
>  drivers/gpu/drm/Kconfig             |   11 +
>  drivers/gpu/drm/Makefile            |    3=20
>  drivers/gpu/drm/drm_crtc_helper.c   |    8 -
>  drivers/gpu/drm/drm_edid.c          |    4=20
>  drivers/gpu/drm/drm_edid_load.c     |  241 +++++++++++++++++++++++++++++=
++++
>  include/drm/drm_crtc.h              |    1=20
>  include/drm/drm_edid.h              |    1=20
>  16 files changed, 778 insertions(+), 3 deletions(-)

[=E2=80=A6]

> Index: linux-3.3-rc6/Documentation/kernel-parameters.txt
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-3.3-rc6.orig/Documentation/kernel-parameters.txt
> +++ linux-3.3-rc6/Documentation/kernel-parameters.txt
> @@ -713,6 +713,16 @@ bytes respectively. Such letter suffixes
>  			The filter can be disabled or changed to another
>  			driver later using sysfs.
> =20
> +	drm_kms_helper.edid_firmware=3D<file>
> +			Broken monitors, graphic adapters and KVMs may
> +			send no or broken EDID data sets. This parameter
> +			allows to specify an EDID data set in the
> +			/lib/firmware directory that is used instead.
> +			Generic built-in EDID data sets are used, if one of
> +			edid/1024x768.bin, edid/1280x1024.bin,
> +			edid/1680x1050.bin, or edid/1920x1080.bin is given
> +			and no file with the same name exists.

Maybe a hint to look into `Documentation/EDID` could be added?

> +
>  	dscc4.setup=3D	[NET]
> =20
>  	earlycon=3D	[KNL] Output early console device and options.
> Index: linux-3.3-rc6/drivers/gpu/drm/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-3.3-rc6.orig/drivers/gpu/drm/Kconfig
> +++ linux-3.3-rc6/drivers/gpu/drm/Kconfig
> @@ -27,6 +27,17 @@ config DRM_KMS_HELPER
>  	help
>  	  FB and CRTC helpers for KMS drivers.
> =20
> +config DRM_LOAD_EDID_FIRMWARE
> +	bool "Allow to specify an EDID data set instead of probing for it"
> +	depends on DRM_KMS_HELPER
> +	help
> +	  Say Y here, if you want to use EDID data to be loaded from the
> +	  /lib/firmware directory or one of the provided built-in
> +	  data sets. This may be necessary, if the graphics adapter or
> +	  monitor are unable to provide appropriate EDID data. Since this
> +	  feature is provided as a workaround for broken hardware, the
> +	  default case is N.

Dito.

> +
>  config DRM_TTM
>  	tristate
>  	depends on DRM

[=E2=80=A6]


Thanks,

Paul

--=-t04FJXdUHutUxAOSeyIU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk9hlrMACgkQPX1aK2wOHVhm6gCfbige3qXTjyaHpRf2mSAKC3ne
doUAnj9I+szhn3XWkw5b5ENjQTlrzyGH
=gq2A
-----END PGP SIGNATURE-----

--=-t04FJXdUHutUxAOSeyIU--

