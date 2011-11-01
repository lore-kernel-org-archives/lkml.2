Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab1KBCY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:24:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63407 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab1KBCXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:23:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 9/13] arm-soc updates spanning multiple platforms
Date: Tue, 1 Nov 2011 13:32:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <201111010348.13214.arnd@arndb.de>
In-Reply-To: <201111010348.13214.arnd@arndb.de>
MIME-Version: 1.0
Message-Id: <201111011332.26469.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:C/opIHhFUJO5pYYrQM42b2aiCgGTq0kl+3AevJJokXZ
 YyBYDqtYnpaY553DnIKq1WzYzYwhgP9FRz9r66SIsBY5/syum9
 c///s41nQ83u3Dm7k/JrgZW6J6HuVmfCUjl4n98y7mUcIc2H6m
 /lO4VW+17BUp319BXVaqScWCYgDWtfDts0lltQAGsBQxsYcgxP
 Zh9jaVjmRgvagYqPqQZJbHI1NQekxVZLCPnQvl0h4eepaprURl
 Tj2BguN2ynySohArDocOmx/tF8fIaHKoetugU9x+vBkLBzEXcc
 gheWpNsepRruy5zreB39h2zDBZrvwbormIz2goINvaejxSJ7Fu
 MJ45swvVYEONQI1JoQ9k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are two patch series from Will Deacon that progress towards having a single kernel
across multiple arm soc families. One is for the early debug output code and the other
one is cleaning up the cpu mapping.

	Arnd

The following changes since commit 5116bf33b95b3b6aeae7903443afcf7379425f2e:

  Merge branch 'next/board' into for-next (2011-11-01 00:39:05 +0100)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git ..BRANCH.NOT.VERIFIED..

Arnd Bergmann (1):
      Merge branches 'cross-platform/debug_ll' and 'cross-platform/cpu-mapping' into next/cross-platform

Shawn Guo (1):
      arm/imx: use Kconfig choice for low-level debug UART selection

Will Deacon (7):
      ARM: exynos4: convert logical CPU numbers to physical numbers
      ARM: msm: convert logical CPU numbers to physical numbers
      ARM: shmobile: convert logical CPU numbers to physical numbers
      ARM: ux500: convert logical CPU numbers to physical numbers
      ARM: versatile: convert logical CPU numbers to physical numbers
      ARM: plat-samsung: use Kconfig choice for debug UART selection
      ARM: realview: use Kconfig choice for debug UART selection


 arch/arm/Kconfig                                  |   25 ++++
 arch/arm/Kconfig.debug                            |  117 +++++++++++++++--
 arch/arm/common/gic.c                             |   17 ++-
 arch/arm/include/asm/cputype.h                    |    6 +
 arch/arm/include/asm/exception.h                  |   19 +++
 arch/arm/include/asm/localtimer.h                 |    4 +
 arch/arm/include/asm/smp.h                        |   11 ++
 arch/arm/include/asm/system.h                     |    7 -
 arch/arm/include/asm/topology.h                   |   33 +++++
 arch/arm/kernel/Makefile                          |    1 +
 arch/arm/kernel/irq.c                             |    2 +-
 arch/arm/kernel/smp.c                             |   32 +++++-
 arch/arm/kernel/smp_scu.c                         |    2 +-
 arch/arm/kernel/topology.c                        |  148 +++++++++++++++++++++
 arch/arm/kernel/traps.c                           |    1 +
 arch/arm/mach-exynos4/hotplug.c                   |    2 +-
 arch/arm/mach-exynos4/platsmp.c                   |    2 +-
 arch/arm/mach-msm/hotplug.c                       |    2 +-
 arch/arm/mach-msm/platsmp.c                       |    2 +-
 arch/arm/mach-mxs/include/mach/debug-macro.S      |   12 +--
 arch/arm/mach-pxa/irq.c                           |    2 +
 arch/arm/mach-realview/hotplug.c                  |    2 +-
 arch/arm/mach-realview/include/mach/debug-macro.S |   17 +--
 arch/arm/mach-shmobile/smp-sh73a0.c               |    6 +-
 arch/arm/mach-ux500/hotplug.c                     |    2 +-
 arch/arm/mach-ux500/platsmp.c                     |    2 +-
 arch/arm/mach-vexpress/hotplug.c                  |    2 +-
 arch/arm/mm/fault.c                               |    1 +
 arch/arm/plat-mxc/include/mach/debug-macro.S      |   38 +-----
 arch/arm/plat-samsung/Kconfig                     |    7 +
 arch/arm/plat-versatile/platsmp.c                 |    2 +-
 31 files changed, 434 insertions(+), 92 deletions(-)
 create mode 100644 arch/arm/include/asm/exception.h
 create mode 100644 arch/arm/kernel/topology.c

