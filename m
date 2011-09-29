Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab1I2MSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:18:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18135 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab1I2MSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:18:45 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-7e-4e846224a672
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@suse.de>, Kevin Hilman <khilman@ti.com>,
        Nishanth Menon <nm@ti.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Colin Cross <ccross@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@ti.com>, myungjoo.ham@gmail.com
Subject: [PATCH v13 0/4] Devfreq, DVFS Framework for Non-CPU Devices
Date: Thu, 29 Sep 2011 21:18:46 +0900
Message-id: <1317298730-10442-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-OriginalArrivalTime: 29 Sep 2011 12:18:42.0775 (UTC)
 FILETIME=[ED95BE70:01CC7EA1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary of update from the patchset v12:

- Bugfix: _remove_devfreq and devfreq_dev_release may be called multiple times.

- Fixup kerneldoc comments.

Reposting to LKML as Kernel-PM list seems broken.

I didn't put Kevin's ACK at 2/4 patch as there has been changes in 2/4 patch
(the bugfix mentioned above).

MyungJoo Ham (4):
  PM / OPP: Add OPP availability change notifier.
  PM: Introduce devfreq: generic DVFS framework with device-specific
    OPPs
  PM / devfreq: add common sysfs interfaces
  PM / devfreq: add basic governors

 Documentation/ABI/testing/sysfs-class-devfreq |   52 +++
 drivers/Kconfig                               |    2 +
 drivers/Makefile                              |    2 +
 drivers/base/power/opp.c                      |   30 ++
 drivers/devfreq/Kconfig                       |   75 +++
 drivers/devfreq/Makefile                      |    5 +
 drivers/devfreq/devfreq.c                     |  601 +++++++++++++++++++++++++
 drivers/devfreq/governor.h                    |   24 +
 drivers/devfreq/governor_performance.c        |   29 ++
 drivers/devfreq/governor_powersave.c          |   29 ++
 drivers/devfreq/governor_simpleondemand.c     |   88 ++++
 drivers/devfreq/governor_userspace.c          |  116 +++++
 include/linux/devfreq.h                       |  238 ++++++++++
 include/linux/opp.h                           |   12 +
 14 files changed, 1303 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-devfreq
 create mode 100644 drivers/devfreq/Kconfig
 create mode 100644 drivers/devfreq/Makefile
 create mode 100644 drivers/devfreq/devfreq.c
 create mode 100644 drivers/devfreq/governor.h
 create mode 100644 drivers/devfreq/governor_performance.c
 create mode 100644 drivers/devfreq/governor_powersave.c
 create mode 100644 drivers/devfreq/governor_simpleondemand.c
 create mode 100644 drivers/devfreq/governor_userspace.c
 create mode 100644 include/linux/devfreq.h

-- 
1.7.4.1

