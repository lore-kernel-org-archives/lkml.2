Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1LNK2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 05:28:20 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24647 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1LNK2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 05:28:17 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-e5-4ee87a3f4367
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Mike Lockwood <lockwood@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, NeilBrown <neilb@suse.de>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH v2 0/3] introduce External Connector Class (extcon)
Date: Wed, 14 Dec 2011 19:28:25 +0900
Message-id: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8bit
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that previously, the patchset has been submitted as
"Multistate Switch Class".

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
(Attached or Detached) of each cable may alter independently.

In order to address such issues, Android kernel's "Switch" class seems to
be a good basis and we have implemented "Multistate Switch Class" based on
it. The "Switch" class code of Android kernel is GPL as well.


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

MyungJoo Ham (2):
  Extcon (external connector): import Android's switch class and
    modify.
  Extcon: support multiple states at a device.

 drivers/Kconfig               |    2 +
 drivers/Makefile              |    1 +
 drivers/extcon/Kconfig        |   22 ++
 drivers/extcon/Makefile       |    6 +
 drivers/extcon/extcon_class.c |  510 +++++++++++++++++++++++++++++++++++++++++
 drivers/extcon/extcon_gpio.c  |  173 ++++++++++++++
 include/linux/extcon.h        |  289 +++++++++++++++++++++++
 7 files changed, 1003 insertions(+), 0 deletions(-)
 create mode 100644 drivers/extcon/Kconfig
 create mode 100644 drivers/extcon/Makefile
 create mode 100644 drivers/extcon/extcon_class.c
 create mode 100644 drivers/extcon/extcon_gpio.c
 create mode 100644 include/linux/extcon.h

-- 
1.7.4.1

