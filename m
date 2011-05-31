Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab1EaSOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:14:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35758 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab1EaSOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:14:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6362"; a="94658397"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] strict user copy checks on x86_64
Date: Tue, 31 May 2011 11:14:29 -0700
Message-Id: <1306865673-20560-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.3.367.ga9930
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I'm sending this to you because these weren't picked up
last round and the final patch is cross architecture.

Backstory
---------
It turns out that strict user copy checks (also known as
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS) isn't actually implemented
on x86_64 and thus we aren't catching potential security holes
at compile time.

This series adds support for strict user copy checks on x86_64
and silences all the benign warnings in the x86_64 allyesconfig for
linux-next 20110531.

The final patch consolidates the config option as its duplicated
across mutliple arches.

Stephen Boyd (4):
  lpfc: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
  kprobes: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
  x86: Implement strict user copy checks for x86_64
  Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS

 arch/parisc/Kconfig               |    1 +
 arch/parisc/Kconfig.debug         |   14 --------------
 arch/s390/Kconfig                 |    1 +
 arch/s390/Kconfig.debug           |   14 --------------
 arch/s390/lib/Makefile            |    1 -
 arch/s390/lib/usercopy.c          |    8 --------
 arch/sparc/lib/Makefile           |    1 -
 arch/sparc/lib/usercopy.c         |    8 --------
 arch/tile/Kconfig                 |    8 +-------
 arch/tile/include/asm/uaccess.h   |    7 ++++++-
 arch/tile/lib/uaccess.c           |    8 --------
 arch/x86/Kconfig                  |    1 +
 arch/x86/Kconfig.debug            |   14 --------------
 arch/x86/include/asm/uaccess_64.h |   12 +++++++++---
 arch/x86/lib/usercopy_32.c        |    6 ------
 drivers/scsi/lpfc/lpfc_debugfs.c  |    3 ++-
 kernel/kprobes.c                  |    2 +-
 lib/Kconfig.debug                 |   18 ++++++++++++++++++
 lib/Makefile                      |    1 +
 lib/usercopy.c                    |    8 ++++++++
 20 files changed, 49 insertions(+), 87 deletions(-)
 delete mode 100644 arch/s390/lib/usercopy.c
 delete mode 100644 arch/sparc/lib/usercopy.c
 create mode 100644 lib/usercopy.c

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

