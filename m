Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab2ISP36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:29:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:41630 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab2ISP34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:29:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="146767425"
Date: Wed, 19 Sep 2012 17:29:57 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: larsi@wh2.tu-dresden.de
Cc: linux-kernel@vger.kernel.org, Lars Poeschel <poeschel@lemonage.de>
Subject: Re: [PATCH] mfd: viperboard driver added
Message-ID: <20120919152957.GF28670@sortiz-mobl>
References: <1346072918-3982-1-git-send-email-larsi@wh2.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346072918-3982-1-git-send-email-larsi@wh2.tu-dresden.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Mon, Aug 27, 2012 at 03:08:38PM +0200, larsi@wh2.tu-dresden.de wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> First version of the driver for Nano River Tech's
> viperboard added.
> It supports i2c, adc, gpio a and gpio b. spi and pwm on
> the first gpio a pins is not supported yet.
> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
>  drivers/mfd/Kconfig      |   17 +
>  drivers/mfd/Makefile     |    1 +
>  drivers/mfd/viperboard.c | 1084 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1102 insertions(+)
>  create mode 100644 drivers/mfd/viperboard.c
So the MFD driver contains a GPIO one, and an i2c bus driver.
You should really split this code into at least 3 pieces: 1 for the GPIO
(drivers/gpio), another one for your i2c bus algorithm (drivers/i2c/busses)
and a last one for the actual MFD driver. Your Kconfig entries will define the
dependencies between them.
Then you can define your SoC subdevices as MFD cells and use the MFD APIs to
add them as platform devices.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
