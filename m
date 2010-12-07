Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab0LGCYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:24:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52362 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab0LGCYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:24:50 -0500
Date: Tue, 7 Dec 2010 13:24:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the drivers-x86 tree
Message-Id: <20101207132443.6516fd07.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Dec_2010_13_24_43_+1100_+jMi9/O_7UP45sXS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Dec_2010_13_24_43_+1100_+jMi9/O_7UP45sXS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

After merging the drivers-x86 tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/platform/x86/toshiba_acpi.c: In function 'wwan_rfkill_set_block':
drivers/platform/x86/toshiba_acpi.c:454: error: 'HCI_WIRELESS_WWAN_ENABLE' =
undeclared (first use in this function)
drivers/platform/x86/toshiba_acpi.c:454: error: (Each undeclared identifier=
 is reported only once
drivers/platform/x86/toshiba_acpi.c:454: error: for each function it appear=
s in.)

Caused by commit 64ea4efdd949c99d9206a44a43984d2e861350f1 ("wwan rfkill stu=
bs").

I have used the version of the drivers-x86 tree from next-20101206 for toda=
y.

I also got the following new messages from the build:

drivers/platform/x86/Kconfig:422:error: recursive dependency detected!
drivers/platform/x86/Kconfig:422:	symbol EEEPC_WMI depends on ACPI_WMI
drivers/platform/x86/Kconfig:438:	symbol ACPI_WMI is selected by ACER_WMI
drivers/platform/x86/Kconfig:18:	symbol ACER_WMI depends on LEDS_CLASS
drivers/leds/Kconfig:10:	symbol LEDS_CLASS is selected by EEEPC_WMI

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

drivers/platform/x86/toshiba_acpi.c:460: warning: label 'out' defined but n=
ot used
drivers/platform/x86/toshiba_acpi.c:448: warning: unused variable 'radio_st=
ate'
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Dec_2010_13_24_43_+1100_+jMi9/O_7UP45sXS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM/ZrrAAoJEDMEi1NhKgbsuCMIAJKqKx8WIRqQmdinVdcjWhNc
ppxagKVCiwr/fR4EthEvoSzTfthNhK4bhuqESEKbsxXeKl0gCC40F8PrB0IebQH6
vvFaZ/oiWthwuR72+sgo28R2tKW4FJ0yzCAGRuy+QokuG0akXKRmVWtbRi0wpmOJ
CW11iewYerghjnNiOyP2BzQp64aLXE6jUhHPKaBdCBBR3JCTOy/kkWmC/dB9gOBO
r9HslRdRSxBxm3NZntaNihcueVZVRhtrTVAwv9pEpzbqA5Z676DbFaY99Uuq5BKT
FQ7sl5dlYM7W86rbKYk1jYfD8GQmTyqE9+Vcxnue+0OHafxOcaMqwLjN9xKKBs4=
=JI+R
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Dec_2010_13_24_43_+1100_+jMi9/O_7UP45sXS--
