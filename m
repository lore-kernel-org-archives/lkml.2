Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab0EJW3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:29:10 -0400
Received: from mga10.intel.com ([192.55.52.92]:14538 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757082Ab0EJW3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:29:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,202,1272870000"; 
   d="scan'208";a="565916306"
Date: Tue, 11 May 2010 00:29:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
       Mattias Wallin <mattias.wallin@stericsson.com>
Subject: Re: [PATCH 1/4] MFD: renamed ab3100.h to abx500.h v2
Message-ID: <20100510222942.GA3288@sortiz.org>
References: <1272731167-29704-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272731167-29704-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sat, May 01, 2010 at 06:26:07PM +0200, Linus Walleij wrote:
> The goal here is to make way for a more general interface for the
> analog baseband chips ab3100 ab3550 ab550 and future chips.
> 
> This patch have been divided into two parts since both changing name
> and content of a file is not recommended in git.
Patch applied, thanks a lot.


> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> No changes since v1, included for completeness.
> ---
>  arch/arm/mach-u300/i2c.c   |    2 +-
>  drivers/mfd/ab3100-core.c  |    2 +-
>  drivers/mfd/ab3100-otp.c   |    2 +-
>  drivers/regulator/ab3100.c |    2 +-
>  drivers/rtc/rtc-ab3100.c   |    2 +-
>  include/linux/mfd/ab3100.h |  129 --------------------------------------------
>  include/linux/mfd/abx500.h |  129 ++++++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 134 insertions(+), 134 deletions(-)
>  delete mode 100644 include/linux/mfd/ab3100.h
>  create mode 100644 include/linux/mfd/abx500.h
> 
> diff --git a/arch/arm/mach-u300/i2c.c b/arch/arm/mach-u300/i2c.c
> index c73ed06..d893ee0 100644
> --- a/arch/arm/mach-u300/i2c.c
> +++ b/arch/arm/mach-u300/i2c.c
> @@ -9,7 +9,7 @@
>   */
>  #include <linux/kernel.h>
>  #include <linux/i2c.h>
> -#include <linux/mfd/ab3100.h>
> +#include <linux/mfd/abx500.h>
>  #include <linux/regulator/machine.h>
>  #include <linux/amba/bus.h>
>  #include <mach/irqs.h>
> diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
> index 1689821..f8c4a33 100644
> --- a/drivers/mfd/ab3100-core.c
> +++ b/drivers/mfd/ab3100-core.c
> @@ -19,7 +19,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
>  #include <linux/uaccess.h>
> -#include <linux/mfd/ab3100.h>
> +#include <linux/mfd/abx500.h>
>  
>  /* These are the only registers inside AB3100 used in this main file */
>  
> diff --git a/drivers/mfd/ab3100-otp.c b/drivers/mfd/ab3100-otp.c
> index 2d14655..7093f1a 100644
> --- a/drivers/mfd/ab3100-otp.c
> +++ b/drivers/mfd/ab3100-otp.c
> @@ -12,7 +12,7 @@
>  #include <linux/slab.h>
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
> -#include <linux/mfd/ab3100.h>
> +#include <linux/mfd/abx500.h>
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
>  
> diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
> index 7de9509..1b8b0ab 100644
> --- a/drivers/regulator/ab3100.c
> +++ b/drivers/regulator/ab3100.c
> @@ -16,7 +16,7 @@
>  #include <linux/delay.h>
>  #include <linux/platform_device.h>
>  #include <linux/regulator/driver.h>
> -#include <linux/mfd/ab3100.h>
> +#include <linux/mfd/abx500.h>
>  
>  /* LDO registers and some handy masking definitions for AB3100 */
>  #define AB3100_LDO_A		0x40
> diff --git a/drivers/rtc/rtc-ab3100.c b/drivers/rtc/rtc-ab3100.c
> index 4704aac..b46b85d 100644
> --- a/drivers/rtc/rtc-ab3100.c
> +++ b/drivers/rtc/rtc-ab3100.c
> @@ -9,7 +9,7 @@
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/rtc.h>
> -#include <linux/mfd/ab3100.h>
> +#include <linux/mfd/abx500.h>
>  
>  /* Clock rate in Hz */
>  #define AB3100_RTC_CLOCK_RATE	32768
> diff --git a/include/linux/mfd/ab3100.h b/include/linux/mfd/ab3100.h
> deleted file mode 100644
> index 9a881c3..0000000
> --- a/include/linux/mfd/ab3100.h
> +++ /dev/null
> @@ -1,129 +0,0 @@
> -/*
> - * Copyright (C) 2007-2009 ST-Ericsson AB
> - * License terms: GNU General Public License (GPL) version 2
> - * AB3100 core access functions
> - * Author: Linus Walleij <linus.walleij@stericsson.com>
> - */
> -
> -#include <linux/device.h>
> -#include <linux/regulator/machine.h>
> -
> -#ifndef MFD_AB3100_H
> -#define MFD_AB3100_H
> -
> -#define ABUNKNOWN	0
> -#define	AB3000		1
> -#define	AB3100		2
> -
> -/*
> - * AB3100, EVENTA1, A2 and A3 event register flags
> - * these are catenated into a single 32-bit flag in the code
> - * for event notification broadcasts.
> - */
> -#define AB3100_EVENTA1_ONSWA				(0x01<<16)
> -#define AB3100_EVENTA1_ONSWB				(0x02<<16)
> -#define AB3100_EVENTA1_ONSWC				(0x04<<16)
> -#define AB3100_EVENTA1_DCIO				(0x08<<16)
> -#define AB3100_EVENTA1_OVER_TEMP			(0x10<<16)
> -#define AB3100_EVENTA1_SIM_OFF				(0x20<<16)
> -#define AB3100_EVENTA1_VBUS				(0x40<<16)
> -#define AB3100_EVENTA1_VSET_USB				(0x80<<16)
> -
> -#define AB3100_EVENTA2_READY_TX				(0x01<<8)
> -#define AB3100_EVENTA2_READY_RX				(0x02<<8)
> -#define AB3100_EVENTA2_OVERRUN_ERROR			(0x04<<8)
> -#define AB3100_EVENTA2_FRAMING_ERROR			(0x08<<8)
> -#define AB3100_EVENTA2_CHARG_OVERCURRENT		(0x10<<8)
> -#define AB3100_EVENTA2_MIDR				(0x20<<8)
> -#define AB3100_EVENTA2_BATTERY_REM			(0x40<<8)
> -#define AB3100_EVENTA2_ALARM				(0x80<<8)
> -
> -#define AB3100_EVENTA3_ADC_TRIG5			(0x01)
> -#define AB3100_EVENTA3_ADC_TRIG4			(0x02)
> -#define AB3100_EVENTA3_ADC_TRIG3			(0x04)
> -#define AB3100_EVENTA3_ADC_TRIG2			(0x08)
> -#define AB3100_EVENTA3_ADC_TRIGVBAT			(0x10)
> -#define AB3100_EVENTA3_ADC_TRIGVTX			(0x20)
> -#define AB3100_EVENTA3_ADC_TRIG1			(0x40)
> -#define AB3100_EVENTA3_ADC_TRIG0			(0x80)
> -
> -/* AB3100, STR register flags */
> -#define AB3100_STR_ONSWA				(0x01)
> -#define AB3100_STR_ONSWB				(0x02)
> -#define AB3100_STR_ONSWC				(0x04)
> -#define AB3100_STR_DCIO					(0x08)
> -#define AB3100_STR_BOOT_MODE				(0x10)
> -#define AB3100_STR_SIM_OFF				(0x20)
> -#define AB3100_STR_BATT_REMOVAL				(0x40)
> -#define AB3100_STR_VBUS					(0x80)
> -
> -/*
> - * AB3100 contains 8 regulators, one external regulator controller
> - * and a buck converter, further the LDO E and buck converter can
> - * have separate settings if they are in sleep mode, this is
> - * modeled as a separate regulator.
> - */
> -#define AB3100_NUM_REGULATORS				10
> -
> -/**
> - * struct ab3100
> - * @access_mutex: lock out concurrent accesses to the AB3100 registers
> - * @dev: pointer to the containing device
> - * @i2c_client: I2C client for this chip
> - * @testreg_client: secondary client for test registers
> - * @chip_name: name of this chip variant
> - * @chip_id: 8 bit chip ID for this chip variant
> - * @event_subscribers: event subscribers are listed here
> - * @startup_events: a copy of the first reading of the event registers
> - * @startup_events_read: whether the first events have been read
> - *
> - * This struct is PRIVATE and devices using it should NOT
> - * access ANY fields. It is used as a token for calling the
> - * AB3100 functions.
> - */
> -struct ab3100 {
> -	struct mutex access_mutex;
> -	struct device *dev;
> -	struct i2c_client *i2c_client;
> -	struct i2c_client *testreg_client;
> -	char chip_name[32];
> -	u8 chip_id;
> -	struct blocking_notifier_head event_subscribers;
> -	u32 startup_events;
> -	bool startup_events_read;
> -};
> -
> -/**
> - * struct ab3100_platform_data
> - * Data supplied to initialize board connections to the AB3100
> - * @reg_constraints: regulator constraints for target board
> - *     the order of these constraints are: LDO A, C, D, E,
> - *     F, G, H, K, EXT and BUCK.
> - * @reg_initvals: initial values for the regulator registers
> - *     plus two sleep settings for LDO E and the BUCK converter.
> - *     exactly AB3100_NUM_REGULATORS+2 values must be sent in.
> - *     Order: LDO A, C, E, E sleep, F, G, H, K, EXT, BUCK,
> - *     BUCK sleep, LDO D. (LDO D need to be initialized last.)
> - * @external_voltage: voltage level of the external regulator.
> - */
> -struct ab3100_platform_data {
> -	struct regulator_init_data reg_constraints[AB3100_NUM_REGULATORS];
> -	u8 reg_initvals[AB3100_NUM_REGULATORS+2];
> -	int external_voltage;
> -};
> -
> -int ab3100_set_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 regval);
> -int ab3100_get_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 *regval);
> -int ab3100_get_register_page_interruptible(struct ab3100 *ab3100,
> -			     u8 first_reg, u8 *regvals, u8 numregs);
> -int ab3100_mask_and_set_register_interruptible(struct ab3100 *ab3100,
> -				 u8 reg, u8 andmask, u8 ormask);
> -u8 ab3100_get_chip_type(struct ab3100 *ab3100);
> -int ab3100_event_register(struct ab3100 *ab3100,
> -			  struct notifier_block *nb);
> -int ab3100_event_unregister(struct ab3100 *ab3100,
> -			    struct notifier_block *nb);
> -int ab3100_event_registers_startup_state_get(struct ab3100 *ab3100,
> -					     u32 *fatevent);
> -
> -#endif
> diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
> new file mode 100644
> index 0000000..9a881c3
> --- /dev/null
> +++ b/include/linux/mfd/abx500.h
> @@ -0,0 +1,129 @@
> +/*
> + * Copyright (C) 2007-2009 ST-Ericsson AB
> + * License terms: GNU General Public License (GPL) version 2
> + * AB3100 core access functions
> + * Author: Linus Walleij <linus.walleij@stericsson.com>
> + */
> +
> +#include <linux/device.h>
> +#include <linux/regulator/machine.h>
> +
> +#ifndef MFD_AB3100_H
> +#define MFD_AB3100_H
> +
> +#define ABUNKNOWN	0
> +#define	AB3000		1
> +#define	AB3100		2
> +
> +/*
> + * AB3100, EVENTA1, A2 and A3 event register flags
> + * these are catenated into a single 32-bit flag in the code
> + * for event notification broadcasts.
> + */
> +#define AB3100_EVENTA1_ONSWA				(0x01<<16)
> +#define AB3100_EVENTA1_ONSWB				(0x02<<16)
> +#define AB3100_EVENTA1_ONSWC				(0x04<<16)
> +#define AB3100_EVENTA1_DCIO				(0x08<<16)
> +#define AB3100_EVENTA1_OVER_TEMP			(0x10<<16)
> +#define AB3100_EVENTA1_SIM_OFF				(0x20<<16)
> +#define AB3100_EVENTA1_VBUS				(0x40<<16)
> +#define AB3100_EVENTA1_VSET_USB				(0x80<<16)
> +
> +#define AB3100_EVENTA2_READY_TX				(0x01<<8)
> +#define AB3100_EVENTA2_READY_RX				(0x02<<8)
> +#define AB3100_EVENTA2_OVERRUN_ERROR			(0x04<<8)
> +#define AB3100_EVENTA2_FRAMING_ERROR			(0x08<<8)
> +#define AB3100_EVENTA2_CHARG_OVERCURRENT		(0x10<<8)
> +#define AB3100_EVENTA2_MIDR				(0x20<<8)
> +#define AB3100_EVENTA2_BATTERY_REM			(0x40<<8)
> +#define AB3100_EVENTA2_ALARM				(0x80<<8)
> +
> +#define AB3100_EVENTA3_ADC_TRIG5			(0x01)
> +#define AB3100_EVENTA3_ADC_TRIG4			(0x02)
> +#define AB3100_EVENTA3_ADC_TRIG3			(0x04)
> +#define AB3100_EVENTA3_ADC_TRIG2			(0x08)
> +#define AB3100_EVENTA3_ADC_TRIGVBAT			(0x10)
> +#define AB3100_EVENTA3_ADC_TRIGVTX			(0x20)
> +#define AB3100_EVENTA3_ADC_TRIG1			(0x40)
> +#define AB3100_EVENTA3_ADC_TRIG0			(0x80)
> +
> +/* AB3100, STR register flags */
> +#define AB3100_STR_ONSWA				(0x01)
> +#define AB3100_STR_ONSWB				(0x02)
> +#define AB3100_STR_ONSWC				(0x04)
> +#define AB3100_STR_DCIO					(0x08)
> +#define AB3100_STR_BOOT_MODE				(0x10)
> +#define AB3100_STR_SIM_OFF				(0x20)
> +#define AB3100_STR_BATT_REMOVAL				(0x40)
> +#define AB3100_STR_VBUS					(0x80)
> +
> +/*
> + * AB3100 contains 8 regulators, one external regulator controller
> + * and a buck converter, further the LDO E and buck converter can
> + * have separate settings if they are in sleep mode, this is
> + * modeled as a separate regulator.
> + */
> +#define AB3100_NUM_REGULATORS				10
> +
> +/**
> + * struct ab3100
> + * @access_mutex: lock out concurrent accesses to the AB3100 registers
> + * @dev: pointer to the containing device
> + * @i2c_client: I2C client for this chip
> + * @testreg_client: secondary client for test registers
> + * @chip_name: name of this chip variant
> + * @chip_id: 8 bit chip ID for this chip variant
> + * @event_subscribers: event subscribers are listed here
> + * @startup_events: a copy of the first reading of the event registers
> + * @startup_events_read: whether the first events have been read
> + *
> + * This struct is PRIVATE and devices using it should NOT
> + * access ANY fields. It is used as a token for calling the
> + * AB3100 functions.
> + */
> +struct ab3100 {
> +	struct mutex access_mutex;
> +	struct device *dev;
> +	struct i2c_client *i2c_client;
> +	struct i2c_client *testreg_client;
> +	char chip_name[32];
> +	u8 chip_id;
> +	struct blocking_notifier_head event_subscribers;
> +	u32 startup_events;
> +	bool startup_events_read;
> +};
> +
> +/**
> + * struct ab3100_platform_data
> + * Data supplied to initialize board connections to the AB3100
> + * @reg_constraints: regulator constraints for target board
> + *     the order of these constraints are: LDO A, C, D, E,
> + *     F, G, H, K, EXT and BUCK.
> + * @reg_initvals: initial values for the regulator registers
> + *     plus two sleep settings for LDO E and the BUCK converter.
> + *     exactly AB3100_NUM_REGULATORS+2 values must be sent in.
> + *     Order: LDO A, C, E, E sleep, F, G, H, K, EXT, BUCK,
> + *     BUCK sleep, LDO D. (LDO D need to be initialized last.)
> + * @external_voltage: voltage level of the external regulator.
> + */
> +struct ab3100_platform_data {
> +	struct regulator_init_data reg_constraints[AB3100_NUM_REGULATORS];
> +	u8 reg_initvals[AB3100_NUM_REGULATORS+2];
> +	int external_voltage;
> +};
> +
> +int ab3100_set_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 regval);
> +int ab3100_get_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 *regval);
> +int ab3100_get_register_page_interruptible(struct ab3100 *ab3100,
> +			     u8 first_reg, u8 *regvals, u8 numregs);
> +int ab3100_mask_and_set_register_interruptible(struct ab3100 *ab3100,
> +				 u8 reg, u8 andmask, u8 ormask);
> +u8 ab3100_get_chip_type(struct ab3100 *ab3100);
> +int ab3100_event_register(struct ab3100 *ab3100,
> +			  struct notifier_block *nb);
> +int ab3100_event_unregister(struct ab3100 *ab3100,
> +			    struct notifier_block *nb);
> +int ab3100_event_registers_startup_state_get(struct ab3100 *ab3100,
> +					     u32 *fatevent);
> +
> +#endif
> -- 
> 1.7.0.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
