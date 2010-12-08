Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab0LHRb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:31:58 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:58735 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab0LHRb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:31:56 -0500
Message-ID: <4CFFC0F0.6050006@oracle.com>
Date: Wed, 08 Dec 2010 09:31:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
CC: sedat.dilek@gmail.com, Matthew Garrett <mjg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for December 8 (drivers/platform/x86/Kconfig:422:error:
 recursive dependency detected!)
References: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com> <AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
In-Reply-To: <AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/10 01:12, Corentin Chary wrote:
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
>>  HOSTCC  scripts/basic/fixdep
>>  HOSTCC  scripts/basic/docproc
>>  GEN     /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_none_686/Makefile
>>  HOSTCC  scripts/kconfig/conf.o
>>  HOSTCC  scripts/kconfig/kxgettext.o
>>  SHIPPED scripts/kconfig/zconf.tab.c
>>  SHIPPED scripts/kconfig/lex.zconf.c
>>  SHIPPED scripts/kconfig/zconf.hash.c
>>  HOSTCC  scripts/kconfig/zconf.tab.o
>>  HOSTLD  scripts/kconfig/conf
>> scripts/kconfig/conf --oldnoconfig Kconfig
>> drivers/platform/x86/Kconfig:422:error: recursive dependency detected!
>> drivers/platform/x86/Kconfig:422:       symbol EEEPC_WMI depends on ACPI_WMI
>> drivers/platform/x86/Kconfig:438:       symbol ACPI_WMI is selected by ACER_WMI
>> drivers/platform/x86/Kconfig:18:        symbol ACER_WMI depends on LEDS_CLASS
>> drivers/leds/Kconfig:10:        symbol LEDS_CLASS is selected by EEEPC_WMI
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
>>  prepare
>> make[2]: Entering directory
>> `/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none'
>>  GEN     /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_none_686/Makefile
>> scripts/kconfig/conf --silentoldconfig Kconfig
>> drivers/platform/x86/Kconfig:422:error: recursive dependency detected!
>> drivers/platform/x86/Kconfig:422:       symbol EEEPC_WMI depends on ACPI_WMI
>> drivers/platform/x86/Kconfig:438:       symbol ACPI_WMI is selected by ACER_WMI
>> drivers/platform/x86/Kconfig:18:        symbol ACER_WMI depends on LEDS_CLASS
>> drivers/leds/Kconfig:10:        symbol LEDS_CLASS is selected by EEEPC_WMI
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
>>  Using /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none
>> as source for kernel
>>  GEN     /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_none_686/Makefile
>>  CHK     include/linux/version.h
>>  UPD     include/linux/version.h
>>  CHK     include/generated/utsrelease.h
>>  UPD     include/generated/utsrelease.h
>>  CC      kernel/bounds.s
>>  GEN     include/generated/bounds.h
>>  CC      arch/x86/kernel/asm-offsets.s
>>  GEN     include/generated/asm-offsets.h
>>  CALL    /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none/scripts/checksyscalls.sh
>> make[2]: Leaving directory
>> `/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none'
>> make[1]: Leaving directory `/home/sd/src/linux-2.6/linux-2.6.37-rc5'
>>
>> Regards,
>> - Sedat -
>> --
>> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> Hum ...
> ACER_WMI:
>   select ACPI_WMI
>   depends on LEDS_CLASS
>   depends on NEW_LEDS
> 
> EEEPC_WMI:
>   depends on ACPI_WMI
>   select LEDS_CLASS
>   select NEW_LEDS
> 
> I don't really see how it's a recursive dependency, but maybe it's
> time to clean this KConfig.

It's circular.

> What is our current policy about that ?

Documentation/kbuild/kconfig-language.txt says:

  Note:
	select should be used with care. select will force
	a symbol to a value without visiting the dependencies.
	By abusing select you are able to select a symbol FOO even
	if FOO depends on BAR that is not set.
	In general use select only for non-visible symbols
	(no prompts anywhere) and for symbols with no dependencies.
	That will limit the usefulness but on the other hand avoid
	the illegal configurations all over.


I think that it would help if all of drivers/platform/x86/Kconfig treated
ACPI_WMI the same way.  Currently 2 drivers select it and 4 drivers depend
on it.

Ah, that's what Sedat's patch does.  Good.

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


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
