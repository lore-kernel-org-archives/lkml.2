Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab2ATBCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:02:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:24624 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab2ATBCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:02:02 -0500
X-AuditID: cbfee61b-b7be3ae0000039aa-a1-4f18bd08534b
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        myungjoo.ham@gmail.com
Subject: [PATCH v4 0/4] introduce External Connector Class (extcon)
Date: Fri, 20 Jan 2012 10:01:53 +0900
Message-id: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1326275202-27401-1-git-send-email-myungjoo.ham@samsung.com>
References: <1326275202-27401-1-git-send-email-myungjoo.ham@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For external connectors, which may have different types of cables attached
(USB, TA, HDMI, Analog A/V, and others), we often have seperated device
drivers that detect the state changes at the port and device drivers that
do something according to the state changes.

For example, when MAX8997-MUIC detects a Charger cable insertion, another
device driver (such as MAX8903 charger, MAX8997 charger, Charger Manager,
or board file) needs to set charger current limit accordingly and when
MAX8997-MUIC detects a HDMI cable insertion, multimedia device drivers
need to do some operations accordingly.

This patchset supports the usage of notifier for passing such information
between device drivers.

Another issue is that at a single switch port, there might be multiple
and heterogeneous cables attached at the same time. Besides the state
(Attached or Detached) of each cable may alter independently. Such extcon
devices that support simultaneous mult-cable attachment include, bot not
limited to, docks, cradles, and 30-pin-like ports (like that of NURI board
in linux/arch/arm/mach-exynos, which resembles Samsung Galaxy Tab series).
For example, the 30-pin port of NURI board may be used to connect analog
audio cables, analog video cable, and a USB or a charger. Because such
cables coonnect part of the 30 pins to external devices/cables, the
possible combinations of external devices/cables vary significantly and
users may fabricate their own design; e.g., an 30-pin adaptor connecting
USB, AC-DC adaptor, HDMI, analog audio, analog video, USB-host, SD-card,
and so on.

In order to address such issues, Android kernel's "Switch" class seems to
be a good basis and we have implemented "Multistate Switch Class" based on
it. The "Switch" class code of Android kernel is GPL as well.

Summary of changes from v3 patchset
- Bugfixes after testing at Exynos4412 boards.

Summary of changes from v2 patchset
- Support to express mutually exclusive set of cables
- Revised device/class/sysfs-entries add/removal methods
- Added sysfs entries
- Revised documentation and comments
- Some bugfixes
- Compatible with Android (for extcon devices with "use_class_name_switch" set)

Summary of changes from RFC
- ABI documentation added
- Notifees may get notified for a state change of a specific cable, not
every cable of the corresponding extcon.
- Added kerneldoc comments
- Moved to /drivers/extcon/
- Added helper functions
- Some bugfixes



Donggeun Kim (1):
  Extcon: support notification based on the state changes.

MyungJoo Ham (3):
  Extcon (external connector): import Android's switch class and
    modify.
  Extcon: support multiple states at a device.
  Extcon: support mutually exclusive relation between cables.

 Documentation/ABI/testing/sysfs-class-extcon |   75 +++
 drivers/Kconfig                              |    2 +
 drivers/Makefile                             |    1 +
 drivers/extcon/Kconfig                       |   22 +
 drivers/extcon/Makefile                      |    6 +
 drivers/extcon/extcon_class.c                |  652 ++++++++++++++++++++++++++
 drivers/extcon/extcon_gpio.c                 |  173 +++++++
 include/linux/extcon.h                       |  305 ++++++++++++
 8 files changed, 1236 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-extcon
 create mode 100644 drivers/extcon/Kconfig
 create mode 100644 drivers/extcon/Makefile
 create mode 100644 drivers/extcon/extcon_class.c
 create mode 100644 drivers/extcon/extcon_gpio.c
 create mode 100644 include/linux/extcon.h

-- 
1.7.4.1

