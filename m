Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab1FVUEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:04:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51254 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041Ab1FVUEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:04:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] More power management fixes for 3.0
Date: Wed, 22 Jun 2011 22:04:54 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-sh@vger.kernel.org, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106222204.54532.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management fixes for 3.0 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

They include:

* Power management documentation fixes updating information on things that have
  changed.

* Fix for potential PCI PM regression related to interactions between system
  suspend/hibernation and the runtime PM framework.

* Fix for smobile regression related to the management of device clocks when
  CONFIG_PM_RUNTIME is unset.

* Fix for a long-standing issue in the async suspend error code path (accompanied
  by a field rename in struct dev_pm_info).

* Fix for a long-standing hibernation bug related to its user space interface.


 Documentation/power/devices.txt    |   67 +++++++----------------------------
 Documentation/power/runtime_pm.txt |    5 ---
 drivers/base/power/clock_ops.c     |    4 +-
 drivers/base/power/main.c          |   28 +++++++++++----
 drivers/pci/pci-driver.c           |    4 ++-
 drivers/usb/core/driver.c          |    6 ++--
 include/linux/device.h             |    4 +-
 include/linux/pm.h                 |    3 +-
 kernel/power/user.c                |    4 ++-
 9 files changed, 50 insertions(+), 75 deletions(-)

---------------

Alan Stern (2):
      PM: Rename dev_pm_info.in_suspend to is_prepared
      PM: Fix async resume following suspend failure

Kevin Hilman (1):
      PM / Runtime: Update doc: usage count no longer incremented across system PM

Michal Kubecek (1):
      PM: Free memory bitmaps if opening /dev/snapshot fails

Rafael J. Wysocki (4):
      PM: Update documentation regarding sysdevs
      PM / Runtime: Handle clocks correctly if CONFIG_PM_RUNTIME is unset
      PM / Domains: Update documentation
      PCI / PM: Block races between runtime PM and system sleep

