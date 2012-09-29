Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2I2Jm7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 05:42:59 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38460 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2I2Jm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 05:42:56 -0400
Message-ID: <5066C29D.7040009@kernel.org>
Date: Sat, 29 Sep 2012 10:42:53 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Patil, Rachna" <rachna@ti.com>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH v4 0/5] Support for TSC/ADC MFD driver
References: <1348636814-14129-1-git-send-email-rachna@ti.com>
In-Reply-To: <1348636814-14129-1-git-send-email-rachna@ti.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 06:20 AM, Patil, Rachna wrote:
> This patch set adds a MFD core driver which registers
> touchscreen and ADC as its client drivers.
> The existing touchscreen has been modified to work as
> a MFD client driver and a new ADC driver has been added
> in the IIO subsystem.
> 
> There are 8 analog input lines, which can be used as:
> 1. 8 general purpose ADC channels
> 2. 4 wire TS, with 4 general purpose ADC channels
> 3. 5 wire TS, with 3 general purpose ADC channels
> 
> This patch set has been tested on AM335x EVM.
> 
> These set of patches are based on top of Touchscreen patch
> set submitted.
> Subject: [PATCH 0/4] input: TSC: ti_tscadc: TI Touchscreen driver updates [1]
> 
> [1] http://www.spinics.net/lists/linux-input/msg22107.html
which tree have these merged in?

I'll assume the rest of this is going through the same tree and ack
rather than signing off and taking it through IIO.

Note that patch 1 does not appear to apply to linux-next which implies some
issues somewhere or that the above series has been picked up for any
trees feeding linux-next as yet.
> 
> Changes in v2:
> 	Dropped one patch send in the last version after
> 	receiving internal comments. I have merged the changes
> 	into existing patches.
> 	Also added a new patch to support suspend/resume feature.
> 	Fixed review comments by Matthias Kaehlcke.
> 
> Changes in v3:
> 	Addressed review comments by Jonathan Cameron.
> 	Improved ADC driver with more readable labels,
> 	spaces and comments.
> 
> Changes in v4:
> 	Renamed the drivers from ti_xxx to ti_am335x_xxx.
> 	For consistency with other drivers renamed idev to indio_dev
> 	in IIO ADC driver.
> 	Replaced suspend/resume callbacks with dev_pm_ops.
> 
> Patil, Rachna (5):
>   input: TSC: ti_tscadc: Rename the existing touchscreen driver
>   MFD: ti_tscadc: Add support for TI's TSC/ADC MFDevice
>   input: TSC: ti_tsc: Convert TSC into a MFDevice
>   IIO : ADC: tiadc: Add support of TI's ADC driver
>   MFD: ti_tscadc: add suspend/resume functionality
> 
>  drivers/iio/adc/Kconfig                            |    7 +
>  drivers/iio/adc/Makefile                           |    1 +
>  drivers/iio/adc/ti_am335x_adc.c                    |  258 ++++++++++++++++
>  drivers/input/touchscreen/Kconfig                  |    4 +-
>  drivers/input/touchscreen/Makefile                 |    2 +-
>  .../touchscreen/{ti_tscadc.c => ti_am335x_tsc.c}   |  319 ++++++--------------
>  drivers/mfd/Kconfig                                |    9 +
>  drivers/mfd/Makefile                               |    1 +
>  drivers/mfd/ti_am335x_tscadc.c                     |  259 ++++++++++++++++
>  .../linux/input/{ti_tscadc.h => ti_am335x_tsc.h}   |    4 +-
>  include/linux/mfd/ti_am335x_tscadc.h               |  151 +++++++++
>  include/linux/platform_data/ti_am335x_adc.h        |   14 +
>  12 files changed, 801 insertions(+), 228 deletions(-)
>  create mode 100644 drivers/iio/adc/ti_am335x_adc.c
>  rename drivers/input/touchscreen/{ti_tscadc.c => ti_am335x_tsc.c} (55%)
>  create mode 100644 drivers/mfd/ti_am335x_tscadc.c
>  rename include/linux/input/{ti_tscadc.h => ti_am335x_tsc.h} (88%)
>  create mode 100644 include/linux/mfd/ti_am335x_tscadc.h
>  create mode 100644 include/linux/platform_data/ti_am335x_adc.h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
