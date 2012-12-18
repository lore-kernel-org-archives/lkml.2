Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2LRR5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:57:41 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:33188 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2LRR5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:57:40 -0500
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 12:57:39 EST
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E0AAA1@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E0AAA1@DQHE02.ent.ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 18 Dec 2012 09:50:08 -0800
Message-ID: <CAK5ve-KcCbgcHSRiMX0t3vxXNk=BOXBVm=e820K=KLs5nGRzBg@mail.gmail.com>
Subject: Re: [PATCH 00/33] leds: cleanup LP5521/5523 LED driver
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim

This patchset looks good, but I need some time to review it more
carefully especially during this merge window + holiday time.

Thanks,
-Bryan

On Wed, Dec 12, 2012 at 5:59 AM, Kim, Milo <Milo.Kim@ti.com> wrote:
> LP5521, LP5523 and L55231 have common features as below.
>
>  Register access via the I2C.
>  Device initialization/de-initialization.
>  Create LED class devices for multiple output channels.
>  Device attributes for user-space interface.
>
> Therefore, this patch-set removes duplicate code for LP5521/5523 driver and
> makes coherent driver structure, named lp55xx.
>
> All patches have been tested in LP5521, LP5523 and LP55231 evaluation boards.
>
> You can also pull from the location below.
> This branch is based on 'for-next' branch of linux-leds.
>
>   https://github.com/milokim/lp55xx.git lp55xx
>
> Cleanups before adding new driver architecture
>   leds-lp55xx: cleanup init_device() in lp5521/5523
>   leds-lp55xx: cleanup deinit_device() in lp5521/5523
>   leds-lp55xx: cleanup init leds in lp5521/5523
>   leds-lp55xx: cleanup deinit leds in lp5521/5523
>   leds-lp55xx: add device reset function in lp5521/5523
>   leds-lp55xx: do chip specific configuration on device init
>
> Replace lp5521, lp5523 driver with new lp55xx driver architecture
>   leds-lp55xx: add new common driver for lp5521/5523
>   leds-lp55xx: replace name of data structure
>   leds-lp55xx: use common lp55xx data structure in _probe()
>   leds-lp55xx: use lp55xx common init function in _probe()
>   leds-lp55xx: use lp55xx common deinit function
>   leds-lp55xx: use lp55xx common led registration function
>   leds-lp55xx: use lp55xx_init_led() common function
>   leds-lp55xx: use lp55xx_set_brightness() for brightness control
>   leds-lp55xx: provide common LED current setting
>   leds-lp55xx: use lp55xx_unregister_leds()
>   leds-lp55xx: fix error condition in lp55xx_register_leds()
>   leds-lp55xx: add new lp55xx_register_sysfs() for FW interface
>
> Adding the firmware interface
>   leds-lp55xx: support firmware interface
>   leds-lp55xx: use generic firmware interface
>
> Cleanups lp5521, lp5523 device attributes
>   leds-lp55xx: support device specific attibutes
>   leds-lp55xx: use common driver function for adding attributes
>
> Others
>   leds-lp55xx: code refactoring on selftest function
>   leds-lp55xx: add unregister dev attr function
>   leds-lp55xx: clean up _remove()
>   leds-lp55xx: clean up unused data and functions
>   leds-lp55xx: clean up definitions
>   leds-lp55xx: clean up headers
>   leds-lp5521: recovers previous driver patch for return value
>   leds-lp5521/5523: use new lp55xx common header
>   leds-lp5521/5523: add author and copyright description
>   leds-lp55xx: fix problem on removing LED attributes
>   Documentation: leds: update LP55xx family devices
>
>  Documentation/leds/00-INDEX                  |    2 +
>  Documentation/leds/leds-lp5521.txt           |   63 +-
>  Documentation/leds/leds-lp5523.txt           |   27 +-
>  Documentation/leds/leds-lp55xx.txt           |  111 +++
>  arch/arm/mach-omap2/board-rx51-peripherals.c |    8 +-
>  arch/arm/mach-ux500/board-mop500.c           |   14 +-
>  drivers/leds/Kconfig                         |   15 +-
>  drivers/leds/Makefile                        |    1 +
>  drivers/leds/leds-lp5521.c                   |  944 +++++++----------------
>  drivers/leds/leds-lp5523.c                   | 1050 +++++++-------------------
>  drivers/leds/leds-lp55xx-common.c            |  519 +++++++++++++
>  drivers/leds/leds-lp55xx-common.h            |  133 ++++
>  include/linux/leds-lp5521.h                  |   73 --
>  include/linux/leds-lp5523.h                  |   49 --
>  include/linux/platform_data/leds-lp55xx.h    |   87 +++
>  15 files changed, 1410 insertions(+), 1686 deletions(-)
>  create mode 100644 Documentation/leds/leds-lp55xx.txt
>  create mode 100644 drivers/leds/leds-lp55xx-common.c
>  create mode 100644 drivers/leds/leds-lp55xx-common.h
>  delete mode 100644 include/linux/leds-lp5521.h
>  delete mode 100644 include/linux/leds-lp5523.h
>  create mode 100644 include/linux/platform_data/leds-lp55xx.h
>
> --
> 1.7.9.5
>
> Best Regards,
> Milo
>
