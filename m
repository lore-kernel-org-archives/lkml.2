Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab1AGPtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:49:21 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:37636 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab1AGPtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:49:20 -0500
Date: Fri, 7 Jan 2011 16:49:16 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: linux-kernel@vger.kernel.org
Subject: i915: 2.6.36: Monitor incorrectly detects 1920x1199
Message-ID: <20110107154916.GA8149@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

starting with 2.6.36 my monitor displays a resolution of 1920x1199
instead of 1920x1200 on its OSD. As a result, I guess, the display is
blurred in the middle section (top to down) - most likely due to
stretching applied by the monitor.

This issue shows up when loading i915 (KMS enabled) with 2.6.37 and
2.6.36 (also 2.6.36.2). With 2.6.35 (up to 2.6.35.10) the monitor
correctly displays 1920x1200 and doesn't blur anything.

The Chipset is an Intel G35 on an Asus P5E-V HDMI, the monitor is a
Yuraku YV24WBH1 connected via DVI (DVI to HDMI adapter, the board
doesn't have a separate DVI port).

The `fbset' output with 2.6.37 and 2.6.35.10 doesn't differ:
	mode "1920x1200"
	    geometry 1920 1200 1920 1200 32
	    timings 0 0 0 0 0 0 0
	    rgba 8/16,8/8,8/0,0/0
	endmode

dmesg excerpt for 2.6.37:
[    2.733019] efifb: probing for efifb
[    2.744452] efifb: framebuffer at 0xd0000000, mapped to 0xf8280000, usin=
g 7552k, total 7552k
[    2.769712] efifb: mode is 1600x1200x32, linelength=3D6400, pages=3D1
[    2.787964] efifb: scrolling: redraw
[    2.798678] efifb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    2.927422] fb0: EFI VGA frame buffer device
[   71.202957] [drm] Initialized drm 1.1.0 20060810
[   71.374419] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   71.374423] i915 0000:00:02.0: setting latency timer to 64
[   71.474329] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[   71.669097] [drm] initialized overlay support
[   71.942025] fb: conflicting fb hw usage inteldrmfb vs EFI VGA - removing=
 generic driver
[   72.223827] fb0: inteldrmfb frame buffer device
[   72.223829] drm: registered panic notifier
[   72.223961] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[   87.492007] [drm] GMBUS timed out, falling back to bit banging on pin 0 =
[i915 gmbus disabled]
[   87.572007] [drm] GMBUS timed out, falling back to bit banging on pin 0 =
[i915 gmbus disabled]
[   87.652006] [drm] GMBUS timed out, falling back to bit banging on pin 0 =
[i915 gmbus disabled]
[   87.732007] [drm] GMBUS timed out, falling back to bit banging on pin 0 =
[i915 gmbus disabled]
[   87.812007] [drm] GMBUS timed out, falling back to bit banging on pin 0 =
[i915 gmbus disabled]
[   87.892007] [drm] GMBUS timed out, falling back to bit banging on pin 0 =
[i915 gmbus disabled]
[   87.972008] [drm] GMBUS timed out, falling back to bit banging on pin 0 =
[i915 gmbus disabled]
[   88.052006] [drm] GMBUS timed out, falling back to bit banging on pin 0 =
[i915 gmbus disabled]
[   89.692006] [drm] GMBUS timed out, falling back to bit banging on pin 6 =
[i915 gmbus reserved]
[   89.772006] [drm] GMBUS timed out, falling back to bit banging on pin 6 =
[i915 gmbus reserved]
[   89.852006] [drm] GMBUS timed out, falling back to bit banging on pin 6 =
[i915 gmbus reserved]
[   89.932007] [drm] GMBUS timed out, falling back to bit banging on pin 6 =
[i915 gmbus reserved]
[   90.012007] [drm] GMBUS timed out, falling back to bit banging on pin 6 =
[i915 gmbus reserved]
[   90.092006] [drm] GMBUS timed out, falling back to bit banging on pin 6 =
[i915 gmbus reserved]
[   90.172006] [drm] GMBUS timed out, falling back to bit banging on pin 6 =
[i915 gmbus reserved]
[   90.252006] [drm] GMBUS timed out, falling back to bit banging on pin 6 =
[i915 gmbus reserved]

dmesg excerpt for 2.6.35.10:
[    3.401792] efifb: probing for efifb
[    3.412804] efifb: framebuffer at 0xd0000000, mapped to 0xf8280000, usin=
g 3072k, total 3072k
[    3.438065] efifb: mode is 1024x768x32, linelength=3D4096, pages=3D1
[    3.456058] efifb: scrolling: redraw
[    3.466773] efifb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    3.540728] fb0: EFI VGA frame buffer device
[   52.667436] [drm] Initialized drm 1.1.0 20060810
[   52.824746] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   52.824750] i915 0000:00:02.0: setting latency timer to 64
[   52.901066] i915 0000:00:02.0: irq 47 for MSI/MSI-X
[   52.901076] [drm] set up 7M of stolen space
[   53.255059] [drm] initialized overlay support
[   53.806061] fb: conflicting fb hw usage inteldrmfb vs EFI VGA - removing=
 generic driver
[   54.171524] fb0: inteldrmfb frame buffer device
[   54.171525] drm: registered panic notifier
[   54.171681] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0

The monitor's EDID information via `get-edid | parse-edid':
		# EDID version 1 revision 3
	Section "Monitor"
		# Block type: 2:0 3:fc
		Identifier "MB24W"
		VendorName "NTS"
		ModelName "MB24W"
		# Block type: 2:0 3:fc
		# Block type: 2:0 3:fd
		HorizSync 30-74
		VertRefresh 50-61
		# Max dot clock (video bandwidth) 160 MHz
		# Block type: 2:0 3:ff
		# DPMS capabilities: Active off:yes  Suspend:no  Standby:no
=09
		Mode 	"1920x1200"	# vfreq 59.950Hz, hfreq 74.038kHz
			DotClock	154.000000
			HTimings	1920 1968 2000 2080
			VTimings	1200 1203 1209 1235
			Flags	"-HSync" "+VSync"
		EndMode
		# Block type: 2:0 3:fc
		# Block type: 2:0 3:fd
		# Block type: 2:0 3:ff
	EndSection


PS: I found no other matching mailing-list on vger, please hint me if I
missed one.


regards
   Mario
--=20
File names are infinite in length where infinity is set to 255 characters.
                                -- Peter Collinson, "The Unix File System"

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTSc1/BS+e2HeSPbpAQK04wf8CeNjrwZ5XrbB6uVOGhKK2CWmOdO2JYyn
JdyX0Qo+pDjqocVfSddNmVTaX2lXof1ZZndk3p0Gb0GdnXq7L4H183KAxr/LTi0F
OTCV4JABQDpoZNVbLEqZAyavJ4ujMbWwaSSI/SLZvKWhIz3020ZaWnzWwawA9j4Z
8Fo2fvS9ITs4aNp/U9l115b2OC9HJIPAmJtGKvZzUVcegZKPZExSa0gZ6w+dZbd4
RP6sa8P9c4KNa+TKyT/Y820kuPbakooCGisQ5hVqSldcZRabpv1HvzEZdWrgz5C0
IqwI0u3O6JLI431axEkNXKy40KMKP8+z7uk2/MTg80rRByMIceEYag==
=1QQv
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
