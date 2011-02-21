Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1BUX4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:56:46 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49075 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1BUXz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:55:58 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        rtc-linux@googlegroups.com
Subject: [PATCH 00/10] [RFC] RTC: Cleanups for 2.6.39
Date: Mon, 21 Feb 2011 15:55:28 -0800
Message-Id: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe all the RTC regressions in 2.6.38 are addressed,
so I wanted  to send these changes out for comment before
I push them to Thomas and the -tip tree for testing and
hopeful inclusion into 2.6.39.

Now that the generic RTC layer is virtualizing the various
legacy irq modes, and managing the hardware itself instead
of exposing the hardware functions directly to userland, it 
greatly simplifies what is required from an RTC driver.

No longer do we use the irq_set_state, irq_set_freq,
update_irq_enable and read_alarm function in the hardware
specific RTC drivers. So that code can be removed.

This really does take a buzzsaw to the code, so I want to
make sure there really are no objections to removing it
before we do so.

There may also be some further driver specific cleanups
needed. For example, included in this set are Marcelo's
changes to the sa1100 rtc driver to further reduce the
amount of driver level code.

Let me know what you think.

thanks
-john

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
CC: rtc-linux@googlegroups.com

John Stultz (6):
  RTC: Cleanup rtc_class_ops->irq_set_state
  RTC: Cleanup rtc_class_ops->irq_set_freq()
  RTC: Cleanup rtc_class_ops->update_irq_enable()
  RTC: Cleanup rtc_class_ops->read_alarm()
  RTC: Clean out UIE icotl implementations
  RTC: Fix up rtc.txt documentation to reflect changes to generic rtc
    layer

Marcelo Roberto Jimenez (4):
  RTC: Include information about UIE and PIE in RTC driver proc.
  RTC: Remove UIE and PIE information from the sa1100 driver proc.
  RTC: Fix the cross interrupt issue on rtc-test.
  RTC: sa1100: Update the sa1100 RTC driver.

 Documentation/rtc.txt        |   29 +++-----
 drivers/rtc/interface.c      |    3 +-
 drivers/rtc/rtc-ab3100.c     |   34 --------
 drivers/rtc/rtc-ab8500.c     |   40 ----------
 drivers/rtc/rtc-at32ap700x.c |   14 ----
 drivers/rtc/rtc-at91rm9200.c |   50 ------------
 drivers/rtc/rtc-at91sam9.c   |   55 -------------
 drivers/rtc/rtc-bfin.c       |   38 ---------
 drivers/rtc/rtc-cmos.c       |  139 ----------------------------------
 drivers/rtc/rtc-coh901331.c  |   14 ----
 drivers/rtc/rtc-davinci.c    |   93 -----------------------
 drivers/rtc/rtc-ds1286.c     |   24 ------
 drivers/rtc/rtc-ds1305.c     |   62 +---------------
 drivers/rtc/rtc-ds1307.c     |   52 -------------
 drivers/rtc/rtc-ds1374.c     |   43 -----------
 drivers/rtc/rtc-ds1511.c     |   35 ---------
 drivers/rtc/rtc-ds1553.c     |   33 --------
 drivers/rtc/rtc-ds3232.c     |   66 ----------------
 drivers/rtc/rtc-efi.c        |   20 -----
 drivers/rtc/rtc-fm3130.c     |   59 --------------
 drivers/rtc/rtc-imxdi.c      |   27 -------
 drivers/rtc/rtc-isl1208.c    |   40 ----------
 drivers/rtc/rtc-jz4740.c     |   26 ------
 drivers/rtc/rtc-lpc32xx.c    |   14 ----
 drivers/rtc/rtc-m41t80.c     |   50 ------------
 drivers/rtc/rtc-m48t59.c     |   48 ------------
 drivers/rtc/rtc-max8925.c    |   31 --------
 drivers/rtc/rtc-max8998.c    |   32 --------
 drivers/rtc/rtc-mc13xxx.c    |   50 ------------
 drivers/rtc/rtc-mpc5121.c    |   33 --------
 drivers/rtc/rtc-mrst.c       |   52 -------------
 drivers/rtc/rtc-mv.c         |   38 ---------
 drivers/rtc/rtc-mxc.c        |   25 ------
 drivers/rtc/rtc-nuc900.c     |   27 -------
 drivers/rtc/rtc-omap.c       |   61 ---------------
 drivers/rtc/rtc-pcap.c       |   27 -------
 drivers/rtc/rtc-pcf50633.c   |   46 +-----------
 drivers/rtc/rtc-pl030.c      |   15 ----
 drivers/rtc/rtc-pl031.c      |   84 --------------------
 drivers/rtc/rtc-proc.c       |    8 ++
 drivers/rtc/rtc-pxa.c        |   60 ---------------
 drivers/rtc/rtc-rs5c372.c    |   90 ----------------------
 drivers/rtc/rtc-rx8025.c     |   71 -----------------
 drivers/rtc/rtc-s3c.c        |   94 -----------------------
 drivers/rtc/rtc-sa1100.c     |  172 +----------------------------------------
 drivers/rtc/rtc-sh.c         |   64 ----------------
 drivers/rtc/rtc-stk17ta8.c   |   16 ----
 drivers/rtc/rtc-stmp3xxx.c   |   24 ------
 drivers/rtc/rtc-test.c       |   20 ++---
 drivers/rtc/rtc-twl.c        |   44 -----------
 drivers/rtc/rtc-tx4939.c     |   30 -------
 drivers/rtc/rtc-vr41xx.c     |   52 -------------
 drivers/rtc/rtc-wm831x.c     |   52 -------------
 drivers/rtc/rtc-wm8350.c     |   71 -----------------
 drivers/rtc/rtc-x1205.c      |   26 ------
 include/linux/rtc.h          |    5 -
 56 files changed, 36 insertions(+), 2492 deletions(-)

-- 
1.7.3.2.146.gca209

