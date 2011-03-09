Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1CIUXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 15:23:20 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57343 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab1CIUXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 15:23:19 -0500
Subject: [GIT PULL] 2.6.39 RTC cleanups
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        Roman Fietze <roman.fietze@telemotive.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 12:22:59 -0800
Message-ID: <1299702179.28285.248.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
        Here's my current 2.6.39 RTC queue for testing in -tip. Let me
know if there's any tweaks you need.

thanks
-john

  git://git.linaro.org/people/jstultz/linux.git fortglx/39/tip/timers/rtc

John Stultz (6):
      RTC: Initialize kernel state from RTC
      RTC: Cleanup rtc_class_ops->irq_set_state
      RTC: Cleanup rtc_class_ops->irq_set_freq()
      RTC: Cleanup rtc_class_ops->update_irq_enable()
      RTC: Clean out UIE icotl implementations
      RTC: Fix up rtc.txt documentation to reflect changes to generic rtc layer

Marcelo Roberto Jimenez (4):
      RTC: Include information about UIE and PIE in RTC driver proc.
      RTC: Remove UIE and PIE information from the sa1100 driver proc.
      RTC: Fix the cross interrupt issue on rtc-test.
      RTC: sa1100: Update the sa1100 RTC driver.

Roman Fietze (3):
      rtc-lib: rtc_time const pointers in functions not modifying it
      rtc.h: add extern keyword for external function declarations
      rtc core: use pointers to pass rtc_time to and from ktime conversion routines

 Documentation/rtc.txt        |   29 ++----
 drivers/rtc/class.c          |    7 ++
 drivers/rtc/interface.c      |  194 ++++++++++++++++++++++++++++++++++++++++--
 drivers/rtc/rtc-at91rm9200.c |   28 ------
 drivers/rtc/rtc-at91sam9.c   |   28 ------
 drivers/rtc/rtc-bfin.c       |   27 ------
 drivers/rtc/rtc-cmos.c       |   66 --------------
 drivers/rtc/rtc-davinci.c    |   55 ------------
 drivers/rtc/rtc-ds1511.c     |   17 ----
 drivers/rtc/rtc-ds1553.c     |   17 ----
 drivers/rtc/rtc-ds3232.c     |   18 ----
 drivers/rtc/rtc-jz4740.c     |    7 --
 drivers/rtc/rtc-lib.c        |   14 ++--
 drivers/rtc/rtc-mc13xxx.c    |    7 --
 drivers/rtc/rtc-mpc5121.c    |   20 -----
 drivers/rtc/rtc-mrst.c       |   20 -----
 drivers/rtc/rtc-mxc.c        |    7 --
 drivers/rtc/rtc-nuc900.c     |   15 ---
 drivers/rtc/rtc-omap.c       |   39 ---------
 drivers/rtc/rtc-pcap.c       |    6 --
 drivers/rtc/rtc-pcf50633.c   |   22 +-----
 drivers/rtc/rtc-pl030.c      |    6 --
 drivers/rtc/rtc-pl031.c      |   55 ------------
 drivers/rtc/rtc-proc.c       |    8 ++
 drivers/rtc/rtc-pxa.c        |   44 ----------
 drivers/rtc/rtc-rs5c372.c    |   52 -----------
 drivers/rtc/rtc-rx8025.c     |   25 ------
 drivers/rtc/rtc-s3c.c        |   33 -------
 drivers/rtc/rtc-sa1100.c     |  160 +---------------------------------
 drivers/rtc/rtc-sh.c         |   24 -----
 drivers/rtc/rtc-stmp3xxx.c   |   15 ---
 drivers/rtc/rtc-test.c       |   13 ++-
 drivers/rtc/rtc-twl.c        |   13 ---
 drivers/rtc/rtc-vr41xx.c     |   32 -------
 drivers/rtc/rtc-wm831x.c     |   16 ----
 drivers/rtc/rtc-wm8350.c     |   21 -----
 include/linux/rtc.h          |   13 +--
 37 files changed, 238 insertions(+), 935 deletions(-)


