Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1KXCD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 21:03:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46460 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab1KXCDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 21:03:55 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
Date: Thu, 24 Nov 2011 11:03:53 +0900
X-Google-Sender-Auth: vbdmdEv_BskdrzakmuIjfn5QYis
Message-ID: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
Subject: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For switch ports, which may have different types of cables
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
and heterogeneous cables attached at the same time. Besides, the state
(Attached or Detached) of each cable may alter independently.

In order to address such issues, Android kernel's "Switch" class seems to
be a good basis and we have implemented "Multistate Switch Class" based on
it. The "Switch" class code of Android kernel is GPL as well.

Donggeun Kim (1):
  Multistate Switch Class: add notifier block

MyungJoo Ham (2):
  Multistate Switch Class: import Android's switch class and modify.
  Multistate Switch Class: support multiple states at a device.

 drivers/Makefile            |    1 +
 drivers/misc/Kconfig        |   21 +++
 drivers/misc/Makefile       |    2 +
 drivers/misc/switch_class.c |  332 +++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/switch_gpio.c  |  174 ++++++++++++++++++++++
 include/linux/switch.h      |  164 +++++++++++++++++++++
 6 files changed, 694 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/switch_class.c
 create mode 100644 drivers/misc/switch_gpio.c
 create mode 100644 include/linux/switch.h

-- 
1.7.4.1
