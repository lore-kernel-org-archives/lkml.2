Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2AIWwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:52:34 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51464 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899Ab2AIWwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:52:30 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Konrad Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] staging: zsmalloc: memory allocator for compressed pages
Date: Mon,  9 Jan 2012 16:51:55 -0600
Message-Id: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 12010922-6078-0000-0000-00000688A29D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces a new memory allocation library named
zsmalloc.  zsmalloc was designed to fulfill the needs
of users where:
 1) Memory is constrained, preventing contiguous page allocations
    larger than order 0 and
 2) Allocations are all/commonly greater than half a page.

In a generic allocator, an allocation set like this would
cause high fragmentation.  The allocations can't span non-
contiguous page boundaries; therefore, the part of the page
unused by each allocation is wasted.

zsmalloc is a slab-based allocator that uses a non-standard
malloc interface, requiring the user to map the allocation
before accessing it. This allows allocations to span two
non-contiguous pages using virtual memory mapping, greatly
reducing fragmentation in the memory pool.

Nitin Gupta (3):
  staging: zsmalloc: zsmalloc memory allocation library
  staging: zram: replace xvmalloc with zsmalloc
  staging: zram: remove xvmalloc

Seth Jennings (2):
  staging: add zsmalloc to Kconfig/Makefile
  staging: zcache: replace xvmalloc with zsmalloc

 drivers/staging/Kconfig                  |    2 +
 drivers/staging/Makefile                 |    2 +-
 drivers/staging/zcache/Kconfig           |    2 +-
 drivers/staging/zcache/zcache-main.c     |   83 ++--
 drivers/staging/zram/Kconfig             |    6 +-
 drivers/staging/zram/Makefile            |    1 -
 drivers/staging/zram/xvmalloc.c          |  510 --------------------
 drivers/staging/zram/xvmalloc.h          |   30 --
 drivers/staging/zram/xvmalloc_int.h      |   95 ----
 drivers/staging/zram/zram_drv.c          |   89 ++--
 drivers/staging/zram/zram_drv.h          |   10 +-
 drivers/staging/zram/zram_sysfs.c        |    2 +-
 drivers/staging/zsmalloc/Kconfig         |   11 +
 drivers/staging/zsmalloc/Makefile        |    3 +
 drivers/staging/zsmalloc/zsmalloc-main.c |  756 ++++++++++++++++++++++++++++++
 drivers/staging/zsmalloc/zsmalloc.h      |   31 ++
 drivers/staging/zsmalloc/zsmalloc_int.h  |  126 +++++
 17 files changed, 1020 insertions(+), 739 deletions(-)
 delete mode 100644 drivers/staging/zram/xvmalloc.c
 delete mode 100644 drivers/staging/zram/xvmalloc.h
 delete mode 100644 drivers/staging/zram/xvmalloc_int.h
 create mode 100644 drivers/staging/zsmalloc/Kconfig
 create mode 100644 drivers/staging/zsmalloc/Makefile
 create mode 100644 drivers/staging/zsmalloc/zsmalloc-main.c
 create mode 100644 drivers/staging/zsmalloc/zsmalloc.h
 create mode 100644 drivers/staging/zsmalloc/zsmalloc_int.h

-- 
1.7.5.4

