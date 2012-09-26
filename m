Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab2IZIrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:47:15 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58075 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2IZIrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:47:12 -0400
X-AuditID: 9c93016f-b7b23ae000004419-06-5062c10d5607
From: Minchan Kim <minchan@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>
Subject: [PATCH 0/3] zram/zsmalloc promotion
Date: Wed, 26 Sep 2012 17:50:16 +0900
Message-Id: <1348649419-16494-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset promotes zram/zsmalloc from staging.
Both are very clean and zram have been used by many embedded product
for a long time.
It's time to go out of staging.

Greg, Jens is already OK and Konrad wanted to put zsmalloc into lib/
instead of mm/. I think lib/ is more proper than drivers/block/zram
which is suggested by Nitin.

I don't know who should merge whose tree.
So I will add both Greg and Jens to To.

This patchset is based on next-20120926.

Minchan Kim (3):
  zsmalloc: promote to lib/
  zram: promote zram from staging
  zram: select ZSMALLOC when ZRAM is configured

 drivers/block/Kconfig                    |    1 +
 drivers/block/Makefile                   |    1 +
 drivers/block/zram/Kconfig               |   26 +
 drivers/block/zram/Makefile              |    3 +
 drivers/block/zram/zram.txt              |   76 +++
 drivers/block/zram/zram_drv.c            |  785 ++++++++++++++++++++++
 drivers/block/zram/zram_drv.h            |  119 ++++
 drivers/block/zram/zram_sysfs.c          |  225 +++++++
 drivers/staging/Kconfig                  |    4 -
 drivers/staging/Makefile                 |    2 -
 drivers/staging/zcache/zcache-main.c     |    4 +-
 drivers/staging/zram/Kconfig             |   25 -
 drivers/staging/zram/Makefile            |    3 -
 drivers/staging/zram/zram.txt            |   76 ---
 drivers/staging/zram/zram_drv.c          |  785 ----------------------
 drivers/staging/zram/zram_drv.h          |  120 ----
 drivers/staging/zram/zram_sysfs.c        |  225 -------
 drivers/staging/zsmalloc/Kconfig         |   10 -
 drivers/staging/zsmalloc/Makefile        |    3 -
 drivers/staging/zsmalloc/zsmalloc-main.c | 1064 ------------------------------
 drivers/staging/zsmalloc/zsmalloc.h      |   43 --
 include/linux/zsmalloc.h                 |   43 ++
 lib/Kconfig                              |    2 +
 lib/Makefile                             |    1 +
 lib/zsmalloc/Kconfig                     |   18 +
 lib/zsmalloc/Makefile                    |    1 +
 lib/zsmalloc/zsmalloc.c                  | 1064 ++++++++++++++++++++++++++++++
 27 files changed, 2367 insertions(+), 2362 deletions(-)
 create mode 100644 drivers/block/zram/Kconfig
 create mode 100644 drivers/block/zram/Makefile
 create mode 100644 drivers/block/zram/zram.txt
 create mode 100644 drivers/block/zram/zram_drv.c
 create mode 100644 drivers/block/zram/zram_drv.h
 create mode 100644 drivers/block/zram/zram_sysfs.c
 delete mode 100644 drivers/staging/zram/Kconfig
 delete mode 100644 drivers/staging/zram/Makefile
 delete mode 100644 drivers/staging/zram/zram.txt
 delete mode 100644 drivers/staging/zram/zram_drv.c
 delete mode 100644 drivers/staging/zram/zram_drv.h
 delete mode 100644 drivers/staging/zram/zram_sysfs.c
 delete mode 100644 drivers/staging/zsmalloc/Kconfig
 delete mode 100644 drivers/staging/zsmalloc/Makefile
 delete mode 100644 drivers/staging/zsmalloc/zsmalloc-main.c
 delete mode 100644 drivers/staging/zsmalloc/zsmalloc.h
 create mode 100644 include/linux/zsmalloc.h
 create mode 100644 lib/zsmalloc/Kconfig
 create mode 100644 lib/zsmalloc/Makefile
 create mode 100644 lib/zsmalloc/zsmalloc.c

-- 
1.7.9.5

