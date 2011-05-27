Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1E0KyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 06:54:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64268 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab1E0KyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 06:54:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=SWWEE6yOh5+ARmG6NlF/y58P1gPjXNgYx6kaffW5U43jDCfhmlFm2Ou+OYCYfr28RM
         iddNbBA8fi9jPkIg9tPAjgEdZ8gUr1hp5MOkckcrKrqsiiRQcg2K8g44LALRgL4uQehE
         Txv985MYksrXamjzLUDqOojhJm6UOVrqH3+hE=
Date: Fri, 27 May 2011 14:54:07 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20110527105407.GA29529@oksana.dev.rtsoft.ru>
Reply-To: cbouatmailru@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull battery-2.6.git tree to receive changes prepared for
2.6.40.

There are support for new hardware + some fixes here and there, the
usual stuff. :-)

You may notice the power-related change for Nokia N900 board (the
ARM commmit). I took that patch via battery git tree to not create
cross-tree dependencies. And of course it has an appropriate ack
from OMAP maintainer to go through that tree.

Thanks!

The following changes since commit f0e615c3cb72b42191b558c130409335812621d8:

  Linux 2.6.39-rc4 (2011-04-18 21:26:00 -0700)

are available in the git repository at:
  git://git.infradead.org/battery-2.6.git master

Anton Vorontsov (1):
      max8903_charger: Add GENERIC_HARDIRQS as a dependency (fixes S390 build)

Benson Leung (1):
      gpio-charger: Add gpio_charger_resume

John Stultz (1):
      power: Make test_power driver more dynamic.

Kalle Jokiniemi (2):
      isp1704_charger: Allow board specific powering routine
      ARM: RX-51: Enable isp1704 power on/off

Marek Vasut (1):
      PXA: Use dev_pm_ops in z2_battery

MyungJoo Ham (1):
      power_supply: Add driver for MAX8903 charger

Pali Rohár (1):
      bq27x00_battery: Name of cycle count property

Paul Parsons (2):
      ds2760_battery: Fix indexing of the 4 active full EEPROM registers
      ds2760_battery: Fix rated capacity of the hx4700 1800mAh battery

 arch/arm/mach-omap2/board-rx51-peripherals.c |   27 ++-
 drivers/power/Kconfig                        |    9 +
 drivers/power/Makefile                       |    1 +
 drivers/power/bq27x00_battery.c              |   11 +-
 drivers/power/ds2760_battery.c               |    6 +-
 drivers/power/gpio-charger.c                 |   15 +
 drivers/power/isp1704_charger.c              |   22 ++
 drivers/power/max8903_charger.c              |  391 ++++++++++++++++++++++++++
 drivers/power/test_power.c                   |  276 +++++++++++++++++-
 drivers/power/z2_battery.c                   |   20 +-
 include/linux/power/isp1704_charger.h        |   29 ++
 include/linux/power/max8903_charger.h        |   57 ++++
 12 files changed, 840 insertions(+), 24 deletions(-)
 create mode 100644 drivers/power/max8903_charger.c
 create mode 100644 include/linux/power/isp1704_charger.h
 create mode 100644 include/linux/power/max8903_charger.h
