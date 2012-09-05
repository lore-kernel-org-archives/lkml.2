Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2IEFmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:42:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34102 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2IEFmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:42:49 -0400
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 07:42:48 +0200
Message-ID: <CACRpkdYjMdHxFyZNRFxvHiuR_Sdkk3R6obO_0WoNCo0Z0973SA@mail.gmail.com>
Subject: [GIT PULL] gpio fixes for v3.6
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Axel Lin <axel.lin@gmail.com>,
        Thierry Reding <thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

these are some smallish GPIO regression fixes for the v3.6 series,
should be no big deal, please pull them in! Details in the tag.

Yours,
Linus Walleij


The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad92:

  Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-fixes-for-v3.6

for you to fetch changes up to 1146f8822ae6601e24f9072d6cd74f76506142cd:

  gpio: rdc321x: Prevent removal of modules exporting active GPIOs
(2012-09-01 12:52:24 +0200)

----------------------------------------------------------------
These are some GPIO regression fixes for v3.6:
- Erroneous debug message from of_get_named_gpio_flags()
- Make sure the MC9S08DZ60 GPIO driver depend on I2C being
  compiled in (not module) or allmodconfig breaks.
- Check return value from irq_alloc_descs() in the Emma
  Mobile GPIO driver.
- Assign the owner field for the rdc321x driver so the
  module won't be removed if it has active GPIOs.

----------------------------------------------------------------
Axel Lin (3):
      gpio: mc9s08dz60: Fix build error if I2C=m
      gpio: em: Fix checking return value of irq_alloc_descs
      gpio: rdc321x: Prevent removal of modules exporting active GPIOs

Thierry Reding (1):
      gpio: Fix debug message in of_get_named_gpio_flags()

 drivers/gpio/Kconfig        | 2 +-
 drivers/gpio/gpio-em.c      | 4 ++--
 drivers/gpio/gpio-rdc321x.c | 1 +
 drivers/gpio/gpiolib-of.c   | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)
