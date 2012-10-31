Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2JaHMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:12:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:50867 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab2JaHMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:12:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,685,1344236400"; 
   d="scan'208";a="162737847"
Date: Wed, 31 Oct 2012 15:12:36 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] gpio: move those interface depends on GPIOLIB into
 proper section
Message-ID: <20121031071236.GA13393@localhost>
References: <1351666855-23854-1-git-send-email-yuanhan.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351666855-23854-1-git-send-email-yuanhan.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 03:00:54PM +0800, Yuanhan Liu wrote:
> There are 2 issues with current code:
> 
> 1. redefinition of 'gpio_cansleep':
> include/linux/gpio.h:60:19: error: redefinition of 'gpio_cansleep'
> include/asm-generic/gpio.h:212:19: note: previous definition of 'gpio_cansleep' was here
> 
> The root cause is include/linux/gpio.h has a defintion of it. And if
> CONFIG_GPIOLIB is not set, include/asm-generic/gpio.h has another
> definition.
> 
> 2. include/linux/gpio.h:62:2: error: implicit declaration of function '__gpio_cansleep'
> 
> Only happens when CONFIG_GPIOLIB is not set, too. Since it called
> gpiolib functions without putting something like: #ifdef CONFIG_GPIOLIB
> 
> So, move those functions into proper section at
> include/asm-generic/gpio.h would resolve 2 above issues.

The patch introduces new build errors:

yuanhan:gpio-fixes [2/2] db1a5a0 blackfin-BF526-EZBRD_defconfig

[error]
arch/blackfin/include/asm/gpio.h:197:19: error: redefinition of 'gpio_get_value'
arch/blackfin/include/asm/gpio.h:205:20: error: redefinition of 'gpio_set_value'
arch/blackfin/include/asm/gpio.h:213:19: error: redefinition of 'gpio_cansleep'
arch/blackfin/include/asm/gpio.h:218:19: error: redefinition of 'gpio_to_irq'

yuanhan:gpio-fixes [2/2] db1a5a0 blackfin-TCM-BF537_defconfig

[error]
include/asm-generic/gpio.h:225:19: error: redefinition of 'gpio_get_value'
include/asm-generic/gpio.h:231:20: error: redefinition of 'gpio_set_value'
include/asm-generic/gpio.h:242:19: error: redefinition of 'gpio_to_irq'

yuanhan:gpio-fixes [2/2] db1a5a0 sh-rsk7269_defconfig

[error]
arch/sh/include/asm/gpio.h:27:19: error: redefinition of 'gpio_get_value'
arch/sh/include/asm/gpio.h:32:20: error: redefinition of 'gpio_set_value'
arch/sh/include/asm/gpio.h:37:19: error: redefinition of 'gpio_cansleep'
arch/sh/include/asm/gpio.h:42:19: error: redefinition of 'gpio_to_irq'

yuanhan:gpio-fixes [2/2] db1a5a0 avr32-atngw100_defconfig

[error]
arch/avr32/mach-at32ap/include/mach/gpio.h:18: error: redefinition of 'gpio_get_value'
include/asm-generic/gpio.h:203: error: previous definition of 'gpio_get_value' was here
arch/avr32/mach-at32ap/include/mach/gpio.h:23: error: redefinition of 'gpio_set_value'
include/asm-generic/gpio.h:208: error: previous definition of 'gpio_set_value' was here
arch/avr32/mach-at32ap/include/mach/gpio.h:28: error: redefinition of 'gpio_cansleep'
include/asm-generic/gpio.h:213: error: previous definition of 'gpio_cansleep' was here
arch/avr32/mach-at32ap/include/mach/gpio.h:34: error: redefinition of 'gpio_to_irq'
include/asm-generic/gpio.h:218: error: previous definition of 'gpio_to_irq' was here

Thanks,
Fengguang
