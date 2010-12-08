Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab0LHCdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:33:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54155 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543Ab0LHCdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 21:33:06 -0500
Date: Wed, 8 Dec 2010 13:32:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Chary <corentincj@iksaif.net>
Subject: linux-next: build warnings after merge of the drivers-x86 tree
Message-Id: <20101208133251.1a39fa47.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Dec_2010_13_32_51_+1100_r4V+6eg+WmFliyrt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Dec_2010_13_32_51_+1100_r4V+6eg+WmFliyrt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

After merging the scsi-post-merge tree, today's linux-next build (all
builds) produced these warnings:

drivers/platform/x86/Kconfig:422:error: recursive dependency detected!
drivers/platform/x86/Kconfig:422:	symbol EEEPC_WMI depends on ACPI_WMI
drivers/platform/x86/Kconfig:438:	symbol ACPI_WMI is selected by ACER_WMI
drivers/platform/x86/Kconfig:18:	symbol ACER_WMI depends on LEDS_CLASS
drivers/leds/Kconfig:10:	symbol LEDS_CLASS is selected by EEEPC_WMI

The x86_64 allmodconfig and i386 defconfig builds also produced this:

warning: (ADB_PMU_LED && MACINTOSH_DRIVERS && ADB_PMU || ATH5K && NETDEVICE=
S && WLAN && ATH_COMMON && (PCI || ATHEROS_AR231X) && MAC80211 || ATH9K && =
NETDEVICES && WLAN && ATH_COMMON && PCI && MAC80211 || ATH9K_HTC && NETDEVI=
CES && WLAN && ATH_COMMON && USB && MAC80211 || CARL9170_LEDS && NETDEVICES=
 && WLAN && ATH_COMMON && CARL9170 || INPUT_WISTRON_BTNS && !S390 && INPUT =
&& INPUT_MISC && X86 && !X86_64 || SENSORS_APPLESMC && HWMON && INPUT && X8=
6 || SENSORS_LIS3LV02D && HWMON && ACPI && INPUT || IR_WINBOND_CIR && MEDIA=
_SUPPORT && X86 && PNP && RC_CORE || BACKLIGHT_ADP8860 && HAS_IOMEM && BACK=
LIGHT_LCD_SUPPORT && BACKLIGHT_CLASS_DEVICE && I2C || MSM_STAGING && STAGIN=
G && !STAGING_EXCLUDE_BUILD && FB && ARCH_MSM && !FB_MSM || ASUS_LAPTOP && =
X86 && X86_PLATFORM_DEVICES && ACPI && !ACPI_ASUS && INPUT && (RFKILL || RF=
KILL=3Dn) || THINKPAD_ACPI && X86 && X86_PLATFORM_DEVICES && ACPI && INPUT =
&& (RFKILL || RFKILL=3Dn) || EEEPC_LAPTOP && X86 && X86_PLATFORM_DEVICES &&=
 ACPI && INPUT && EXPERIMENTAL && (RFKILL || RFKILL=3Dn) && HOTPLUG_PCI || =
EEEPC_WMI && X86 && X86_PLATFORM_DEVICES && ACPI_WMI && INPUT && EXPERIMENT=
AL && BACKLIGHT_CLASS_DEVICE && (RFKILL || RFKILL=3Dn)) selects LEDS_CLASS =
which has unmet direct dependencies (NEW_LEDS)

Introduced by commit 41eeea57adfb7d37b4a826877a8a6965cae5fb4a
("eeepc-wmi: add touchpad led support")?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__8_Dec_2010_13_32_51_+1100_r4V+6eg+WmFliyrt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM/u5TAAoJEDMEi1NhKgbsLoYH/1DevPn1F2WoijPSD2v28QP+
XlIdb8kWVHUV3A99LTmSCR8Ux6lLt6XI9M1JXOLl33NT8blTmB90Qid8nYbSYXBy
oSJ10THcPJCpFdwknefJAyEG8uopZh2uzj9zxfPZgcuuIK8ENlhC7ZIzBPFBLJWl
8UI/TnRJQuLnWhzMSfeETd7SNPj3WyPARVHI+HSe+9DiNNFFijhvx0P31JdhdZee
NPeSQj+T/KjPMsXbJVwIR4JDAnKXxG08ampIpbAkk5AeK+GFbMzy2ZeG/nC/2BO8
Q4z87TvWQyJ3VEOuUSy8rr1gVgV2y3vEf1j3wzuhacBq3NDmFqHb1zR/9AtofcU=
=doZ+
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Dec_2010_13_32_51_+1100_r4V+6eg+WmFliyrt--
