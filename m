Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab1BCCP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:15:58 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:36696 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab1BCCO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:14:56 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: [PATCH 0/4] RTC regression fixups
Date: Wed,  2 Feb 2011 18:14:39 -0800
Message-Id: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So Marcelo recently pointed out some regressions with the RTC rework
I did. This patchset tries to address those issues.

Thomas: "1/4 Prevent a division by zero" is urg and should go 
into 2.6.38 soon. The others need validation by Marcelo, but 
need to get in prior to 2.6.38 final (the earlier the better).

Marcelo: Mind giving this full patch set a go? It seems to resolve
the issues in my testing with the rtc-test driver.

CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>

John Stultz (3):
  RTC: Fix rtc driver ioctl specific shortcutting
  RTC: Convert rtc drivers to use the alarm_irq_enable method
  RTC: Fix minor compile warning

Marcelo Roberto Jimenez (1):
  RTC: Prevents a division by zero in kernel code.

 drivers/rtc/class.c          |    1 +
 drivers/rtc/interface.c      |    3 ++
 drivers/rtc/rtc-at32ap700x.c |   19 +++++-----------
 drivers/rtc/rtc-at91rm9200.c |   20 +++++++++++------
 drivers/rtc/rtc-at91sam9.c   |   20 ++++++++++++-----
 drivers/rtc/rtc-bfin.c       |   21 ++++++++++-------
 drivers/rtc/rtc-dev.c        |   21 ++++++------------
 drivers/rtc/rtc-ds1286.c     |   41 +++++++++++++++++++---------------
 drivers/rtc/rtc-ds1305.c     |   43 +++++++++++-------------------------
 drivers/rtc/rtc-ds1307.c     |   49 +++++++++++------------------------------
 drivers/rtc/rtc-ds1374.c     |   37 ++++++++-----------------------
 drivers/rtc/rtc-m41t80.c     |   30 ++++++------------------
 drivers/rtc/rtc-m48t59.c     |   21 +++++------------
 drivers/rtc/rtc-mrst.c       |   31 ++++----------------------
 drivers/rtc/rtc-msm6242.c    |    2 +-
 drivers/rtc/rtc-mv.c         |   20 ++++++-----------
 drivers/rtc/rtc-omap.c       |   28 ++++++++++++++++-------
 drivers/rtc/rtc-rp5c01.c     |    2 +-
 drivers/rtc/rtc-rs5c372.c    |   48 +++++++++++++++++++++++++++++------------
 drivers/rtc/rtc-sa1100.c     |   22 ++++++++++--------
 drivers/rtc/rtc-sh.c         |   11 ++++++---
 drivers/rtc/rtc-test.c       |   21 ++---------------
 drivers/rtc/rtc-vr41xx.c     |   38 +++++++++++++++-----------------
 23 files changed, 236 insertions(+), 313 deletions(-)

-- 
1.7.3.2.146.gca209

