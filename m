Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab2ICObq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 10:31:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43954 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab2ICObp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 10:31:45 -0400
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: mturquette@linaro.org, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rjw@sisk.pl
Cc: patches@linaro.org, linaro-dev@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>
Subject: [PATCH 0/3] devfreq: Add support for devices which can idle
Date: Mon,  3 Sep 2012 19:59:35 +0530
Message-Id: <1346682578-24312-1-git-send-email-rajagopal.venkat@linaro.org>
X-Mailer: git-send-email 1.7.11.3
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
patch 3 current frequency bug fix and add new sysfs attribute for
governor predicted next target frequency.

The existing devfreq apis are kept intact. Two new apis
devfreq_suspend_device() and devfreq_resume_device() are
added to support suspend/resume of device devfreq.

--
Rajagopal Venkat (3):
  devfreq: core updates to support devices which can idle
  devfreq: Add suspend and resume apis
  devfreq: Add current freq callback in device profile

 Documentation/ABI/testing/sysfs-class-devfreq |   7 +
 drivers/devfreq/devfreq.c                     | 412 +++++++++++---------------
 drivers/devfreq/governor.h                    |  11 +
 drivers/devfreq/governor_performance.c        |  16 +-
 drivers/devfreq/governor_powersave.c          |  16 +-
 drivers/devfreq/governor_simpleondemand.c     |  42 +++
 drivers/devfreq/governor_userspace.c          |  23 +-
 include/linux/devfreq.h                       |  46 ++-
 8 files changed, 291 insertions(+), 282 deletions(-)

-- 
1.7.11.3

