Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab0LHJ2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 04:28:51 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47641 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab0LHJ2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 04:28:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=R6M6RCR7qIqmP1DQ8MeBAUvV7mnGldssuoORNTO6CkKIdR5giBr6yQqAijQeQPktXl
         onbquhEeoPZTqgbOAniGz+qXfKr8IZD5UWAJiu5R3yZIEs2d+Ziut9XyrmzBcuFdYgAE
         yBG0JlAB5AV/K+GQFUgMmgjKN8lsewMTvJQjQ=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
References: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com>
	<AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
Date: Wed, 8 Dec 2010 10:28:46 +0100
Message-ID: <AANLkTim5picexJzLpJN6BGUeo28Cf1h_VQe+X=UY+mL8@mail.gmail.com>
Subject: Re: linux-next: Tree for December 8 (drivers/platform/x86/Kconfig:422:error:
 recursive dependency detected!)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 10:12 AM, Corentin Chary
<corentin.chary@gmail.com> wrote:
> On Wed, Dec 8, 2010 at 9:17 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> Hi,
>>
>> just wanted to build a new linux-next and see this:
>>
>> [ setup.log ]
>> ...
>> dileks.1" make -C 'debian/build/source_i386_none'
>> O='/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_none_686'
>> oldnoconfig
>> make[2]: Entering directory
>> `/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none'
>>  HOSTCC  scripts/basic/fixdep
>>  HOSTCC  scripts/basic/docproc
>>  GEN     /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_none_686/Makefile
>>  HOSTCC  scripts/kconfig/conf.o
>>  HOSTCC  scripts/kconfig/kxgettext.o
>>  SHIPPED scripts/kconfig/zconf.tab.c
>>  SHIPPED scripts/kconfig/lex.zconf.c
>>  SHIPPED scripts/kconfig/zconf.hash.c
>>  HOSTCC  scripts/kconfig/zconf.tab.o
>>  HOSTLD  scripts/kconfig/conf
>> scripts/kconfig/conf --oldnoconfig Kconfig
>> drivers/platform/x86/Kconfig:422:error: recursive dependency detected!
>> drivers/platform/x86/Kconfig:422:       symbol EEEPC_WMI depends on ACPI_WMI
>> drivers/platform/x86/Kconfig:438:       symbol ACPI_WMI is selected by ACER_WMI
>> drivers/platform/x86/Kconfig:18:        symbol ACER_WMI depends on LEDS_CLASS
>> drivers/leds/Kconfig:10:        symbol LEDS_CLASS is selected by EEEPC_WMI
>> warning: (ADB_PMU_LED && MACINTOSH_DRIVERS && ADB_PMU || ATH5K &&
>> NETDEVICES && WLAN && ATH_COMMON && (PCI || ATHEROS_AR231X) &&
>> MAC80211 || ATH9K && NETDEVICES && WLAN && ATH_COMMON && PCI &&
>> MAC80211 || ATH9K_HTC && NETDEVICES && WLAN && ATH_COMMON && USB &&
>> MAC80211 || CARL9170_LEDS && NETDEVICES && WLAN && ATH_COMMON &&
>> CARL9170 || INPUT_WISTRON_BTNS && !S390 && INPUT && INPUT_MISC && X86
>> && !X86_64 || SENSORS_APPLESMC && HWMON && INPUT && X86 ||
>> SENSORS_LIS3LV02D && HWMON && ACPI && INPUT || IR_WINBOND_CIR &&
>> MEDIA_SUPPORT && X86 && PNP && RC_CORE || BACKLIGHT_ADP8860 &&
>> HAS_IOMEM && BACKLIGHT_LCD_SUPPORT && BACKLIGHT_CLASS_DEVICE && I2C ||
>> MSM_STAGING && STAGING && !STAGING_EXCLUDE_BUILD && FB && ARCH_MSM &&
>> !FB_MSM || ASUS_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI &&
>> !ACPI_ASUS && INPUT && (RFKILL || RFKILL=n) || THINKPAD_ACPI && X86 &&
>> X86_PLATFORM_DEVICES && ACPI && INPUT && (RFKILL || RFKILL=n) ||
>> EEEPC_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI && INPUT &&
>> EXPERIMENTAL && (RFKILL || RFKILL=n) && HOTPLUG_PCI || EEEPC_WMI &&
>> X86 && X86_PLATFORM_DEVICES && ACPI_WMI && INPUT && EXPERIMENTAL &&
>> BACKLIGHT_CLASS_DEVICE && (RFKILL || RFKILL=n)) selects LEDS_CLASS
>> which has unmet direct dependencies (NEW_LEDS)
>> #
>> # configuration written to .config
>> #
>> make[2]: Leaving directory
>> `/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none'
>> env -u ABINAME -u ARCH -u FEATURESET -u FLAVOUR -u VERSION -u
>> LOCALVERSION DISTRIBUTION_OFFICIAL_BUILD=1
>> DISTRIBUTION_UPLOADER=sedat.dilek@gmail.com
>> DISTRIBUTION_VERSION="2.6.37~rc5-1~next20101208.dileks.1" make -C
>> 'debian/build/source_i386_none'
>> O='/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_none_686'
>>  prepare
>> make[2]: Entering directory
>> `/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none'
>>  GEN     /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_none_686/Makefile
>> scripts/kconfig/conf --silentoldconfig Kconfig
>> drivers/platform/x86/Kconfig:422:error: recursive dependency detected!
>> drivers/platform/x86/Kconfig:422:       symbol EEEPC_WMI depends on ACPI_WMI
>> drivers/platform/x86/Kconfig:438:       symbol ACPI_WMI is selected by ACER_WMI
>> drivers/platform/x86/Kconfig:18:        symbol ACER_WMI depends on LEDS_CLASS
>> drivers/leds/Kconfig:10:        symbol LEDS_CLASS is selected by EEEPC_WMI
>> warning: (ADB_PMU_LED && MACINTOSH_DRIVERS && ADB_PMU || ATH5K &&
>> NETDEVICES && WLAN && ATH_COMMON && (PCI || ATHEROS_AR231X) &&
>> MAC80211 || ATH9K && NETDEVICES && WLAN && ATH_COMMON && PCI &&
>> MAC80211 || ATH9K_HTC && NETDEVICES && WLAN && ATH_COMMON && USB &&
>> MAC80211 || CARL9170_LEDS && NETDEVICES && WLAN && ATH_COMMON &&
>> CARL9170 || INPUT_WISTRON_BTNS && !S390 && INPUT && INPUT_MISC && X86
>> && !X86_64 || SENSORS_APPLESMC && HWMON && INPUT && X86 ||
>> SENSORS_LIS3LV02D && HWMON && ACPI && INPUT || IR_WINBOND_CIR &&
>> MEDIA_SUPPORT && X86 && PNP && RC_CORE || BACKLIGHT_ADP8860 &&
>> HAS_IOMEM && BACKLIGHT_LCD_SUPPORT && BACKLIGHT_CLASS_DEVICE && I2C ||
>> MSM_STAGING && STAGING && !STAGING_EXCLUDE_BUILD && FB && ARCH_MSM &&
>> !FB_MSM || ASUS_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI &&
>> !ACPI_ASUS && INPUT && (RFKILL || RFKILL=n) || THINKPAD_ACPI && X86 &&
>> X86_PLATFORM_DEVICES && ACPI && INPUT && (RFKILL || RFKILL=n) ||
>> EEEPC_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI && INPUT &&
>> EXPERIMENTAL && (RFKILL || RFKILL=n) && HOTPLUG_PCI || EEEPC_WMI &&
>> X86 && X86_PLATFORM_DEVICES && ACPI_WMI && INPUT && EXPERIMENTAL &&
>> BACKLIGHT_CLASS_DEVICE && (RFKILL || RFKILL=n)) selects LEDS_CLASS
>> which has unmet direct dependencies (NEW_LEDS)
>>  Using /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none
>> as source for kernel
>>  GEN     /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_none_686/Makefile
>>  CHK     include/linux/version.h
>>  UPD     include/linux/version.h
>>  CHK     include/generated/utsrelease.h
>>  UPD     include/generated/utsrelease.h
>>  CC      kernel/bounds.s
>>  GEN     include/generated/bounds.h
>>  CC      arch/x86/kernel/asm-offsets.s
>>  GEN     include/generated/asm-offsets.h
>>  CALL    /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none/scripts/checksyscalls.sh
>> make[2]: Leaving directory
>> `/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none'
>> make[1]: Leaving directory `/home/sd/src/linux-2.6/linux-2.6.37-rc5'
>>
>> Regards,
>> - Sedat -
>> --
>> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Hum ...
> ACER_WMI:
>  select ACPI_WMI
>  depends on LEDS_CLASS
>  depends on NEW_LEDS
>
> EEEPC_WMI:
>  depends on ACPI_WMI
>  select LEDS_CLASS
>  select NEW_LEDS
>
> I don't really see how it's a recursive dependency, but maybe it's
> time to clean this KConfig.
> What is our current policy about that ?
>
> I think we should *depends* on important subsystem (ACPI, INPUT, ...)
> and select obscure things so
> that the driver does not get lost if you don't enable the leds.
>
> depends:
> - ACPI
> - INPUT
> - EXPERIMENTAL
> - RFKILL
> - ACPI_WMI ?
> - HWMON ?
> - THERMAL ?
>
> select:
> - BACKLIGHT_CLASS_*
> - LEDS_CLASS
> - NEW_LEDS
> - INPUT_*
>
> --
> Corentin Chary
> http://xf.iksaif.net
>

The last 3 commits touching drivers/platform/x86/Kconfig:

$ git log -3 drivers/platform/x86/Kconfig

commit 8c75facc93240c864bcbc9b45c492b32725ad2d4
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Mon Nov 29 08:14:07 2010 +0100

    eeepc-wmi: add rfkill support for wlan, bluetooth and 3g

    wimax support is missing because I don't have any DSDT
    with WMI and wimax support.

    Most of the code comes from eeepc-laptop.

    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Matthew Garrett <mjg@redhat.com>

commit 41eeea57adfb7d37b4a826877a8a6965cae5fb4a
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Mon Nov 29 08:14:06 2010 +0100

    eeepc-wmi: add touchpad led support

    Most of the code comes from eeepc-laptop.

    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Matthew Garrett <mjg@redhat.com>

commit 02846193f7b31e7f12a007894bdb1b4f4d7d6c22
Author: Sreedhara DS <sreedhara.ds@intel.com>
Date:   Fri Oct 22 15:43:55 2010 +0100

    intel_scu_ipc: Utility driver for intel scu ipc
...
