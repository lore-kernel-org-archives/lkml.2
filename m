Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1A0Kxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:53:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46461 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab1A0Kxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:53:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=c2nCqs36fI32gtfsqeg9ZC6wdxrsBfgV+l1Cynlw+GUuAzUVKD6UFurbw+p+VgBLBs
         /NOWd00yzFi3luBcnavTHns+Jpau+ag0tEguuxBHEWwjn9dACESiKPE4YwUK+9eysRs2
         5X4RYN972XEXpgKDt7sTzaego8T1AD62Rl3jc=
Date: Thu, 27 Jan 2011 11:53:31 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH V10 00/15] ptp: IEEE 1588 hardware clock support
Message-ID: <cover.1296124770.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is version 10 of the PHC patch series. We missed the boat for
2.6.38, but I hope this can be merged for the next one.

Reviewers: I think its done. How can I get this merged?

Arch maintainers (arm, blackfin, powerpc, x86): I have added you on
CC in the hope of getting your acks for the new syscall.

Thanks,
Richard

* Patch ChangeLog
** v10
*** posix clocks
    - removed the (previously implied) default functions from the k_clocks
    - made the ts parameter 'const' in clock_set functions
*** ptp hardware clocks
    - updated to changed PPS kernel API

* Introduction

  The aim of this patch set is to add support for PTP Hardware Clocks
  (PHCs) into the Linux kernel.

  The first eleven patches provide infrastructure supporting dynamic
  POSIX clock devices. This new code will be useful for other kinds of
  new clocks, not just PHCs.

  The last four patches implement the PHC code.

  Support for obtaining timestamps from a PHC already exists via the
  SO_TIMESTAMPING socket option, integrated in kernel version 2.6.30.
  This patch set completes the picture by allow user space programs to
  adjust the PHC and to control its ancillary features.

* Previous Discussions

  This patch set previously appeared on the netdev list. Since V5 of
  the character device patch set, the discussion has moved to the
  lkml.

  - IEEE 1588 hardware clock support [V5]
    http://lkml.org/lkml/2010/8/16/90

  - POSIX clock tuning syscall with static clock ids
    http://lkml.org/lkml/2010/8/23/49

  - POSIX clock tuning syscall with dynamic clock ids
    http://lkml.org/lkml/2010/9/3/119

  - IEEE 1588 hardware clock support [V6]
    http://lkml.org/lkml/2010/9/23/310

  - Dynamic clock devices [RFC]
    http://lkml.org/lkml/2010/11/4/290

  - IEEE 1588 hardware clock support [V7]
    http://lkml.org/lkml/2010/12/16/195

  - IEEE 1588 hardware clock support [V8]
    http://lkml.org/lkml/2010/12/31/128

  - IEEE 1588 hardware clock support [V9]
    http://lkml.org/lkml/2011/1/13/65


John Stultz (1):
  time: Introduce timekeeping_inject_offset

