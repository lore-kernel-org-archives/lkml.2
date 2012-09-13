Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2IMN6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:58:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34264 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab2IMN6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:58:11 -0400
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: mturquette@linaro.org, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rjw@sisk.pl
Cc: patches@linaro.org, linaro-dev@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>
Subject: [PATCH v2 0/3] devfreq: Add support for devices which can idle
Date: Thu, 13 Sep 2012 19:25:32 +0530
Message-Id: <1347544535-2772-1-git-send-email-rajagopal.venkat@linaro.org>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajagopal Venkat <rajagopal.venkat@linaro.org>

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

--
Rajagopal Venkat (3):
  devfreq: Core updates to support devices which can idle
  devfreq: Add suspend and resume apis
  devfreq: Add current freq callback in device profile

 Documentation/ABI/testing/sysfs-class-devfreq |  15 +-
 drivers/devfreq/devfreq.c                     | 413 +++++++++++---------------
 drivers/devfreq/governor.h                    |  11 +
 drivers/devfreq/governor_performance.c        |  16 +-
 drivers/devfreq/governor_powersave.c          |  16 +-
 drivers/devfreq/governor_simpleondemand.c     |  40 +++
 drivers/devfreq/governor_userspace.c          |  23 +-
 include/linux/devfreq.h                       |  46 ++-
 8 files changed, 291 insertions(+), 289 deletions(-)

-- 
1.7.11.3

