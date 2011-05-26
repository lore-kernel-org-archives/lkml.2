Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab1EZSM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:12:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59183 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab1EZSM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:12:27 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 26 May 2011 12:12:02 -0600
X-Google-Sender-Auth: 1Ib5xHObMlIL6s-y7TjlxIzT-sQ
Message-ID: <BANLkTi=S2quduA7-8Emqw7vE0J1eto6bgA@mail.gmail.com>
Subject: [git pull] gpio changes for $NEXT_KERNEL
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Due to my own stupidity, this branch as /not/ been tested through
linux-next.  I put it in a branch that I negelcted to ask Stephen to
include.  :-(  I'm asking him to add it for tonight.  At the very
least, it has been build tested on various x86, powerpc, mips, sparc
and arm defconfigs.

You'll probably want to hold off on actually pulling this one, but I
wanted to give you a heads up that I have it still pending.  If you've
not picked it up, then I can resend the pull req tomorrow afternoon
after confirming it hasn't messed up anything in linux-next.

There's nothing earth shattering here.  Just a bunch of driver updates
and some faltering steps towards unifying a bunch of the mmio gpio
logic.

g.

The following changes since commit 4db70f73e56961b9bcdfd0c36c62847a18b7dbb5:

  tmpfs: fix XATTR N overriding POSIX_ACL Y (2011-05-25 19:53:02 -0700)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 gpio/next

Erik Botö (1):
      gpio/pca953x: Use handle_simple_irq instead of handle_edge_irq

H Hartley Sweeten (1):
      gpio: remove redundant Kconfig depends on GPIOLIB

Jamie Iles (9):
      basic_mmio_gpio: remove runtime width/endianness evaluation
      basic_mmio_gpio: convert to platform_{get,set}_drvdata()
      basic_mmio_gpio: allow overriding number of gpio
      basic_mmio_gpio: request register regions
      basic_mmio_gpio: detect output method at probe time
      basic_mmio_gpio: support different input/output registers
      basic_mmio_gpio: support direction registers
      basic_mmio_gpio: convert to non-__raw* accessors
      basic_mmio_gpio: split into a gpio library and platform device

Jean Delvare (1):
      gpiolib: export gpiochip_find

Linus Walleij (2):
      gpio: remove some legacy comments in build files
      gpio/via: rename VIA local config struct

Uwe Kleine-König (1):
      gpio: add trace events for setting direction and value

 drivers/gpio/Kconfig            |   23 +-
 drivers/gpio/Makefile           |    7 +-
 drivers/gpio/basic_mmio_gpio.c  |  517 +++++++++++++++++++++++++++++----------
 drivers/gpio/gpiolib.c          |   19 ++-
 drivers/gpio/pca953x.c          |    2 +-
 drivers/video/via/via-gpio.c    |   49 ++--
 include/linux/basic_mmio_gpio.h |   56 +++++
 include/trace/events/gpio.h     |   56 +++++
 8 files changed, 555 insertions(+), 174 deletions(-)
 create mode 100644 include/trace/events/gpio.h


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
