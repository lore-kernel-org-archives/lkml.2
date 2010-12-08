Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab0LHIRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:17:40 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43460 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab0LHIRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:17:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=whrW2i/LNu3ccJMZf/kFBaAW1QR0F+gK9uoFXs+VZnz/fT+1OUSjEjlj78P9VYpqVO
         9Q1X1H60rEXeGhzUkboWAIBas9MKMeKJQexX3guaqZFOjV8ySbYtxeBf4Rlk7wapS33C
         GIyq9WabsafFPNG+SwYEiJFY6AXssgY3lC3WY=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 8 Dec 2010 09:17:38 +0100
Message-ID: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com>
Subject: Re: linux-next: Tree for December 8 (drivers/platform/x86/Kconfig:422:error:
 recursive dependency detected!)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Matthew Garrett <mjg@redhat.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just wanted to build a new linux-next and see this:

[ setup.log ]
...
dileks.1" make -C 'debian/build/source_i386_none'
O='/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_none_686'
oldnoconfig
make[2]: Entering directory
`/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none'
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  GEN     /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_none_686/Makefile
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/lex.zconf.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --oldnoconfig Kconfig
drivers/platform/x86/Kconfig:422:error: recursive dependency detected!
drivers/platform/x86/Kconfig:422:       symbol EEEPC_WMI depends on ACPI_WMI
drivers/platform/x86/Kconfig:438:       symbol ACPI_WMI is selected by ACER_WMI
drivers/platform/x86/Kconfig:18:        symbol ACER_WMI depends on LEDS_CLASS
drivers/leds/Kconfig:10:        symbol LEDS_CLASS is selected by EEEPC_WMI
warning: (ADB_PMU_LED && MACINTOSH_DRIVERS && ADB_PMU || ATH5K &&
NETDEVICES && WLAN && ATH_COMMON && (PCI || ATHEROS_AR231X) &&
MAC80211 || ATH9K && NETDEVICES && WLAN && ATH_COMMON && PCI &&
MAC80211 || ATH9K_HTC && NETDEVICES && WLAN && ATH_COMMON && USB &&
MAC80211 || CARL9170_LEDS && NETDEVICES && WLAN && ATH_COMMON &&
CARL9170 || INPUT_WISTRON_BTNS && !S390 && INPUT && INPUT_MISC && X86
&& !X86_64 || SENSORS_APPLESMC && HWMON && INPUT && X86 ||
SENSORS_LIS3LV02D && HWMON && ACPI && INPUT || IR_WINBOND_CIR &&
MEDIA_SUPPORT && X86 && PNP && RC_CORE || BACKLIGHT_ADP8860 &&
HAS_IOMEM && BACKLIGHT_LCD_SUPPORT && BACKLIGHT_CLASS_DEVICE && I2C ||
MSM_STAGING && STAGING && !STAGING_EXCLUDE_BUILD && FB && ARCH_MSM &&
!FB_MSM || ASUS_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI &&
!ACPI_ASUS && INPUT && (RFKILL || RFKILL=n) || THINKPAD_ACPI && X86 &&
X86_PLATFORM_DEVICES && ACPI && INPUT && (RFKILL || RFKILL=n) ||
EEEPC_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI && INPUT &&
EXPERIMENTAL && (RFKILL || RFKILL=n) && HOTPLUG_PCI || EEEPC_WMI &&
X86 && X86_PLATFORM_DEVICES && ACPI_WMI && INPUT && EXPERIMENTAL &&
BACKLIGHT_CLASS_DEVICE && (RFKILL || RFKILL=n)) selects LEDS_CLASS
which has unmet direct dependencies (NEW_LEDS)
#
# configuration written to .config
#
make[2]: Leaving directory
`/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none'
env -u ABINAME -u ARCH -u FEATURESET -u FLAVOUR -u VERSION -u
LOCALVERSION DISTRIBUTION_OFFICIAL_BUILD=1
DISTRIBUTION_UPLOADER=sedat.dilek@gmail.com
DISTRIBUTION_VERSION="2.6.37~rc5-1~next20101208.dileks.1" make -C
'debian/build/source_i386_none'
O='/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_none_686'
 prepare
make[2]: Entering directory
`/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none'
  GEN     /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_none_686/Makefile
scripts/kconfig/conf --silentoldconfig Kconfig
drivers/platform/x86/Kconfig:422:error: recursive dependency detected!
drivers/platform/x86/Kconfig:422:       symbol EEEPC_WMI depends on ACPI_WMI
drivers/platform/x86/Kconfig:438:       symbol ACPI_WMI is selected by ACER_WMI
drivers/platform/x86/Kconfig:18:        symbol ACER_WMI depends on LEDS_CLASS
drivers/leds/Kconfig:10:        symbol LEDS_CLASS is selected by EEEPC_WMI
warning: (ADB_PMU_LED && MACINTOSH_DRIVERS && ADB_PMU || ATH5K &&
NETDEVICES && WLAN && ATH_COMMON && (PCI || ATHEROS_AR231X) &&
MAC80211 || ATH9K && NETDEVICES && WLAN && ATH_COMMON && PCI &&
MAC80211 || ATH9K_HTC && NETDEVICES && WLAN && ATH_COMMON && USB &&
MAC80211 || CARL9170_LEDS && NETDEVICES && WLAN && ATH_COMMON &&
CARL9170 || INPUT_WISTRON_BTNS && !S390 && INPUT && INPUT_MISC && X86
&& !X86_64 || SENSORS_APPLESMC && HWMON && INPUT && X86 ||
SENSORS_LIS3LV02D && HWMON && ACPI && INPUT || IR_WINBOND_CIR &&
MEDIA_SUPPORT && X86 && PNP && RC_CORE || BACKLIGHT_ADP8860 &&
HAS_IOMEM && BACKLIGHT_LCD_SUPPORT && BACKLIGHT_CLASS_DEVICE && I2C ||
MSM_STAGING && STAGING && !STAGING_EXCLUDE_BUILD && FB && ARCH_MSM &&
!FB_MSM || ASUS_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI &&
!ACPI_ASUS && INPUT && (RFKILL || RFKILL=n) || THINKPAD_ACPI && X86 &&
X86_PLATFORM_DEVICES && ACPI && INPUT && (RFKILL || RFKILL=n) ||
EEEPC_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI && INPUT &&
EXPERIMENTAL && (RFKILL || RFKILL=n) && HOTPLUG_PCI || EEEPC_WMI &&
X86 && X86_PLATFORM_DEVICES && ACPI_WMI && INPUT && EXPERIMENTAL &&
BACKLIGHT_CLASS_DEVICE && (RFKILL || RFKILL=n)) selects LEDS_CLASS
which has unmet direct dependencies (NEW_LEDS)
  Using /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none
as source for kernel
  GEN     /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_none_686/Makefile
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      kernel/bounds.s
  GEN     include/generated/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none/scripts/checksyscalls.sh
make[2]: Leaving directory
`/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none'
make[1]: Leaving directory `/home/sd/src/linux-2.6/linux-2.6.37-rc5'

Regards,
- Sedat -
