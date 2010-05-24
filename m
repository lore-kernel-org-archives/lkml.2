Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab0EXOVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 10:21:54 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61122 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073Ab0EXOVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 10:21:53 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] zram: generic RAM based compressed R/W block devices
Date: Mon, 24 May 2010 19:48:02 +0530
Message-Id: <1274710685-2351-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 - maybe even more! :)

Performance numbers can be found at:
http://code.google.com/p/compcache/wiki/zramperf

Patch 1 makes core changes to support handling generic I/O
requests. Subsequent patches rename ramzswap* files to zram*
and similar changes in code and documentation.

Nitin Gupta (3):
  Support generic I/O requests
  Rename ramzswap to zram in code.
  Rename ramzswap to zram in documentation

 drivers/staging/Kconfig                   |    2 +-
 drivers/staging/Makefile                  |    2 +-
 drivers/staging/ramzswap/Kconfig          |   21 -
 drivers/staging/ramzswap/Makefile         |    3 -
 drivers/staging/ramzswap/ramzswap.txt     |   51 --
 drivers/staging/ramzswap/ramzswap_drv.c   |  837 -----------------------------
 drivers/staging/ramzswap/ramzswap_drv.h   |  167 ------
 drivers/staging/ramzswap/ramzswap_ioctl.h |   42 --
 drivers/staging/ramzswap/xvmalloc.c       |  507 -----------------
 drivers/staging/ramzswap/xvmalloc.h       |   30 -
 drivers/staging/ramzswap/xvmalloc_int.h   |   86 ---
 drivers/staging/zram/Kconfig              |   24 +
 drivers/staging/zram/Makefile             |    3 +
 drivers/staging/zram/xvmalloc.c           |  507 +++++++++++++++++
 drivers/staging/zram/xvmalloc.h           |   30 +
 drivers/staging/zram/xvmalloc_int.h       |   86 +++
 drivers/staging/zram/zram.txt             |   62 +++
 drivers/staging/zram/zram_drv.c           |  809 ++++++++++++++++++++++++++++
 drivers/staging/zram/zram_drv.h           |  167 ++++++
 drivers/staging/zram/zram_ioctl.h         |   42 ++
 20 files changed, 1732 insertions(+), 1746 deletions(-)
 delete mode 100644 drivers/staging/ramzswap/Kconfig
 delete mode 100644 drivers/staging/ramzswap/Makefile
 delete mode 100644 drivers/staging/ramzswap/ramzswap.txt
 delete mode 100644 drivers/staging/ramzswap/ramzswap_drv.c
 delete mode 100644 drivers/staging/ramzswap/ramzswap_drv.h
 delete mode 100644 drivers/staging/ramzswap/ramzswap_ioctl.h
 delete mode 100644 drivers/staging/ramzswap/xvmalloc.c
 delete mode 100644 drivers/staging/ramzswap/xvmalloc.h
 delete mode 100644 drivers/staging/ramzswap/xvmalloc_int.h
 create mode 100644 drivers/staging/zram/Kconfig
 create mode 100644 drivers/staging/zram/Makefile
 create mode 100644 drivers/staging/zram/xvmalloc.c
 create mode 100644 drivers/staging/zram/xvmalloc.h
 create mode 100644 drivers/staging/zram/xvmalloc_int.h
 create mode 100644 drivers/staging/zram/zram.txt
 create mode 100644 drivers/staging/zram/zram_drv.c
 create mode 100644 drivers/staging/zram/zram_drv.h
 create mode 100644 drivers/staging/zram/zram_ioctl.h

