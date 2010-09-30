Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0I3IY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:24:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab0I3IYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:24:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/6] staging fixes
Date: Thu, 30 Sep 2010 10:24:06 +0200
Message-Id: <1285835052-11880-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:6Xyg7yk2Gk7Q+mbbBOa6A+zrgo4/RCHpublHg9D89F4
 8OBp38vZwB1c3kD53+tH1OY+GkZANg9OFhPfzl3AnqWFkRlFrp
 dg45+W7kDgIP5BSbP6EmFIAbYecdds8JhqdQSV7yaYyFwHuWBZ
 qRtU9oJ3/wRFH/rMODdApYqc2tkcCMEtBW5bUFW/lJUjRFTJgd
 JY4K/ayD2hV31ugK7jlIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My previous version of the first patch (staging: make new
character devices nonseekable) was untested and broke
compilation in multiple ways.

To make up for this, please take the fixed version
and some patches to fix basic problems in those
two drivers, as found by building with sparse.

	Arnd

Arnd Bergmann (6):
  staging: make new character devices nonseekable
  stagin/ft1000-usb: fix unlocked_ioctl prototype
  staging/ft1000-usb: fix build warnings
  staging/ft1000-usb: fix problems found by sparse
  staging/bcm: fix most build warnings
  staging/bcm: add sparse annotations

 drivers/staging/bcm/Adapter.h                      |    2 +-
 drivers/staging/bcm/Bcmchar.c                      |  168 ++++++++++----------
 drivers/staging/bcm/Bcmnet.c                       |    6 +-
 drivers/staging/bcm/CmHost.c                       |   18 +-
 drivers/staging/bcm/Debug.c                        |    2 +-
 drivers/staging/bcm/HandleControlPacket.c          |    2 +-
 drivers/staging/bcm/IPv6Protocol.c                 |    4 +-
 drivers/staging/bcm/InterfaceDld.c                 |    6 +-
 drivers/staging/bcm/InterfaceIdleMode.c            |    2 +-
 drivers/staging/bcm/InterfaceIdleMode.h            |    2 +-
 drivers/staging/bcm/InterfaceInit.c                |   31 ++--
 drivers/staging/bcm/Ioctl.h                        |    8 +-
 drivers/staging/bcm/LeakyBucket.c                  |   22 ++--
 drivers/staging/bcm/Macros.h                       |    2 +-
 drivers/staging/bcm/Misc.c                         |   20 ++-
 drivers/staging/bcm/PHSDefines.h                   |    2 +-
 drivers/staging/bcm/PHSModule.c                    |    2 +-
 drivers/staging/bcm/Prototypes.h                   |    3 +-
 drivers/staging/bcm/Qos.c                          |    8 +-
 drivers/staging/bcm/Transmit.c                     |    4 +-
 drivers/staging/bcm/led_control.c                  |   22 ++--
 drivers/staging/bcm/nvm.c                          |   54 +++---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |   92 ++++++------
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   45 +++---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   95 +++++-------
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |   25 +---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   43 +++++-
 28 files changed, 348 insertions(+), 344 deletions(-)

