Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab0FJFkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:40:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41158 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab0FJFkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:40:45 -0400
Subject: [PATCH v2 0/5] Generalize OF gpio support code
To: dbrownell@users.sourceforge.net, avorontsov@ru.mvista.com
From: Grant Likely <grant.likely@secretlab.ca>
Cc: bgat@billgatliff.com, dbaryshkov@gmail.com, benh@kernel.crashing.org,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org
Date: Wed, 09 Jun 2010 23:40:41 -0600
Message-ID: <20100610053439.16716.53944.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series makes all gpio drivers usable from the OF support apis by
automatically registering a default OF translator when the of_node
pointer is assigned.  These patches are heavily based on the work that
Anton did earlier, but I didn't add the notifiers infrastructure and
the OF data now lives directly inside the core gpio_chip structure so
that fewer gymnastics are needed to get at it.

These patches are currently sitting in the following branch:

git://git.secretlab.ca/git/linux-2.6 next-devicetree

---

Anton Vorontsov (3):
      gpiolib: cosmetic improvements for error handling in gpiochip_add()
      of/gpio: Kill of_gpio_chip and add members directly to gpio_chip
      of/gpio: add default of_xlate function if device has a node pointer

Grant Likely (2):
      of/gpio: stop using device_node data pointer to find gpio_chip
      of/device: Add OF style matching helper function


 arch/microblaze/kernel/reset.c                 |   12 ++-
 arch/powerpc/platforms/52xx/mpc52xx_gpio.c     |   30 ++++----
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c      |   29 ++++----
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |   34 ++-------
 arch/powerpc/platforms/86xx/gef_gpio.c         |   24 +++----
 arch/powerpc/sysdev/cpm1.c                     |   10 +--
 arch/powerpc/sysdev/cpm_common.c               |    5 -
 arch/powerpc/sysdev/mpc8xxx_gpio.c             |    5 -
 arch/powerpc/sysdev/ppc4xx_gpio.c              |    5 -
 arch/powerpc/sysdev/qe_lib/gpio.c              |   31 ++++-----
 arch/powerpc/sysdev/simple_gpio.c              |    5 -
 drivers/gpio/gpiolib.c                         |   55 ++++++++++++++-
 drivers/gpio/xilinx_gpio.c                     |   15 ++--
 drivers/of/device.c                            |    2 -
 drivers/of/gpio.c                              |   86 +++++++++++++++---------
 include/asm-generic/gpio.h                     |   15 ++++
 include/linux/of_device.h                      |   19 +++++
 include/linux/of_gpio.h                        |   35 +++-------
 18 files changed, 226 insertions(+), 191 deletions(-)
