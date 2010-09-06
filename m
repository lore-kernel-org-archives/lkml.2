Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0IFGeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 02:34:22 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24864 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab0IFGeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 02:34:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 06 Sep 2010 08:33:50 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [RFCv5 0/9] CMA + VCMM integration
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jonathan Corbet <corbet@lwn.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Zach Pfeffer <zpfeffer@codeaurora.org>, linux-kernel@vger.kernel.org
Message-id: <cover.1283749231.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

This patchset introduces a draft of a redesign of Zach Pfeffer's
VCMM.  Not all of the functionality of the original VCMM has been
ported into this patchset.  This is mostly meant as RFC.  Moreover,
the code for VCMM implementation in this RFC has not been tested.

CMA has not been changed compared to the previous CMA versions so no
aspects discussed on the list have been addressed yet.

The redesigned VCMM now uses notion of drivers -- a VCM context is
created for each MMU on the platform and each such context is handled
by a VCM driver.  A context (or may contexts) for One-to-One mappings
is created as well and handled with a One-to-One VCM driver.

The patchset introduces a sample (or a template if you will) VCM MMU
driver as well as a VCM CMA One-to-One driver so it is shown by
example how VCM drivers are written.

The VCMM framework proposed by this patchset also introduces
a vcm_make_binding() call which allocates physical memory, creates
virtual address reservation and binds the two together.  This makes
life easier for One-to-One mappings and if device drivers limit their
use of VCM API to a subset of functionality the can work on systems
with or without MMU with no modifications (only the VCM context would
need to change).

Please refer to documentation in the second and seventh patch for more
information regarding CMA and VCMM respectively.

Michal Nazarewicz (9):
  lib: rbtree: rb_root_init() function added
  mm: cma: Contiguous Memory Allocator added
  mm: cma: Added SysFS support
  mm: cma: Added command line parameters support
  mm: cma: Test device and application added
  ARM: cma: Added CMA to Aquila, Goni and c210 universal boards
  mm: vcm: Virtual Contiguous Memory framework added
  mm: vcm: Sample driver added
  mm: vcm: vcm-cma: VCM CMA driver added

 Documentation/00-INDEX                             |    4 +
 .../ABI/testing/sysfs-kernel-mm-contiguous         |   53 +
 Documentation/contiguous-memory.txt                |  623 +++++++++
 Documentation/kernel-parameters.txt                |    7 +
 Documentation/virtual-contiguous-memory.txt        |  866 ++++++++++++
 arch/arm/mach-s5pv210/mach-aquila.c                |   31 +
 arch/arm/mach-s5pv210/mach-goni.c                  |   31 +
 arch/arm/mach-s5pv310/mach-universal_c210.c        |   23 +
 drivers/misc/Kconfig                               |    8 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/cma-dev.c                             |  202 +++
 include/linux/cma.h                                |  479 +++++++
 include/linux/rbtree.h                             |   11 +
 include/linux/vcm-cma.h                            |   38 +
 include/linux/vcm-drv.h                            |  299 +++++
 include/linux/vcm-sample.h                         |   30 +
 include/linux/vcm.h                                |  275 ++++
 mm/Kconfig                                         |  123 ++
 mm/Makefile                                        |    5 +
 mm/cma-best-fit.c                                  |  407 ++++++
 mm/cma.c                                           | 1377 ++++++++++++++++++++
 mm/vcm-cma.c                                       |   84 ++
 mm/vcm-sample.c                                    |  120 ++
 mm/vcm.c                                           |  932 +++++++++++++
 tools/cma/cma-test.c                               |  386 ++++++
 25 files changed, 6415 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-mm-contiguous
 create mode 100644 Documentation/contiguous-memory.txt
 create mode 100644 Documentation/virtual-contiguous-memory.txt
 create mode 100644 drivers/misc/cma-dev.c
 create mode 100644 include/linux/cma.h
 create mode 100644 include/linux/vcm-cma.h
 create mode 100644 include/linux/vcm-drv.h
 create mode 100644 include/linux/vcm-sample.h
 create mode 100644 include/linux/vcm.h
 create mode 100644 mm/cma-best-fit.c
 create mode 100644 mm/cma.c
 create mode 100644 mm/vcm-cma.c
 create mode 100644 mm/vcm-sample.c
 create mode 100644 mm/vcm.c
 create mode 100644 tools/cma/cma-test.c

