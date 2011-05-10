Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1EJA2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 20:28:36 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:36206 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab1EJA2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 20:28:35 -0400
Subject: [GIT pull] rtc fixes for 2.6.39
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <1304624059.20980.10.camel@work-vm>
References: <1304624059.20980.10.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 17:28:19 -0700
Message-ID: <1304987299.2939.46.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	Here again are the rtc fixes from Wolfram with my updates to the
changelogs and commit subjects. I've also done a full audit of the rtc
subsystem looking for other places where the same issue of rtc drivers
registering themselves before they complete initialization, found seven
more drivers that needed fixing.

Additionally Uwe found and fixed a related locking issue where a
deadlock could occur.

The fixes are available in the git repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/39/tip/timers/rtc

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


