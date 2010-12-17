Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0LQKU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:20:29 -0500
Received: from smtp.nokia.com ([147.243.1.47]:31912 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab0LQKU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:20:28 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: rpurdie@rpsys.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ilkka.koskinen@nokia.com,
        arun.murthy@stericsson.com, ankur.vaish@stericsson.com
Subject: [PATCH 0/3] leds: lp5521 and lp523 corrections
Date: Fri, 17 Dec 2010 12:19:18 +0200
Message-Id: <1292581161-1177-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.7.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both drivers created and removed sysfs entries based on the
programmable engine state. Engine and mux control sysfs entries
were visible only when the engine was set to load state.

However, this caused circular locking error between sysfs-core
and the driver internal mutex. Now all the sysfs entries are
visible all the time but the access to engine program load 
entry causes error if the engine mode is not correct.

lp5523 led channel naming changed to support name from the
platform data to allow use of several chips without overlapping
sysfs names.

Samu Onkalo (3):
  leds: leds-lp5523: modify the way of setting led device name
  leds: lp5523: Fix circular locking
  leds: lp5521: Fix circular locking

 drivers/leds/leds-lp5521.c  |   52 ++++++--------------------------------
 drivers/leds/leds-lp5523.c  |   59 +++++++++++++-----------------------------
 include/linux/leds-lp5523.h |    1 +
 3 files changed, 27 insertions(+), 85 deletions(-)

