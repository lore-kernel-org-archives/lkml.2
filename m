Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab0LUSCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:02:07 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52351 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab0LUSCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:02:03 -0500
Date: Tue, 21 Dec 2010 10:01:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 6/11] HWMON: HWMON module of DA9052 device driver
Message-Id: <20101221100121.8954f687.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTin7N2HViUNSez9si7WytPkQAkTiR9NP3iUitbh4@mail.gmail.com>
References: <AANLkTin7N2HViUNSez9si7WytPkQAkTiR9NP3iUitbh4@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Dec 2010 18:52:50 +0100 dd diasemi wrote:

Hi,

Please include a "diffstat" with your patches, as described in
Documentation/SubmittingPatches, so we can easily see what files are
being added or modified.


> HWMON module for DA9052 PMIC device from Dialog Semiconductor.
> 
> Changes made since last submission:
> . removed the DA9052 customized success and error codes
> . changed da9052_manual_read() return type
> 
> Linux Kernel Version: 2.6.34

Kernel patches should be made to the latest version (but maybe it doesn't
matter in some cases).

> 
> Signed-off-by: D. Chen <dchen@diasemi.com>
> ---

You probably didn't mean to submit all of these changes to this Kconfig file ??

Did you look at this patch?


> diff -Naur linux-2.6.34-orig2/drivers/hwmon/Kconfig
> linux-2.6.34/drivers/hwmon/Kconfig
> --- linux-2.6.34-orig2/drivers/hwmon/Kconfig	2010-10-12 17:00:39.000000000 +0500
> +++ linux-2.6.34/drivers/hwmon/Kconfig	2010-10-12 14:15:56.000000000 +0500
> @@ -28,17 +28,6 @@
>  	tristate
>  	default n
> 
> -config HWMON_DEBUG_CHIP
> -	bool "Hardware Monitoring Chip debugging messages"
> -	default n
> -	help
> -	  Say Y here if you want the I2C chip drivers to produce a bunch of
> -	  debug messages to the system log.  Select this if you are having
> -	  a problem with I2C support and want to see more of what is going
> -	  on.
> -
> -comment "Native drivers"
> -
>  config SENSORS_ABITUGURU
>  	tristate "Abit uGuru (rev 1 & 2)"
>  	depends on X86 && EXPERIMENTAL
> @@ -170,16 +159,6 @@
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called adm9240.
> 
> -config SENSORS_ADT7411
> -	tristate "Analog Devices ADT7411"
> -	depends on I2C && EXPERIMENTAL
> -	help
> -	  If you say yes here you get support for the Analog Devices
> -	  ADT7411 voltage and temperature monitoring chip.
> -
> -	  This driver can also be built as a module. If so, the module
> -	  will be called adt7411.
> -
>  config SENSORS_ADT7462
>  	tristate "Analog Devices ADT7462"
>  	depends on I2C && EXPERIMENTAL
> @@ -200,30 +179,15 @@
>  	  This driver can also be built as a module. If so, the module
>  	  will be called adt7470.
> 
> -config SENSORS_ADT7475
> -	tristate "Analog Devices ADT7473, ADT7475, ADT7476 and ADT7490"
> +config SENSORS_ADT7473
> +	tristate "Analog Devices ADT7473"
>  	depends on I2C && EXPERIMENTAL
> -	select HWMON_VID
>  	help
>  	  If you say yes here you get support for the Analog Devices
> -	  ADT7473, ADT7475, ADT7476 and ADT7490 hardware monitoring
> -	  chips.
> +	  ADT7473 temperature monitoring chips.
> 
> -	  This driver can also be build as a module.  If so, the module
> -	  will be called adt7475.
> -
> -config SENSORS_ASC7621
> -	tristate "Andigilog aSC7621"
> -	depends on HWMON && I2C
> -	help
> -	  If you say yes here you get support for the aSC7621
> -	  family of SMBus sensors chip found on most Intel X38, X48, X58,
> -	  945, 965 and 975 desktop boards.  Currently supported chips:
> -	  aSC7621
> -	  aSC7621a
> -
> -	  This driver can also be built as a module.  If so, the module
> -	  will be called asc7621.
> +	  This driver can also be built as a module. If so, the module
> +	  will be called adt7473.
> 
>  config SENSORS_K8TEMP
>  	tristate "AMD Athlon64/FX or Opteron temperature sensor"
> @@ -237,18 +201,6 @@
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called k8temp.
> 
> -config SENSORS_K10TEMP
> -	tristate "AMD Phenom/Sempron/Turion/Opteron temperature sensor"
> -	depends on X86 && PCI
> -	help
> -	  If you say yes here you get support for the temperature
> -	  sensor(s) inside your CPU. Supported are later revisions of
> -	  the AMD Family 10h and all revisions of the AMD Family 11h
> -	  microarchitectures.
> -
> -	  This driver can also be built as a module.  If so, the module
> -	  will be called k10temp.
> -
>  config SENSORS_AMS
>  	tristate "Apple Motion Sensor driver"
>  	depends on PPC_PMAC && !PPC64 && INPUT && ((ADB_PMU && I2C = y) ||
> (ADB_PMU && !I2C) || I2C) && EXPERIMENTAL
> @@ -300,6 +252,13 @@
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called atxp1.
> 
> +config SENSORS_DA9052
> +        tristate "Dialog DA9052 HWMon"
> +        depends on PMIC_DA9052
> +        help
> +          Say y here to support the ADC found on
> +          Dialog Semiconductor DA9052 PMIC.
> +
>  config SENSORS_DS1621
>  	tristate "Dallas Semiconductor DS1621 and DS1625"
>  	depends on I2C
> @@ -332,12 +291,11 @@
>  	  will be called f71805f.
> 
>  config SENSORS_F71882FG
> -	tristate "Fintek F71858FG, F71862FG, F71882FG, F71889FG and F8000"
> +	tristate "Fintek F71882FG and F71883FG"
>  	depends on EXPERIMENTAL
>  	help
>  	  If you say yes here you get support for hardware monitoring
> -	  features of the Fintek F71858FG, F71862FG/71863FG, F71882FG/F71883FG,
> -	  F71889FG and F8000 Super-I/O chips.
> +	  features of the Fintek F71882FG and F71883FG Super-I/O chips.
> 
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called f71882fg.
> @@ -352,31 +310,39 @@
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called f75375s.
> 
> -config SENSORS_FSCHMD
> -	tristate "Fujitsu Siemens Computers sensor chips"
> +config SENSORS_FSCHER
> +	tristate "FSC Hermes"
>  	depends on X86 && I2C
>  	help
> -	  If you say yes here you get support for the following Fujitsu
> -	  Siemens Computers (FSC) sensor chips: Poseidon, Scylla, Hermes,
> -	  Heimdall, Heracles, Hades and Syleus including support for the
> -	  integrated watchdog.
> +	  If you say yes here you get support for Fujitsu Siemens
> +	  Computers Hermes sensor chips.
> 
> -	  This is a merged driver for FSC sensor chips replacing the fscpos,
> -	  fscscy and fscher drivers and adding support for several other FSC
> -	  sensor chips.
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called fscher.
> +
> +config SENSORS_FSCPOS
> +	tristate "FSC Poseidon"
> +	depends on X86 && I2C
> +	help
> +	  If you say yes here you get support for Fujitsu Siemens
> +	  Computers Poseidon sensor chips.
> 
>  	  This driver can also be built as a module.  If so, the module
> -	  will be called fschmd.
> +	  will be called fscpos.
> 
> -config SENSORS_G760A
> -	tristate "GMT G760A"
> -	depends on I2C
> +config SENSORS_FSCHMD
> +	tristate "FSC Poseidon, Scylla, Hermes, Heimdall and Heracles"
> +	depends on X86 && I2C && EXPERIMENTAL
>  	help
> -	  If you say yes here you get support for Global Mixed-mode
> -	  Technology Inc G760A fan speed PWM controller chips.
> +	  If you say yes here you get support for various Fujitsu Siemens
> +	  Computers sensor chips.
> +
> +	  This is a new merged driver for FSC sensor chips which is intended
> +	  as a replacment for the fscpos, fscscy and fscher drivers and adds
> +	  support for several other FCS sensor chips.
> 
>  	  This driver can also be built as a module.  If so, the module
> -	  will be called g760a.
> +	  will be called fschmd.
> 
>  config SENSORS_GL518SM
>  	tristate "Genesys Logic GL518SM"
> @@ -400,12 +366,12 @@
>  	  will be called gl520sm.
> 
>  config SENSORS_CORETEMP
> -	tristate "Intel Core/Core2/Atom temperature sensor"
> -	depends on X86 && PCI && EXPERIMENTAL
> +	tristate "Intel Core (2) Duo/Solo temperature sensor"
> +	depends on X86 && EXPERIMENTAL
>  	help
>  	  If you say yes here you get support for the temperature
> -	  sensor inside your CPU. Most of the family 6 CPUs
> -	  are supported. Check documentation/driver for details.
> +	  sensor inside your CPU. Supported all are all known variants
> +	  of Intel Core family.
> 
>  config SENSORS_IBMAEM
>  	tristate "IBM Active Energy Manager temperature/power sensors and control"
> @@ -416,7 +382,7 @@
>  	  power sensors and capping hardware in various IBM System X
>  	  servers that support Active Energy Manager.  This includes
>  	  the x3350, x3550, x3650, x3655, x3755, x3850 M2, x3950 M2,
> -	  and certain HC10/HS2x/LS2x/QS2x blades.
> +	  and certain HS2x/LS2x/QS2x blades.
> 
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called ibmaem.
> @@ -440,8 +406,7 @@
>  	select HWMON_VID
>  	help
>  	  If you say yes here you get support for ITE IT8705F, IT8712F,
> -	  IT8716F, IT8718F, IT8720F and IT8726F sensor chips, and the
> -	  SiS960 clone.
> +	  IT8716F, IT8718F and IT8726F sensor chips, and the SiS960 clone.
> 
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called it87.
> @@ -459,25 +424,15 @@
>  	  will be called lm63.
> 
>  config SENSORS_LM70
> -	tristate "National Semiconductor LM70 / Texas Instruments TMP121"
> +	tristate "National Semiconductor LM70"
>  	depends on SPI_MASTER && EXPERIMENTAL
>  	help
>  	  If you say yes here you get support for the National Semiconductor
> -	  LM70 and Texas Instruments TMP121/TMP123 digital temperature
> -	  sensor chips.
> +	  LM70 digital temperature sensor chip.
> 
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called lm70.
> 
> -config SENSORS_LM73
> -	tristate "National Semiconductor LM73"
> -	depends on I2C
> -	help
> -	  If you say yes here you get support for National Semiconductor LM73
> -	  sensor chips.
> -	  This driver can also be built as a module.  If so, the module
> -	  will be called lm73.
> -
>  config SENSORS_LM75
>  	tristate "National Semiconductor LM75 and compatibles"
>  	depends on I2C
> @@ -572,10 +527,9 @@
>  	depends on I2C
>  	help
>  	  If you say yes here you get support for National Semiconductor LM90,
> -	  LM86, LM89 and LM99, Analog Devices ADM1032 and ADT7461, Maxim
> -	  MAX6646, MAX6647, MAX6648, MAX6649, MAX6657, MAX6658, MAX6659,
> -	  MAX6680, MAX6681 and MAX6692, and Winbond/Nuvoton W83L771AWG/ASG
> -	  sensor chips.
> +	  LM86, LM89 and LM99, Analog Devices ADM1032 and ADT7461, and Maxim
> +	  MAX6646, MAX6647, MAX6649, MAX6657, MAX6658, MAX6659, MAX6680 and
> +	  MAX6681 sensor chips.
> 
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called lm90.
> @@ -601,37 +555,6 @@
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called lm93.
> 
> -config SENSORS_LTC4215
> -	tristate "Linear Technology LTC4215"
> -	depends on I2C && EXPERIMENTAL
> -	default n
> -	help
> -	  If you say yes here you get support for Linear Technology LTC4215
> -	  Hot Swap Controller I2C interface.
> -
> -	  This driver can also be built as a module. If so, the module will
> -	  be called ltc4215.
> -
> -config SENSORS_LTC4245
> -	tristate "Linear Technology LTC4245"
> -	depends on I2C && EXPERIMENTAL
> -	default n
> -	help
> -	  If you say yes here you get support for Linear Technology LTC4245
> -	  Multiple Supply Hot Swap Controller I2C interface.
> -
> -	  This driver can also be built as a module. If so, the module will
> -	  be called ltc4245.
> -
> -config SENSORS_LM95241
> -	tristate "National Semiconductor LM95241 sensor chip"
> -	depends on I2C
> -	help
> -	  If you say yes here you get support for LM95241 sensor chip.
> -
> -	  This driver can also be built as a module.  If so, the module
> -	  will be called lm95241.
> -
>  config SENSORS_MAX1111
>  	tristate "Maxim MAX1111 Multichannel, Serial 8-bit ADC chip"
>  	depends on SPI_MASTER
> @@ -686,47 +609,6 @@
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called pc87427.
> 
> -config SENSORS_PCF8591
> -	tristate "Philips PCF8591 ADC/DAC"
> -	depends on I2C
> -	default n
> -	help
> -	  If you say yes here you get support for Philips PCF8591 4-channel
> -	  ADC, 1-channel DAC chips.
> -
> -	  This driver can also be built as a module.  If so, the module
> -	  will be called pcf8591.
> -
> -	  These devices are hard to detect and rarely found on mainstream
> -	  hardware.  If unsure, say N.
> -
> -config SENSORS_SHT15
> -	tristate "Sensiron humidity and temperature sensors. SHT15 and compat."
> -	depends on GENERIC_GPIO
> -	help
> -	  If you say yes here you get support for the Sensiron SHT10, SHT11,
> -	  SHT15, SHT71, SHT75 humidity and temperature sensors.
> -
> -	  This driver can also be built as a module.  If so, the module
> -	  will be called sht15.
> -
> -config SENSORS_S3C
> -	tristate "S3C24XX/S3C64XX Inbuilt ADC"
> -	depends on ARCH_S3C2410
> -	help
> -	  If you say yes here you get support for the on-board ADCs of
> -	  the Samsung S3C24XX or S3C64XX series of SoC
> -
> -	  This driver can also be built as a module. If so, the module
> -	  will be called s3c-hwmo.
> -
> -config SENSORS_S3C_RAW
> -	bool "Include raw channel attributes in sysfs"
> -	depends on SENSORS_S3C
> -	help
> -	  Say Y here if you want to include raw copies of all the ADC
> -	  channels in sysfs.
> -
>  config SENSORS_SIS5595
>  	tristate "Silicon Integrated Systems Corp. SiS5595"
>  	depends on PCI
> @@ -802,16 +684,6 @@
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called ads7828.
> 
> -config SENSORS_AMC6821
> -	tristate "Texas Instruments AMC6821"
> -	depends on I2C  && EXPERIMENTAL
> -	help
> -	  If you say yes here you get support for the Texas Instruments
> -	  AMC6821 hardware monitoring chips.
> -
> -	  This driver can also be build as a module.  If so, the module
> -	  will be called amc6821.
> -
>  config SENSORS_THMC50
>  	tristate "Texas Instruments THMC50 / Analog Devices ADM1022"
>  	depends on I2C && EXPERIMENTAL
> @@ -822,34 +694,6 @@
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called thmc50.
> 
> -config SENSORS_TMP401
> -	tristate "Texas Instruments TMP401 and compatibles"
> -	depends on I2C && EXPERIMENTAL
> -	help
> -	  If you say yes here you get support for Texas Instruments TMP401 and
> -	  TMP411 temperature sensor chips.
> -
> -	  This driver can also be built as a module.  If so, the module
> -	  will be called tmp401.
> -
> -config SENSORS_TMP421
> -	tristate "Texas Instruments TMP421 and compatible"
> -	depends on I2C && EXPERIMENTAL
> -	help
> -	  If you say yes here you get support for Texas Instruments TMP421,
> -	  TMP422 and TMP423 temperature sensor chips.
> -
> -	  This driver can also be built as a module.  If so, the module
> -	  will be called tmp421.
> -
> -config SENSORS_VIA_CPUTEMP
> -	tristate "VIA CPU temperature sensor"
> -	depends on X86
> -	help
> -	  If you say yes here you get support for the temperature
> -	  sensor inside your CPU. Supported are all known variants of
> -	  the VIA C7 and Nano.
> -
>  config SENSORS_VIA686A
>  	tristate "VIA686A"
>  	depends on PCI
> @@ -896,7 +740,7 @@
> 
>  config SENSORS_W83791D
>  	tristate "Winbond W83791D"
> -	depends on I2C
> +	depends on I2C && EXPERIMENTAL
>  	select HWMON_VID
>  	help
>  	  If you say yes here you get support for the Winbond W83791D chip.
> @@ -919,8 +763,7 @@
>  	select HWMON_VID
>  	help
>  	  If you say yes here you get support for the Winbond W83793
> -	  hardware monitoring chip, including support for the integrated
> -	  watchdog.
> +	  hardware monitoring chip.
> 
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called w83793.
> @@ -958,7 +801,7 @@
>  	  will be called w83627hf.
> 
>  config SENSORS_W83627EHF
> -	tristate "Winbond W83627EHF/EHG/DHG, W83667HG"
> +	tristate "Winbond W83627EHF/DHG"
>  	select HWMON_VID
>  	help
>  	  If you say yes here you get support for the hardware
> @@ -969,32 +812,9 @@
>  	  chip suited for specific Intel processors that use PECI such as
>  	  the Core 2 Duo.
> 
> -	  This driver also supports the W83667HG chip.
> -
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called w83627ehf.
> 
> -config SENSORS_WM831X
> -	tristate "WM831x PMICs"
> -	depends on MFD_WM831X
> -	help
> -	  If you say yes here you get support for the hardware
> -	  monitoring functionality of the Wolfson Microelectronics
> -	  WM831x series of PMICs.
> -
> -	  This driver can also be built as a module.  If so, the module
> -	  will be called wm831x-hwmon.
> -
> -config SENSORS_WM8350
> -	tristate "Wolfson Microelectronics WM835x"
> -	depends on MFD_WM8350
> -	help
> -	  If you say yes here you get support for the hardware
> -	  monitoring features of the WM835x series of PMICs.
> -
> -	  This driver can also be built as a module.  If so, the module
> -	  will be called wm8350-hwmon.
> -
>  config SENSORS_ULTRA45
>  	tristate "Sun Ultra45 PIC16F747"
>  	depends on SPARC64
> @@ -1022,39 +842,24 @@
>  	  Say Y here if you have an applicable laptop and want to experience
>  	  the awesome power of hdaps.
> 
> -config SENSORS_LIS3_SPI
> -	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer (SPI)"
> -	depends on !ACPI && SPI_MASTER && INPUT
> -	select INPUT_POLLDEV
> +config SENSORS_LIS3LV02D
> +	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer"
> +	depends on ACPI && INPUT
>  	default n
>  	help
> -	  This driver provides support for the LIS3LV02Dx accelerometer connected
> -	  via SPI. The accelerometer data is readable via
> +	  This driver provides support for the LIS3LV02Dx accelerometer. In
> +	  particular, it can be found in a number of HP laptops, which have the
> +	  "Mobile Data Protection System 3D" or "3D DriveGuard" feature. On such
> +	  systems the driver should load automatically (via ACPI). The
> +	  accelerometer might also be found in other systems, connected via SPI
> +	  or I2C.  The accelerometer data is readable via
>  	  /sys/devices/platform/lis3lv02d.
> 
>  	  This driver also provides an absolute input class device, allowing
>  	  the laptop to act as a pinball machine-esque joystick.
> 
> -	  This driver can also be built as modules.  If so, the core module
> -	  will be called lis3lv02d and a specific module for the SPI transport
> -	  is called lis3lv02d_spi.
> -
> -config SENSORS_LIS3_I2C
> -	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer (I2C)"
> -	depends on I2C && INPUT
> -	select INPUT_POLLDEV
> -	default n
> -	help
> -	  This driver provides support for the LIS3LV02Dx accelerometer connected
> -	  via I2C. The accelerometer data is readable via
> -	  /sys/devices/platform/lis3lv02d.
> -
> -	  This driver also provides an absolute input class device, allowing
> -	  the device to act as a pinball machine-esque joystick.
> -
> -	  This driver can also be built as modules.  If so, the core module
> -	  will be called lis3lv02d and a specific module for the I2C transport
> -	  is called lis3lv02d_i2c.
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called lis3lv02d.
> 
>  config SENSORS_APPLESMC
>  	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
> @@ -1081,58 +886,13 @@
>  	  Say Y here if you have an applicable laptop and want to experience
>  	  the awesome power of applesmc.
> 
> -config SENSORS_MC13783_ADC
> -        tristate "Freescale MC13783 ADC"
> -        depends on MFD_MC13783
> -        help
> -          Support for the A/D converter on MC13783 PMIC.
> -
> -if ACPI
> -
> -comment "ACPI drivers"
> -
> -config SENSORS_ATK0110
> -	tristate "ASUS ATK0110"
> -	depends on X86 && EXPERIMENTAL
> -	help
> -	  If you say yes here you get support for the ACPI hardware
> -	  monitoring interface found in many ASUS motherboards. This
> -	  driver will provide readings of fans, voltages and temperatures
> -	  through the system firmware.
> -
> -	  This driver can also be built as a module. If so, the module
> -	  will be called asus_atk0110.
> -
> -config SENSORS_LIS3LV02D
> -	tristate "STMicroeletronics LIS3* three-axis digital accelerometer"
> -	depends on INPUT
> -	select INPUT_POLLDEV
> -	select NEW_LEDS
> -	select LEDS_CLASS
> +config HWMON_DEBUG_CHIP
> +	bool "Hardware Monitoring Chip debugging messages"
>  	default n
>  	help
> -	  This driver provides support for the LIS3* accelerometers, such as the
> -	  LIS3LV02DL or the LIS331DL. In particular, it can be found in a number
> -	  of HP laptops, which have the "Mobile Data Protection System 3D" or
> -	  "3D DriveGuard" feature. On such systems the driver should load
> -	  automatically (via ACPI alias). The accelerometer might also be found
> -	  in other systems, connected via SPI or I2C. The accelerometer data is
> -	  readable via /sys/devices/platform/lis3lv02d.
> -
> -	  This driver also provides an absolute input class device, allowing
> -	  a laptop to act as a pinball machine-esque joystick. It provides also
> -	  a misc device which can be used to detect free-fall. On HP laptops,
> -	  if the led infrastructure is activated, support for a led indicating
> -	  disk protection will be provided as hp::hddprotect. For more
> -	  information on the feature, refer to Documentation/hwmon/lis3lv02d.
> -
> -	  This driver can also be built as modules.  If so, the core module
> -	  will be called lis3lv02d and a specific module for HP laptops will be
> -	  called hp_accel.
> -
> -	  Say Y here if you have an applicable laptop and want to experience
> -	  the awesome power of lis3lv02d.
> -
> -endif # ACPI
> +	  Say Y here if you want the I2C chip drivers to produce a bunch of
> +	  debug messages to the system log.  Select this if you are having
> +	  a problem with I2C support and want to see more of what is going
> +	  on.
> 
>  endif # HWMON


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
