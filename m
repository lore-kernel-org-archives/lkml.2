Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab1JSSsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:48:36 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:41975
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751710Ab1JSSsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:48:35 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LTBTKS-01-JZK-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>
Subject: [V2][PATCH 0/5] oprofile: Updates and fixes for timer modes
Date: Wed, 19 Oct 2011 20:47:50 +0200
Message-ID: <1319050075-23901-1-git-send-email-robert.richter@amd.com>
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


V2:

Only changes in patch #5:
* removing pr_info()
* fix undefined reference to `__udivdi3' for 32 bit build
* fix section mismatch of .cpuinit.data:nmi_timer_cpu_nb
* removed nmi timer setup in arch/x86
* implemented function stubs for op_nmi_init/exit()
* made code more readable in oprofile_init()

Robert Richter (5):
  oprofile, x86: Add kernel parameter oprofile.cpu_type=timer
  oprofile: Fix crash when unloading module (hr timer mode)
  oprofile, x86: Fix crash when unloading module (nmi timer mode)
  oprofile: Remove exit function for timer mode
  oprofile, x86: Reimplement nmi timer mode using perf event

 Documentation/kernel-parameters.txt |    3 +
 arch/Kconfig                        |    4 +
 arch/x86/oprofile/Makefile          |    3 +-
 arch/x86/oprofile/init.c            |   25 ++----
 arch/x86/oprofile/nmi_int.c         |   27 ++++-
 arch/x86/oprofile/nmi_timer_int.c   |   66 -------------
 drivers/oprofile/nmi_timer_int.c    |  173 +++++++++++++++++++++++++++++++++++
 drivers/oprofile/oprof.c            |   21 ++++-
 drivers/oprofile/oprof.h            |    9 ++
 drivers/oprofile/timer_int.c        |   29 +++---
 kernel/events/core.c                |    2 +
 11 files changed, 252 insertions(+), 110 deletions(-)
 delete mode 100644 arch/x86/oprofile/nmi_timer_int.c
 create mode 100644 drivers/oprofile/nmi_timer_int.c

-- 
1.7.7


