Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2IUPNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:13:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45372 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab2IUPNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:13:51 -0400
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: mturquette@linaro.org, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rjw@sisk.pl
Cc: patches@linaro.org, linaro-dev@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>
Subject: [PATCH v3 0/3] devfreq: Add support for devices which can idle
Date: Fri, 21 Sep 2012 20:41:55 +0530
Message-Id: <1348240318-2967-1-git-send-email-rajagopal.venkat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset updates devfreq core to add support for devices
which can idle. When device idleness is detected perhaps
through runtime-pm, need some mechanism to suspend devfreq
load monitoring and resume when device is back online.

patch 1 introduce core design changes - per device work, decouple
delayed work from core and event based interaction.
patch 2 add devfreq suspend and resume apis.
patch 3 add new sysfs attribute for governor predicted next target
frequency and callback for current device frequency.

The existing devfreq apis are kept intact. Two new apis
devfreq_suspend_device() and devfreq_resume_device() are
added to support suspend/resume of device devfreq.

Changes since v1:
- revised locking mechanism
- added kerneldoc comments for load monitoring helper functions
- Fixed minor review comments

Changes since v2:
- added new helper function for polling interval update
- Handled work suspend/resume contention between devfreq driver
and sysfs

--
Rajagopal Venkat (3):
  devfreq: Core updates to support devices which can idle
  devfreq: Add suspend and resume apis
  devfreq: Add current freq callback in device profile

 Documentation/ABI/testing/sysfs-class-devfreq |  15 +-
 drivers/devfreq/devfreq.c                     | 469 ++++++++++++--------------
 drivers/devfreq/governor.h                    |  13 +
 drivers/devfreq/governor_performance.c        |  16 +-
 drivers/devfreq/governor_powersave.c          |  16 +-
 drivers/devfreq/governor_simpleondemand.c     |  33 ++
 drivers/devfreq/governor_userspace.c          |  23 +-
 include/linux/devfreq.h                       |  49 +--
 8 files changed, 341 insertions(+), 293 deletions(-)

-- 
1.7.11.3

