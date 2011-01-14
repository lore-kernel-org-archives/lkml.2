Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab1ANPnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:43:35 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58952 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab1ANPna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:43:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=vT0yz5IxSTRZPbPbKGvD8oUuzBXsLsXO8afS2A7NlIeUhTWs3JQ6Pr5I5G2kYsD3as
         QsByfAmP2GGTSSl5o2jmLgX9y70Za3OMJOBb6ILM5lu8C7Hm+7DDYopP9oFAHKw2syLB
         /k/vFP+GF5x2zPq1tFPQSLtr9e8lj40O7E2gg=
Date: Fri, 14 Jan 2011 18:43:18 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20110114154318.GA6483@oksana.dev.rtsoft.ru>
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
2.6.38. Two new drivers plus some assorted cleanups and bug fixes
in this pull request.

Thanks!

The following changes since commit e53beacd23d9cb47590da6a7a7f6d417b941a994:
  Linus Torvalds (1):
        Linux 2.6.37-rc2

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git master

Ameya Palande (1):
      isp1704_charger: Correct length for storing model

Anton Vorontsov (1):
      jz4740-battery: Should include linux/io.h

Daniel Drake (1):
      olpc_battery: Ambient temperature is not available on XO-1.5

Heikki Krogerus (3):
      isp1704_charger: Detect HUB/Host chargers
      isp1704_charger: Set isp->dev before anything needs it
      isp1704_charger: Detect charger after probe

Lars-Peter Clausen (6):
      jz4740-battery: Protect against concurrent battery readings
      power_supply: Add gpio charger driver
      jz4740-battery: Check if platform_data is supplied
      gpio-charger: Check result of kzalloc
      gpio-charger: Provide default name for the power_supply
      gpio-charger: Fix potential race between irq handler and probe/remove

MyungJoo Ham (1):
      power_supply: Add MAX17042 Fuel Gauge Driver

Sascha Silbe (4):
      olpc_battery: Add support for CHARGE_FULL_DESIGN
      olpc_battery: Add support for CHARGE_NOW
      olpc_battery: Add support for CURRENT_NOW and VOLTAGE_NOW
      olpc_battery: Fix up XO-1.5 properties list

Sven Neumann (1):
      ds2760_battery: Fix calculation of time_to_empty_now

Tejun Heo (1):
      power_supply: Don't use flush_scheduled_work()

Vasiliy Kulikov (1):
      power_supply: Fix use after free and memory leak

Vasily Khoruzhick (1):
      s3c_adc_battery: Add gpio_inverted field to pdata

 drivers/power/Kconfig                  |   20 +++
 drivers/power/Makefile                 |    2 +
 drivers/power/collie_battery.c         |   13 +-
 drivers/power/ds2760_battery.c         |    2 +-
 drivers/power/gpio-charger.c           |  188 +++++++++++++++++++++++++
 drivers/power/intel_mid_battery.c      |    2 +-
 drivers/power/isp1704_charger.c        |  201 +++++++++++++++++++++------
 drivers/power/jz4740-battery.c         |   13 ++
 drivers/power/max17042_battery.c       |  239 ++++++++++++++++++++++++++++++++
 drivers/power/olpc_battery.c           |  114 +++++++++++++++-
 drivers/power/power_supply_core.c      |    6 +-
 drivers/power/s3c_adc_battery.c        |   12 ++-
 drivers/power/tosa_battery.c           |   13 +-
 drivers/power/wm97xx_battery.c         |    4 +-
 drivers/power/z2_battery.c             |    6 +-
 include/linux/power/gpio-charger.h     |   41 ++++++
 include/linux/power/max17042_battery.h |   30 ++++
 include/linux/s3c_adc_battery.h        |    1 +
 18 files changed, 838 insertions(+), 69 deletions(-)
 create mode 100644 drivers/power/gpio-charger.c
 create mode 100644 drivers/power/max17042_battery.c
 create mode 100644 include/linux/power/gpio-charger.h
 create mode 100644 include/linux/power/max17042_battery.h
