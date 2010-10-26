Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687Ab0JZO6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:58:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32859 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab0JZO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=kOW63oz1NJSq9rUSxKvZ3aOoJpn9/yhMNeHX+goQ9DZL1OiaxKpf8Wm5ukCXwz2qqf
         UNE8qqtk+qxoV1Qw5Jna7vyT+g4F27nDprXSk6efUQ1rPMTfwcCmytO8I+fUcTcAu1JW
         m/mmbaHsHvRBqF363kI5Vio48mUpkh3BI3+t8=
Date: Tue, 26 Oct 2010 18:41:18 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20101026144118.GA9335@oksana.dev.rtsoft.ru>
Reply-To: cbouatmailru@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull battery-2.6.git tree to receive changes prepared for
2.6.37.

There are three new drivers, various small cleanups and bug fixes.

You may notice the arch/arm/ change for Nokia N900 board, though
it has an appropriate ack from the OMAP maintainer to go through
the battery tree.

Thanks!

The following changes since commit 763008c4357b73c8d18396dfd8d79dc58fa3f99d:
  Linus Torvalds (1):
        Merge branch 'bugfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git master

Axel Lin (5):
      pcf50633-charger: Add missing sysfs_remove_group()
      ds2760_battery: Add missing kfree(di) in ds2760_battery_remove()
      jz4740-battery: Add missing kfree(jz_battery) in jz_battery_remove()
      wm831x_power: Add missing kfree(wm831x_power) in wm831x_power_remove()
      bq27x00_battery: Add missing kfree(di->bus) in bq27x00_battery_remove()

Grazvydas Ignotas (1):
      power_supply: Add driver for TWL4030/TPS65950 BCI charger

Heikki Krogerus (4):
      power_supply: Add isp1704 charger detection driver
      omap: rx51: Add support for USB chargers
      power_supply: Add types for USB chargers
      power_supply: Introduce maximum current property

Ian Lartey (1):
      wm831x_power: Remove duplicate chg mask

Martin Schwidefsky (1):
      ds2760_battery: Fix W1 and W1_SLAVE_DS2760 dependency

Rhyland Klein (2):
      power_supply: Add driver for TI BQ20Z75 gas gauge IC
      bq20z75: Add support for more power supply properties

Richard A. Smith (1):
      olpc_battery: Fix endian neutral breakage for s16 values

Ryan Mallon (1):
      ds2782_battery: Fix units

matt mooney (1):
      power_supply: Makefile cleanup

 arch/arm/mach-omap2/board-rx51-peripherals.c |    5 +
 drivers/power/Kconfig                        |   23 +-
 drivers/power/Makefile                       |   19 +-
 drivers/power/bq20z75.c                      |  493 ++++++++++++++++++++++
 drivers/power/bq27x00_battery.c              |    1 +
 drivers/power/ds2760_battery.c               |    1 +
 drivers/power/ds2782_battery.c               |   12 +-
 drivers/power/isp1704_charger.c              |  369 +++++++++++++++++
 drivers/power/jz4740-battery.c               |    1 +
 drivers/power/olpc_battery.c                 |    8 +-
 drivers/power/pcf50633-charger.c             |    1 +
 drivers/power/power_supply_sysfs.c           |    4 +-
 drivers/power/twl4030_charger.c              |  565 ++++++++++++++++++++++++++
 drivers/power/wm831x_power.c                 |    2 +-
 include/linux/power_supply.h                 |    6 +-
 15 files changed, 1483 insertions(+), 27 deletions(-)
 create mode 100644 drivers/power/bq20z75.c
 create mode 100644 drivers/power/isp1704_charger.c
 create mode 100644 drivers/power/twl4030_charger.c
