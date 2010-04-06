Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab0DFF7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:59:17 -0400
Received: from smtp.nokia.com ([192.100.122.230]:64691 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab0DFF7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:59:10 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [RESEND PATCH v2 0/6] lis3lv02d: click and threshold interrupts
Date: Tue,  6 Apr 2010 08:58:39 +0300
Message-Id: <1270533525-15312-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 06 Apr 2010 05:58:52.0616 (UTC) FILETIME=[3C1CB480:01CAD54E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch set is not changed since acked by:
Éric Piel <eric.piel@tremplin-utc.net>
Date: 06-Mar-2010
http://www.spinics.net/lists/lm-sensors/msg27902.html

Applies to 2.6.34-RC3
Tested on 2.6.32 for omap3



Original cover-letter from original patch set v2:

This patch set replaces my previous one.
(see http://www.spinics.net/lists/kernel/msg994446.html)

Power control of the chip is dropped out since it requires more work.
Runtime-pm support was requested and that takes some time to implement
and test. I'll send it as a separate patch.

patches 1 - 3 are not touched compared to patch set 1 and they
are marked as tested-by Daniel Mack <daniel@xxxxxxxx> and
acked-by Éric Piel <eric.piel@xxxxxxxxxxxxxxxx>.
Patch 4 is marked as tested-by Daniel Mack <daniel@xxxxxxxx>.

  lis3: Add skeletons for interrupt handlers
No functional changes. Changed due to rebasing and power control
removal.

  lis3: Interrupt handlers for 8bit wakeup and click events
As requested, BTN_ events are enabled only for 8 bit device and
when click event is configured to the HW.
Remapping of the BTN_ axis done according to platform data.

  lis3: Setup poll interval limits
Poll interval can now be set from 1 - 2000 ms and also to stopped state
via input-dev sysfs. 

Tested in 2.6.32 based environment


Samu Onkalo (6):
  lis3: Add missing constants for 8bit device
  lis3: Separate configuration function for 8 bit device
  lis3: Introduce platform data for second ff / wu unit
  lis3: Add skeletons for interrupt handlers
  lis3: Interrupt handlers for 8bit wakeup and click events
  lis3: Setup poll interval limits

 drivers/hwmon/lis3lv02d.c |  245 +++++++++++++++++++++++++++++++++++----------
 drivers/hwmon/lis3lv02d.h |   11 ++
 include/linux/lis3lv02d.h |   12 ++
 3 files changed, 213 insertions(+), 55 deletions(-)

