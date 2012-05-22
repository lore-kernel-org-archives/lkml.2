Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab2EVT4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:56:16 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59498 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab2EVT4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:56:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management updates for 3.5
Date: Tue, 22 May 2012 22:01:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205222201.15304.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management updates for 3.5 since commit
d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6

with top-most commit 8714c8d74d313c3ba27bf9c2aaacb1ad71c644f8

  epoll: Fix user space breakage related to EPOLLWAKEUP

from the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-3.5

Included are:

* Implementation of opportunistic suspend (autosleep) and user space interface
  for manipulating wakeup sources.

* Hibernate updates from Bojan Smojver and Minho Ban.

* Updates of the runtime PM core and generic PM domains framework related to
  PM QoS.

* Assorted fixes.

Thanks!


 Documentation/ABI/testing/sysfs-devices-power  |   35 +++-
 Documentation/ABI/testing/sysfs-power          |   59 ++++++
 Documentation/kernel-parameters.txt            |    2 +
 Documentation/power/suspend-and-cpuhotplug.txt |    2 +-
 drivers/base/power/domain.c                    |  176 ++++++++++++----
 drivers/base/power/domain_governor.c           |  166 ++++++++++++----
 drivers/base/power/main.c                      |   10 +
 drivers/base/power/qos.c                       |   19 +-
 drivers/base/power/runtime.c                   |  103 +---------
 drivers/base/power/sysfs.c                     |   54 +++++-
 drivers/base/power/wakeup.c                    |  174 +++++++++++-----
 drivers/devfreq/governor_performance.c         |    7 +
 drivers/devfreq/governor_powersave.c           |    7 +
 fs/eventpoll.c                                 |   90 ++++++++-
 include/linux/capability.h                     |    5 +-
 include/linux/eventpoll.h                      |   12 +
 include/linux/pm.h                             |    2 -
 include/linux/pm_domain.h                      |   13 +-
 include/linux/pm_runtime.h                     |    3 -
 include/linux/pm_wakeup.h                      |   15 +-
 include/linux/suspend.h                        |   14 ++-
 include/trace/events/power.h                   |   34 +++
 kernel/power/Kconfig                           |   27 +++
 kernel/power/Makefile                          |    2 +
 kernel/power/autosleep.c                       |  127 ++++++++++++
 kernel/power/hibernate.c                       |   13 ++
 kernel/power/main.c                            |  160 +++++++++++++--
 kernel/power/power.h                           |   27 +++
 kernel/power/swap.c                            |   62 ++++--
 kernel/power/wakelock.c                        |  259 ++++++++++++++++++++++++
 30 files changed, 1359 insertions(+), 320 deletions(-)

---------------

Arve Hjønnevåg (3):
      PM / Sleep: Add wakeup_source_activate and wakeup_source_deactivate tracepoints
      epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while epoll events are ready
      PM / Sleep: Fix a mistake in a conditional in autosleep_store()

Bojan Smojver (1):
      PM / Hibernate: Hibernate/thaw fixes/improvements

Huang Ying (1):
      PM / Domains: Fix link checking when add subdomain

Marcos Paulo de Souza (1):
      PM / Documentation: suspend-and-cpuhotplug.txt: Fix typo

Minho Ban (1):
      PM / Hibernate: Use get_gendisk to verify partition if resume_file is integer format

Rafael J. Wysocki (17):
      PM / Sleep: Look for wakeup events in later stages of device suspend
      PM / Sleep: Use wait queue to signal "no wakeup events in progress"
      PM / Sleep: Change wakeup source statistics to follow Android
      PM / Sleep: Implement opportunistic sleep, v2
      PM / Sleep: Add "prevent autosleep time" statistics to wakeup sources
      PM / Sleep: Add user space interface for manipulating wakeup sources, v3
      PM / Domains: Rework default device stop governor function, v2
      PM / Domains: Rework default domain power off governor function, v2
      PM / Runtime: Remove device fields related to suspend time, v2
      PM / QoS: Create device constraints objects on notifier registration
      PM / Domains: Make device removal more straightforward
      PM / Domains: Cache device stop and domain power off governor results, v3
      PM / Sleep: Make the limit of user space wakeup sources configurable
      PM / Sleep: User space wakeup sources garbage collector Kconfig option
      PM / Domains: Fix computation of maximum domain off time
      PM / Domains: Make it possible to add devices to inactive domains
      epoll: Fix user space breakage related to EPOLLWAKEUP

Xiaoguang Chen (1):
      PM: devfreq: init performance/powersave governor

