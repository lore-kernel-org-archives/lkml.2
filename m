Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934898Ab2J3Wts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:49:48 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59827 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab2J3Wtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:49:46 -0400
MIME-Version: 1.0
Date: Tue, 30 Oct 2012 23:49:45 +0100
Message-ID: <CACRpkdZRb-RjYDdgDpGFXSLhwSC+0e5Dy=EE2Atmiwyewa-D+Q@mail.gmail.com>
Subject: [GIT PULL] GPIO fixes for v3.7
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Andrew Lunn <andrew@lunn.ch>, Dan Carpenter <dan.carpenter@oracle.com>,
        Jon Hunter <jon-hunter@ti.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Roland Stigge <stigge@antcom.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a set of GPIO fixes accumulated since -rc1 that have been
trickling in. Condensed description of the contents is in the tag.

Please pull them in!

Yours,
Linus Walleij


The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-fixes-v3.7-rc4

for you to fetch changes up to 8fcff5f13773aa3898df1d13a1615d468079cb15:

  GPIO: mvebu-gpio: Don't initialize the mask_cache (2012-10-30 22:34:20 +0100)

----------------------------------------------------------------
Some GPIO fixes for the v3.7 series since -rc1:
- Fix a potential bit wrap issue in the Timberdale driver
- Fix up the buffer allocation size in the 74x164 driver
- Set the value in direction_output() right in the mvebu driver
- Return proper error codes for invalid GPIOs
- Fix an off-mode bug for the OMAP
- Don't initialized the mask_cach on the mvebu driver

----------------------------------------------------------------
Andrew Lunn (1):
      GPIO: mvebu-gpio: Don't initialize the mask_cache

Dan Carpenter (1):
      gpio-timberdale: fix a potential wrapping issue

Jon Hunter (1):
      gpio/omap: fix off-mode bug: clear debounce settings on free/reset

Mathias Nyman (1):
      gpiolib: Don't return -EPROBE_DEFER to sysfs, or for invalid gpios

Roland Stigge (1):
      gpio-74x164: Fix buffer allocation size

Thomas Petazzoni (1):
      gpio: mvebu: correctly set the value in direction_output()

 drivers/gpio/gpio-74x164.c     |  2 +-
 drivers/gpio/gpio-mvebu.c      |  4 +++-
 drivers/gpio/gpio-omap.c       | 35 +++++++++++++++++++++++++++++++++++
 drivers/gpio/gpio-timberdale.c |  4 ++--
 drivers/gpio/gpiolib.c         | 10 +++++++---
 5 files changed, 48 insertions(+), 7 deletions(-)
