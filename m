Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab2ISREq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:04:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:3230 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab2ISREo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:04:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,450,1344236400"; 
   d="scan'208";a="224046395"
Date: Wed, 19 Sep 2012 19:04:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] mfd: add new lp8788 driver
Message-ID: <20120919170441.GQ28670@sortiz-mobl>
References: <A874F61F95741C4A9BA573A70FE3998F41EF4501@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF4501@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

On Fri, Sep 07, 2012 at 08:51:50AM +0000, Kim, Milo wrote:
>  TI LP8788 PMU provides regulators, battery charger, ADC,
>  RTC, backlight driver and current sinks.
> 
>  This MFD patch supports the I2C communication using the regmap,
>  the interrupt handling using the linear IRQ domain and
>  configurable platform data structures for each driver module.
> 
>  (Driver Architecture)
> 
>                                          < mfd devices >
>   LP8788 HW  ..........  mfd  .......... regulator drivers
>                 I2C                      power supply driver
>                 IRQs                     iio adc driver
>                                          rtc driver
>                                          backlight driver
>                                          current sink drivers
> 
>   o regulators    : LDOs and BUCKs
>   o power supply  : Battery charger
>   o iio adc       : Battery voltage/temperature
>   o rtc           : RTC and alarm
>   o backlight
>   o current sink  : LED and vibrator
> 
>  All MFD device modules are registered by LP8788 MFD core driver.
>  For sharing information such like the virtual IRQ number,
>  MFD core driver uses the resource structure.
>  Then each module can retrieve the specific IRQ number and detect it
>  in the IRQ thread.
> 
>  Configurable platform data is handled in each driver module.
> 
>  (History)
> 
>  Patch v4.
>  ADC platform data change : pointer array -> simple pointer
> 
>  Patch v3.
>  Use linear IRQ domain rather than old generic IRQ.
> 
>  Patch v2.
>  Use generic IRQ for interrupt handling.
>  Remove ADC exported functions. moved to new iio adc driver.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/mfd/Kconfig              |   10 ++
>  drivers/mfd/Makefile             |    2 +
>  drivers/mfd/lp8788-irq.c         |  197 +++++++++++++++++++++
>  drivers/mfd/lp8788.c             |  245 +++++++++++++++++++++++++
>  include/linux/mfd/lp8788-isink.h |   52 ++++++
>  include/linux/mfd/lp8788.h       |  364 ++++++++++++++++++++++++++++++++++++++
>  6 files changed, 870 insertions(+)
>  create mode 100644 drivers/mfd/lp8788-irq.c
>  create mode 100644 drivers/mfd/lp8788.c
>  create mode 100644 include/linux/mfd/lp8788-isink.h
>  create mode 100644 include/linux/mfd/lp8788.h
This is applied to my for-next branch now, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
