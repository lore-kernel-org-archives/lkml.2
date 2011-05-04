Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1EDPcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:32:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42844 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab1EDPcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:32:22 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 0/3] repair RTC subsys (for i.MX)
Date: Wed,  4 May 2011 17:31:25 +0200
Message-Id: <1304523088-17039-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent updates to the RTC subsystem (removing UIE interrupts and use
alarms instead) introduced two problems for i.MX (and the subsys in
general, I'd think):

a) because registering the rtc now calls get_alarm(), the requirement
has been added for a lot of drivers that drvdata is properly set up
_before_ registering. rtc-mxc did not do that (probably bad; but as said
like a lot of other rtc-drivers currently) and oopsed.

b) the callbacks to the rtc-core for update_irqs have been removed, but
irq-handlers are still there, now being unused cruft. In case of
rtc-mxc, this is only one if-block, but for rtc-mc13xxx.c this is a
seperate handler.

>From a glimpse, most platform drivers seem to have at least one of these
problems now :( John, am I correct or am I missing something?

Kind regards,

   Wolfram

Wolfram Sang (3):
  rtc: mc13xxx: remove UIE signaling
  rtc: mxc: fix crash on boot
  rtc: mxc: remove UIE signaling

 drivers/rtc/rtc-mc13xxx.c |   23 -----------------------
 drivers/rtc/rtc-mxc.c     |   22 +++++++++++-----------
 2 files changed, 11 insertions(+), 34 deletions(-)

-- 
1.7.2.5

