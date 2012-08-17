Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab2HQOfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:35:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35362 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab2HQOfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:35:38 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 0/8] UBI: add max_beb_per1024 parameter / ioctl
Date: Fri, 17 Aug 2012 16:35:16 +0200
Message-Id: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,
This patch serie introduce, step by step the kernel module parameter
max_beb_per1024, then the ioctl and finally drop the kernel config option
CONFIG_MTD_UBI_BEB_LIMIT.

It's based on top of linux-ubi/master (and I added your patch on
sam9_l9260_defconfig).
BTW, I let the BEB value at 30 in sam9_l9260_defconfig, you can set it at 25 if
you want (as it's the value from the datasheet).

Best Regards

Richard.

Artem Bityutskiy (1):
  arm: sam9_l9260_defconfig: adjust UBI bad eraseblocks limit

Richard Genoud (7):
  UBI: separate bad_peb_limit in a function
  UBI: introduce MTD_PARAM_MAX_COUNT
  UBI: prepare for max_beb_per1024 module parameter addition
  UBI: check max_beb_per1024 value in ubi_attach_mtd_dev
  UBI: replace MTD_UBI_BEB_LIMIT with module parameter
  UBI: add ioctl for max_beb_per1024
  UBI: drop CONFIG_MTD_UBI_BEB_LIMIT

 arch/arm/configs/sam9_l9260_defconfig |    1 -
 drivers/mtd/ubi/Kconfig               |   26 -------
 drivers/mtd/ubi/build.c               |  116 +++++++++++++++++++++-----------
 drivers/mtd/ubi/cdev.c                |    3 +-
 drivers/mtd/ubi/ubi.h                 |    6 ++-
 include/mtd/ubi-user.h                |   19 +++++-
 6 files changed, 101 insertions(+), 70 deletions(-)

-- 
1.7.2.5

