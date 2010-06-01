Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab0FAIB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:01:27 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:59774 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab0FAIB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:01:26 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] zram: generic RAM based compressed R/W block devices (v2)
Date: Tue,  1 Jun 2010 13:31:22 +0530
Message-Id: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Changelog v1 vs v2
 - Split file rename and code rename patches
 - Removed useless swap related includes from zram_drv.c
 - Various cleanups suggested by Minchan:
   - Documented rzs->lock mutex in ramzswap_drv.h (see patch 1)
     (this file is renamed to zram_drv.h in patch 2)
   - remove useless 'index' argument in handle_zero_page()
   - Edited comments/messages mentioning 'swap'
   - Removed redundant return from void zram_slot_free_notify()

Creates RAM based block devices: /dev/zramX (X = 0, 1, ...).
Pages written to these disks are compressed and stored in memory
itself. These disks allow very fast I/O and compression provides
good amounts of memory savings.

This is enhancement over existing ramzswap driver which creates
virtual block devices (/dev/ramzswapX) which could be used only
as swap disks.

Now, with the ability to handle any kind of I/O request, zram
devices have lot more use cases:
 - /tmp storage
 - various caches under /var
 - swap disks
 - CacheFiles storage
 - maybe even more! :)

Performance numbers can be found at:
http://code.google.com/p/compcache/wiki/zramperf

Stress testing results:
http://code.google.com/p/compcache/wiki/zramIOzone

Patch 1 makes core changes to support handling generic I/O
requests. Subsequent patches rename ramzswap* files to zram*
and similar changes in code and documentation.

Nitin Gupta (4):
  Support generic I/O requests
  Rename ramzswap files to zram
  Rename ramzswap to zram in code
  Rename ramzswap to zram in documentation

 drivers/staging/Kconfig                            |    2 +-
 drivers/staging/Makefile                           |    2 +-
 drivers/staging/ramzswap/Kconfig                   |   21 -
 drivers/staging/ramzswap/Makefile                  |    3 -
 drivers/staging/ramzswap/ramzswap.txt              |   51 --
 drivers/staging/ramzswap/ramzswap_drv.c            |  837 --------------------
 drivers/staging/zram/Kconfig                       |   28 +
 drivers/staging/zram/Makefile                      |    3 +
 drivers/staging/{ramzswap => zram}/xvmalloc.c      |    0
 drivers/staging/{ramzswap => zram}/xvmalloc.h      |    0
 drivers/staging/{ramzswap => zram}/xvmalloc_int.h  |    0
 drivers/staging/zram/zram.txt                      |   62 ++
 drivers/staging/zram/zram_drv.c                    |  804 +++++++++++++++++++
 .../{ramzswap/ramzswap_drv.h => zram/zram_drv.h}   |   71 +-
 .../ramzswap_ioctl.h => zram/zram_ioctl.h}         |   21 +-
 15 files changed, 943 insertions(+), 962 deletions(-)
 delete mode 100644 drivers/staging/ramzswap/Kconfig
 delete mode 100644 drivers/staging/ramzswap/Makefile
 delete mode 100644 drivers/staging/ramzswap/ramzswap.txt
 delete mode 100644 drivers/staging/ramzswap/ramzswap_drv.c
 create mode 100644 drivers/staging/zram/Kconfig
 create mode 100644 drivers/staging/zram/Makefile
 rename drivers/staging/{ramzswap => zram}/xvmalloc.c (100%)
 rename drivers/staging/{ramzswap => zram}/xvmalloc.h (100%)
 rename drivers/staging/{ramzswap => zram}/xvmalloc_int.h (100%)
 create mode 100644 drivers/staging/zram/zram.txt
 create mode 100644 drivers/staging/zram/zram_drv.c
 rename drivers/staging/{ramzswap/ramzswap_drv.h => zram/zram_drv.h} (69%)
 rename drivers/staging/{ramzswap/ramzswap_ioctl.h => zram/zram_ioctl.h} (68%)

