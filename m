Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1EGBVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:21:50 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:56061 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab1EGBVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:21:08 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
Subject: [PATCH 00/11] rtc: Fix rtc breakage found by commit f44f7f96a20
Date: Fri,  6 May 2011 18:20:43 -0700
Message-Id: <1304731254-3238-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit f44f7f96a20 ("RTC: Initialize kernel state from RTC")
landed in 2.6.39-rc1, we've seen a few reports of boot time hangs
cropping up. It ends up that the problematic rtc drivers were
calling rtc_device_register before it finished initializing critical
data for the rtc driver to function.

Wolfram Sang noticed that this issue was actually more common then
just the few reports seen, and motivated me to do a complete audit
of all the RTC drivers to ensure they were not being registered
before any critical drvdata was initialized.

This patchset is the result of that audit, along with earlier
noted fixes from Wolfram's and Uwe.

Thanks again to Wolfram and Uwe for the patches and helping make
these issues a priority.

CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: rtc-linux@googlegroups.com


John Stultz (7):
  rtc: ds1286: Initialize drvdata before registering device
  rtc: m41t80: Initialize clientdata before registering device
  rtc: max8925: Initialize drvdata before registering device
  rtc: max8998: Initialize drvdata before registering device
  rtc: msm6242: Initialize drvdata before registering device
  rtc: pcap: Initialize drvdata before registering device
  rtc: rp5c01: Initialize drvdata before registering device

Uwe Kleine-König (1):
  rtc: mc13xxx: Don't call rtc_device_register while holding lock

Wolfram Sang (3):
  rtc: mxc: Initialize drvdata before registering device
  rtc: davinci: Initialize drvdata before registering device
  rtc: ep93xx: Initialize drvdata before registering device

 drivers/rtc/rtc-davinci.c |    5 +++--
 drivers/rtc/rtc-ds1286.c  |    2 +-
 drivers/rtc/rtc-ep93xx.c  |    5 ++---
 drivers/rtc/rtc-m41t80.c  |    5 +++--
 drivers/rtc/rtc-max8925.c |    5 +++--
 drivers/rtc/rtc-max8998.c |    5 +++--
 drivers/rtc/rtc-mc13xxx.c |    8 ++++++--
 drivers/rtc/rtc-msm6242.c |    3 ++-
 drivers/rtc/rtc-mxc.c     |   19 +++++++++++--------
 drivers/rtc/rtc-pcap.c    |    4 +++-
 drivers/rtc/rtc-rp5c01.c  |    5 +++--
 11 files changed, 40 insertions(+), 26 deletions(-)

-- 
1.7.3.2.146.gca209

