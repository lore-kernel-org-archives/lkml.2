Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab0D3Q5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:57:39 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59474 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab0D3Q5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:57:21 -0400
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 00/10] Introduce common hex_to_bin() helper
Date: Fri, 30 Apr 2010 12:33:59 +0300
Message-Id: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 30 Apr 2010 09:34:09.0130 (UTC) FILETIME=[48DE54A0:01CAE848]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Here is set of patches related to hex_to_bin() custom implementations. Many of
them are changed to newly introduced common method.

The idea published early by Harvey Harrison [1], but was given to me by
Alexander Shishkin.

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0805.0/0323.html

This version is just rebase against today's linux kernel.

Andy Shevchenko (10):
  lib: introduce common method to convert hex digits
  drivers: isdn: use new hex_to_bin() method
  usb: atm: speedtch: use new hex_to_bin() method
  drivers: net: use new hex_to_bin() method
  drivers: net: use new hex_to_bin() method
  sysctl: don't use own implementation of hex_to_bin()
  staging: rt2860: use new hex_to_bin() method
  fs: ldm: don't use own implementation of hex_to_bin()
  drivers: wireless: use new hex_to_bin() method
  drivers: acpi: don't use own implementation of hex_to_bin()

 drivers/acpi/bus.c                        |    9 +------
 drivers/isdn/gigaset/capi.c               |   13 +----------
 drivers/net/cxgb3/t3_hw.c                 |   16 +++----------
 drivers/net/sb1250-mac.c                  |   32 +---------------------------
 drivers/net/wireless/airo.c               |   15 +++----------
 drivers/staging/rt2860/common/rtmp_init.c |   15 +-----------
 drivers/staging/rt2860/rtmp.h             |    2 -
 drivers/usb/atm/speedtch.c                |    5 +--
 fs/partitions/ldm.c                       |   18 ++++++++--------
 include/linux/kernel.h                    |    2 +
 kernel/sysctl_binary.c                    |    9 ++-----
 lib/hexdump.c                             |   19 +++++++++++++++++
 12 files changed, 50 insertions(+), 105 deletions(-)

