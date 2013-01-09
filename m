Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3AILPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:15:36 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:33326 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3AILPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:15:34 -0500
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 0/3] Add and use new macro module_platform_driver_probe()
Date: Wed,  9 Jan 2013 12:15:25 +0100
Message-Id: <1357730128-23018-1-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For simple modules that contain a single platform_driver without any
additional setup code then ends up being a block of duplicated
boilerplate.  This patch adds a new macro,
module_platform_driver_probe(), which replaces the
module_init()/module_exit() registrations with template functions.
    
This macro use the same idea of module_platform_driver().
    
This macro is useful to stop the misuse of module_platform_driver() for
removing the platform_driver_probe() boilerplate.

Convert drivers/usb/* and drivers/watchdog/* to use
module_platform_driver_probe().

Best regards

Fabio Porcedda (3):
  driver core: add helper macro for platform_driver_probe() boilerplate
  watchdog: convert drivers/watchdog/* to use
    module_platform_driver_probe
  usb: converto drivers/usb/* to use module_platform_driver_probe()

 drivers/usb/gadget/at91_udc.c       | 12 +-----------
 drivers/usb/gadget/atmel_usba_udc.c | 12 +-----------
 drivers/usb/gadget/fusb300_udc.c    | 13 +------------
 drivers/usb/gadget/imx_udc.c        | 12 +-----------
 drivers/usb/gadget/lpc32xx_udc.c    | 12 +-----------
 drivers/usb/gadget/m66592-udc.c     | 12 +-----------
 drivers/usb/gadget/pxa25x_udc.c     | 15 +++------------
 drivers/usb/gadget/r8a66597-udc.c   | 15 ++-------------
 drivers/usb/otg/gpio_vbus.c         | 12 +-----------
 drivers/usb/otg/msm_otg.c           | 13 +------------
 drivers/watchdog/at32ap700x_wdt.c   | 12 +-----------
 drivers/watchdog/at91sam9_wdt.c     | 13 +------------
 drivers/watchdog/coh901327_wdt.c    | 12 +-----------
 drivers/watchdog/imx2_wdt.c         | 12 +-----------
 drivers/watchdog/txx9wdt.c          | 13 +------------
 include/linux/platform_device.h     | 18 ++++++++++++++++++
 16 files changed, 36 insertions(+), 172 deletions(-)

-- 
1.8.0.3

