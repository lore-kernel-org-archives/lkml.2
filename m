Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab0ERUIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:08:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43294 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758282Ab0ERUIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:08:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM updates for 2.6.35
Date: Tue, 18 May 2010 22:09:21 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       mark gross <mgross@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Matt Helsley <matthltc@us.ibm.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jean Delvare <khali@linux-fr.org>, Jiri Slaby <jslaby@suse.cz>,
       Pavel Machek <pavel@ucw.cz>,
       Dominik Brodowski <linux@dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005182209.21774.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management updates for 2.6.35 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

They include:

* Runtime PM improvements from Alan Stern and Dominik Brodowski

* Hibernate cleanups from Jiri Slaby

* PM documentation updates from me, Alan Stern and Pavel Machek

* PM QOS update from Mark Gross

* Subsystem PM improvements from Mark Brown and me


 Documentation/power/devices.txt          |  847 +++++++++++++++++-------------
 Documentation/power/pm_qos_interface.txt |   48 +-
 Documentation/power/userland-swsusp.txt  |    4 +
 drivers/acpi/processor_idle.c            |    2 +-
 drivers/base/platform.c                  |    6 +-
 drivers/base/power/runtime.c             |   10 +-
 drivers/base/power/sysfs.c               |   65 +++-
 drivers/cpuidle/governors/ladder.c       |    2 +-
 drivers/cpuidle/governors/menu.c         |    2 +-
 drivers/i2c/i2c-core.c                   |  166 ++++---
 drivers/net/e1000e/netdev.c              |   22 +-
 drivers/net/igbvf/netdev.c               |    6 +-
 drivers/net/wireless/ipw2x00/ipw2100.c   |   11 +-
 fs/libfs.c                               |   35 ++
 include/linux/fs.h                       |    2 +
 include/linux/netdevice.h                |    4 +
 include/linux/pm_qos_params.h            |   14 +-
 include/linux/pm_runtime.h               |    7 +
 include/linux/pm_wakeup.h                |   38 +-
 include/sound/pcm.h                      |    3 +-
 kernel/cgroup_freezer.c                  |   21 +-
 kernel/pm_qos_params.c                   |  218 ++++----
 kernel/power/Makefile                    |    3 +-
 kernel/power/block_io.c                  |  103 ++++
 kernel/power/power.h                     |   27 +-
 kernel/power/snapshot.c                  |  145 ++----
 kernel/power/swap.c                      |  333 +++++-------
 kernel/power/user.c                      |   37 +-
 net/mac80211/mlme.c                      |    2 +-
 sound/core/pcm.c                         |    3 -
 sound/core/pcm_native.c                  |   14 +-
 31 files changed, 1251 insertions(+), 949 deletions(-)

---------------

Alan Stern (2):
      PM: Allow runtime_suspend methods to call pm_schedule_suspend()
      PM: Improve device power management document

Dmitry Torokhov (1):
      PM: pm_wakeup - switch to using bool

Dominik Brodowski (1):
      PM / Runtime: Add sysfs debug files

Jiri Slaby (5):
      FS / libfs: Implement simple_write_to_buffer
      PM / Hibernate: Snapshot cleanup
      PM / Hibernate: Separate block_io
      PM / Hibernate: Move the first_sector out of swsusp_write
      PM / Hibernate: Group swap ops

Mark Brown (1):
      PM / platform_bus: Allow runtime PM by default

Mark Gross (2):
      PM QOS update
      PM: PM QOS update fix

Matt Helsley (1):
      Freezer / cgroup freezer: Update stale locking comments

Pavel Machek (1):
      PM / Hibernate: document open(/dev/snapshot) side effects

Rafael J. Wysocki (2):
      PM: Update device power management document
      i2c: Fix bus-level power management callbacks

Randy Dunlap (1):
      PM / Hibernate: Fix block_io.c printk warning