Richard Cochran (14):
  time: Correct the *settime* parameters
  ntp: add ADJ_SETOFFSET mode bit
  posix clocks: introduce a syscall for clock tuning.
  posix_clocks: add clock_adjtime for arm
  posix_clocks: add clock_adjtime for blackfin
  posix_clocks: add clock_adjtime for powerpc
  posix_clocks: add clock_adjtime for x86
  posix clocks: cleanup the CLOCK_DISPTACH macro
  posix clocks: remove useless default methods
  posix clocks: introduce dynamic clocks
  ptp: Added a brand new class driver for ptp clocks.
  ptp: Added a clock that uses the eTSEC found on the MPC85xx.
  ptp: Added a clock driver for the IXP46x.
  ptp: Added a clock driver for the National Semiconductor PHYTER.

 Documentation/ABI/testing/sysfs-ptp             |   98 +++
 Documentation/powerpc/dts-bindings/fsl/tsec.txt |   57 ++
 Documentation/ptp/ptp.txt                       |   89 +++
 Documentation/ptp/testptp.c                     |  352 +++++++++
 Documentation/ptp/testptp.mk                    |   33 +
 arch/arm/include/asm/unistd.h                   |    1 +
 arch/arm/kernel/calls.S                         |    1 +
 arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h   |   78 ++
 arch/blackfin/include/asm/unistd.h              |    3 +-
 arch/blackfin/mach-common/entry.S               |    1 +
 arch/powerpc/boot/dts/mpc8313erdb.dts           |   14 +
 arch/powerpc/boot/dts/mpc8572ds.dts             |   14 +
 arch/powerpc/boot/dts/p2020ds.dts               |   14 +
 arch/powerpc/boot/dts/p2020rdb.dts              |   14 +
 arch/powerpc/include/asm/systbl.h               |    1 +
 arch/powerpc/include/asm/unistd.h               |    3 +-
 arch/x86/ia32/ia32entry.S                       |    1 +
 arch/x86/include/asm/unistd_32.h                |    3 +-
 arch/x86/include/asm/unistd_64.h                |    2 +
 arch/x86/kernel/syscall_table_32.S              |    1 +
 drivers/Kconfig                                 |    2 +
 drivers/Makefile                                |    1 +
 drivers/char/mmtimer.c                          |    3 +-
 drivers/net/Makefile                            |    1 +
 drivers/net/arm/ixp4xx_eth.c                    |  192 +++++-
 drivers/net/gianfar_ptp.c                       |  448 +++++++++++
 drivers/net/gianfar_ptp_reg.h                   |  113 +++
 drivers/net/phy/Kconfig                         |   29 +
 drivers/net/phy/Makefile                        |    1 +
 drivers/net/phy/dp83640.c                       |  896 +++++++++++++++++++++++
 drivers/net/phy/dp83640_reg.h                   |  261 +++++++
 drivers/ptp/Kconfig                             |   53 ++
 drivers/ptp/Makefile                            |    7 +
 drivers/ptp/ptp_chardev.c                       |  144 ++++
 drivers/ptp/ptp_clock.c                         |  315 ++++++++
 drivers/ptp/ptp_ixp46x.c                        |  332 +++++++++
 drivers/ptp/ptp_private.h                       |   85 +++
 drivers/ptp/ptp_sysfs.c                         |  226 ++++++
 include/linux/Kbuild                            |    1 +
 include/linux/posix-clock.h                     |  150 ++++
 include/linux/posix-timers.h                    |   28 +-
 include/linux/ptp_clock.h                       |   79 ++
 include/linux/ptp_clock_kernel.h                |  141 ++++
 include/linux/security.h                        |    9 +-
 include/linux/syscalls.h                        |    2 +
 include/linux/time.h                            |    8 +-
 include/linux/timex.h                           |    3 +-
 kernel/compat.c                                 |  136 +++--
 kernel/posix-cpu-timers.c                       |    6 +
 kernel/posix-timers.c                           |  245 ++++---
 kernel/time.c                                   |    2 +-
 kernel/time/Makefile                            |    3 +-
 kernel/time/ntp.c                               |   11 +
 kernel/time/posix-clock-syscalls.h              |   39 +
 kernel/time/posix-clock.c                       |  432 +++++++++++
 kernel/time/timekeeping.c                       |   38 +-
 security/commoncap.c                            |    2 +-
 security/security.c                             |    2 +-
 58 files changed, 5062 insertions(+), 164 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-ptp
 create mode 100644 Documentation/ptp/ptp.txt
 create mode 100644 Documentation/ptp/testptp.c
 create mode 100644 Documentation/ptp/testptp.mk
 create mode 100644 arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h
 create mode 100644 drivers/net/gianfar_ptp.c
 create mode 100644 drivers/net/gianfar_ptp_reg.h
 create mode 100644 drivers/net/phy/dp83640.c
 create mode 100644 drivers/net/phy/dp83640_reg.h
 create mode 100644 drivers/ptp/Kconfig
 create mode 100644 drivers/ptp/Makefile
 create mode 100644 drivers/ptp/ptp_chardev.c
 create mode 100644 drivers/ptp/ptp_clock.c
 create mode 100644 drivers/ptp/ptp_ixp46x.c
 create mode 100644 drivers/ptp/ptp_private.h
 create mode 100644 drivers/ptp/ptp_sysfs.c
 create mode 100644 include/linux/posix-clock.h
 create mode 100644 include/linux/ptp_clock.h
 create mode 100644 include/linux/ptp_clock_kernel.h
 create mode 100644 kernel/time/posix-clock-syscalls.h
 create mode 100644 kernel/time/posix-clock.c

