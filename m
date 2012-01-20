Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab2ATRto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:49:44 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:44340 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2ATRtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:49:41 -0500
Message-ID: <4F19A91A.6050706@atmel.com>
Date: Fri, 20 Jan 2012 18:49:14 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [GIT PULL] at91: fixes for 3.3-rc2
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

Here is the first batch of fixes for at91 on top of 3.3-rc1.
In addition to usual fixes, there is:
- one announce added to feature-removal-schedule.txt (removal of CAP9 family)
- a fix for sam9g45 family restart: an assembly helper is needed. This fix needs a
  proper cleanup of both CAP9 and SAM9G45 header and reset controller (rstc)
- fixes that affect USB and AT91 code but that have already been "Acked-by" Greg: He
  agreed that those patches should go through arm-soc:
http://www.spinics.net/lists/linux-usb/msg55474.html

Now the usual information:

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at: 
  git://github.com/at91linux/linux-at91.git at91-fixes

Jean-Christophe PLAGNIOL-VILLARD (7):   
      USB: at91: fix clk_get error handling
      ARM/USB: at91/ohci-at91: rename vbus_pin_inverted to vbus_pin_active_low
      ARM: at91: fix cap9 ddrsdr register
      ARM: at91: merge at91cap9_ddrsdr.h in at91sam9_ddrsdr.h
      ARM: at91: introduce AT91_SAM9_ALT_RESET to select the at91sam9 alternative reset
      ARM: at91: make rstc soc independent
      ARM: at91: Fix at91sam9g45 and at91cap9 reset

Nicolas Ferre (2):
      ARM: at91: fix at91rm9200 soc subtype handling
      ARM: at91: removal of CAP9 SoC family

 Documentation/feature-removal-schedule.txt        |   14 +++
 arch/arm/mach-at91/Kconfig                        |   14 +++
 arch/arm/mach-at91/Makefile                       |   14 ++-
 arch/arm/mach-at91/at91cap9.c                     |    9 +--
 arch/arm/mach-at91/at91sam9260.c                  |    1 +
 arch/arm/mach-at91/at91sam9261.c                  |    1 +
 arch/arm/mach-at91/at91sam9263.c                  |    1 +
 arch/arm/mach-at91/at91sam9_alt_reset.S           |    7 +-
 arch/arm/mach-at91/at91sam9g45.c                  |    7 +-
 arch/arm/mach-at91/at91sam9g45_reset.S            |   40 ++++++++
 arch/arm/mach-at91/at91sam9rl.c                   |    1 +
 arch/arm/mach-at91/generic.h                      |    2 +
 arch/arm/mach-at91/include/mach/at91_rstc.h       |   18 +++-
 arch/arm/mach-at91/include/mach/at91cap9.h        |    2 +-
 arch/arm/mach-at91/include/mach/at91cap9_ddrsdr.h |  108 ---------------------
 arch/arm/mach-at91/include/mach/at91sam9260.h     |    2 +-
 arch/arm/mach-at91/include/mach/at91sam9261.h     |    2 +-
 arch/arm/mach-at91/include/mach/at91sam9263.h     |    2 +-
 arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h |   30 ++++--
 arch/arm/mach-at91/include/mach/at91sam9g45.h     |    2 +-
 arch/arm/mach-at91/include/mach/at91sam9rl.h      |    2 +-
 arch/arm/mach-at91/include/mach/board.h           |    2 +-
 arch/arm/mach-at91/pm.c                           |    9 +--
 arch/arm/mach-at91/pm.h                           |    8 +-
 arch/arm/mach-at91/pm_slowclock.S                 |    5 +-
 arch/arm/mach-at91/setup.c                        |   16 +++-
 drivers/usb/host/ohci-at91.c                      |   24 ++++-
 27 files changed, 174 insertions(+), 169 deletions(-)
 create mode 100644 arch/arm/mach-at91/at91sam9g45_reset.S
 delete mode 100644 arch/arm/mach-at91/include/mach/at91cap9_ddrsdr.h



-- 
Nicolas Ferre
