Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1JQOfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:35:30 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:49315
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755990Ab1JQOf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:35:29 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz936eK4015Lzz1202hzz8275bhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LT7SIX-01-BYQ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [PATCH 0/5] oprofile: Updates and fixes for timer modes
Date: Mon, 17 Oct 2011 16:26:59 +0200
Message-ID: <1318861624-715-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes and updates hr and nmi timer modes of
oprofile. I got bug reports of crashes while unloading the oprofile
module. There are two fixes that address this. The fixes are also for
linux-stable. Another patch reworks the nmi timer mode. This was
neccessary due to the removal of the x86 watchdog. Now nmi timer mode
uses perf event to setup the nmi tick source. The other patches
improve testability and ease exit code.

After review I will apply the patches to the oprofile tree.

Thanks,

-Robert


The following changes since commit 910e94dd0cc5abacebf0bd5ffd859f61b9583857:

  Merge branch 'tip/perf/core' of git://github.com/rostedt/linux into perf/core (2011-10-12 17:14:47 +0200)

Robert Richter (5):
      oprofile, x86: Add kernel parameter oprofile.cpu_type=timer
      oprofile: Fix crash when unloading module (hr timer mode)
      oprofile, x86: Fix crash when unloading module (nmi timer mode)
      oprofile: Remove exit function for timer mode
      oprofile, x86: Reimplement nmi timer mode using perf event

 Documentation/kernel-parameters.txt |    3 +
 arch/Kconfig                        |    4 +
 arch/x86/oprofile/Makefile          |    3 +-
 arch/x86/oprofile/init.c            |    7 +-
 arch/x86/oprofile/nmi_int.c         |   27 ++++-
 arch/x86/oprofile/nmi_timer_int.c   |   66 -------------
 drivers/oprofile/nmi_timer_int.c    |  172 +++++++++++++++++++++++++++++++++++
 drivers/oprofile/oprof.c            |   37 ++++++--
 drivers/oprofile/oprof.h            |    9 ++
 drivers/oprofile/timer_int.c        |   29 +++---
 kernel/events/core.c                |    2 +
 11 files changed, 261 insertions(+), 98 deletions(-)
 delete mode 100644 arch/x86/oprofile/nmi_timer_int.c
 create mode 100644 drivers/oprofile/nmi_timer_int.c



