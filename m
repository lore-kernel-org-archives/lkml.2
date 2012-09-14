Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab2INHxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:53:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50256 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab2INHxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:53:13 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-leds@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        fabio.baltieri@gmail.com, shuahkhan@gmail.com, raph@8d.com,
        tpiepho@freescale.com
Subject: [RFC] [PATCH 0/2] leds: use workqueue in led_set_brightness() API internally
Date: Fri, 14 Sep 2012 15:53:01 +0800
Message-Id: <1347609183-26730-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LED class drivers use duplicated workqueue method to implement
.brightness_set() and some of them forget to use workqueue, since
workqueue is required by .brightness_set() in atomic context.

This patchset add workqueue into API function led_set_brightness().
So class drivers don't need to worry about it.

With the first patch, we can remove all the workqueue handling code in
class drivers. For example, workqueue was removed from leds-gpio.c

Bryan Wu (2):
  leds: use workqueue in led_set_brightness() API internally
  leds-gpio: remove workqueue in .brightness_set()

 drivers/leds/led-class.c          | 23 +++++++++++----------
 drivers/leds/led-core.c           | 15 +++++++-------
 drivers/leds/leds-gpio.c          | 43 ++++++---------------------------------
 drivers/leds/leds.h               | 11 ++--------
 drivers/leds/ledtrig-backlight.c  |  8 ++++----
 drivers/leds/ledtrig-default-on.c |  2 +-
 drivers/leds/ledtrig-gpio.c       |  6 +++---
 drivers/leds/ledtrig-heartbeat.c  |  2 +-
 drivers/leds/ledtrig-oneshot.c    |  4 ++--
 drivers/leds/ledtrig-transient.c  |  8 ++++----
 include/linux/leds.h              | 12 ++++++-----
 11 files changed, 49 insertions(+), 85 deletions(-)

-- 
1.7.11.4

