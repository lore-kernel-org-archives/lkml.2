Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab0HCW0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:26:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34047 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756695Ab0HCW0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:26:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM updates for 2.6.36
Date: Wed, 4 Aug 2010 00:24:22 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
MIME-Version: 1.0
Message-Id: <201008040024.22222.rjw@sisk.pl>
X-Length: 3435
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        linux-pci@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management updates for 2.6.36 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

They include:

 * Runtime PM framework updates from Alan Stern and Arjan.

 * Hibernate and suspend fixes.

 * PM QoS update from James.

 * New mechanism for avoiding races between wakeup and system sleep.


 Documentation/ABI/testing/sysfs-power  |   15 ++
 drivers/base/power/Makefile            |    2 +-
 drivers/base/power/main.c              |    1 +
 drivers/base/power/runtime.c           |   54 ++++++-
 drivers/base/power/sysfs.c             |   98 ++++++++++---
 drivers/base/power/wakeup.c            |  247 ++++++++++++++++++++++++++++++++
 drivers/net/e1000e/netdev.c            |   17 +--
 drivers/net/igbvf/netdev.c             |    9 +-
 drivers/net/wireless/ipw2x00/ipw2100.c |   12 +-
 drivers/pci/pci-acpi.c                 |    1 +
 drivers/pci/pci.c                      |   20 +++-
 drivers/pci/pci.h                      |    1 +
 drivers/pci/pcie/pme/pcie_pme.c        |    5 +-
 drivers/pnp/core.c                     |    3 +
 drivers/pnp/pnpacpi/core.c             |   23 +++
 include/linux/netdevice.h              |    2 +-
 include/linux/plist.h                  |   29 ++++
 include/linux/pm.h                     |   16 ++
 include/linux/pm_qos_params.h          |   13 ++-
 include/linux/pm_wakeup.h              |   10 +-
 include/linux/pnp.h                    |    1 +
 include/linux/suspend.h                |   17 ++-
 include/sound/pcm.h                    |    2 +-
 kernel/pm_qos_params.c                 |  215 +++++++++++++++-------------
 kernel/power/hibernate.c               |   24 ++-
 kernel/power/main.c                    |   55 +++++++
 kernel/power/suspend.c                 |   13 +-
 kernel/power/swap.c                    |    4 +-
 sound/core/pcm_native.c                |   13 +-
 29 files changed, 734 insertions(+), 188 deletions(-)

---------------

Alan Stern (3):
      PM: describe kernel policy regarding wakeup defaults (v. 2)
      PNPACPI: Add support for remote wakeup
      PM / Runtime: Make runtime_status attribute not debug-only (v. 2)

Arjan van de Ven (1):
      PM / Runtime: Add runtime PM statistics (v3)

Cesar Eduardo Barros (1):
      PM / Hibernate: Fix typos in comments in kernel/power/swap.c

James Bottomley (3):
      plist: Add plist_last
      pm_qos: Reimplement using plists
      pm_qos: Get rid of the allocation in pm_qos_add_request()

Rafael J. Wysocki (5):
      PM: Make it possible to avoid races between wakeup and system sleep
      PM / Hibernate: Fix hibernation_platform_enter()
      PM / Hibernate: Fix snapshot error code path
      PM / Suspend: Fix ordering of calls in suspend error paths
      PM: Do not use dynamically allocated objects in pm_wakeup_event()

