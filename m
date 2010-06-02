Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab0FBXTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:19:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39055 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab0FBXTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:19:22 -0400
MIME-Version: 1.0
From: Marcelo Roberto Jimenez <mroberto@cetuc.puc-rio.br>
Date: Wed, 2 Jun 2010 20:19:01 -0300
X-Google-Sender-Auth: 4bYdOBqSIL-kLfXIKa6ix_2yEIA
Message-ID: <AANLkTilh4NtHS5p3tWbMtIU9MBBC-Md13Aw9_RdL3Ogp@mail.gmail.com>
Subject: Pull request for nanoengine
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-pcmcia@lists.infradead.org
Cc: linux@arm.linux.org.uk, mad_soft@inbox.ru, rpjday@crashcourse.ca,
       jaswinderrajput@gmail.com, kristoffer.ericson@gmail.com,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following is a compilation of all the patches I have done for the
nanoengine. Some of these are also valid for SA11xx based machines
like, e.g, sharp Zaurus.

These are just stable and tested patches, this does not include the
PCI patches. All of them have been previously submitted to LKML and
all critics have been included. The patches should be well commented,
in their changesets, but anyway here goes a quick summary:

1) ARM: mach-sa1100: Put nanoEngine support back in the kernel.
2) ARM: mach-sa1100: Add a defconfig for nanoEngine.
3) ARM: mach-sa1100: Fix for compiler warning of uninitialized variable.
4) ARM: mach-sa1100: Fix checkpatch.pl issues in
arch/arm/mach-sa1100/cpu-sa1100.c.
5) ARM: mach-sa1100: Fix checkpatch.pl issues in
arch/arm/mach-sa1100/cpu-sa1110.c.
6) ARM: mach-sa1100: Fix checkpatch.pl issues in drivers/rtc/rtc-sa1100.c.
7) ARM: mach-sa1100: Print the value of RTSR on /proc/drivers/rtc.
- Self explanatory/trivial patches.

8) ARM: mach-sa1100: Fix for a nasty initialization bug in the RTSR.
- Fixes a bug that could cause the system to hang.

9) ARM: mach-sa1100: Better use of the RTC framework for sa11xx.
- This patch uses the new RTC framework to treat some common ioctl.

10) ARM: pcmcia: Fix for building DEBUG with sa11xx_base.c as a module.
- The symbol soc_pcmcia_debug was not beeing exported.

11) ARM: pcmcia: Fix checkpatch.pl issues in drivers/pcmcia/soc_common.c
- Trivial.

12) ARM: pcmcia: Adds nanoEngine PCMCIA support.
- Adds nanoEngine PCMCIA support for two sockets.

Regards,
Marcelo.

--
The following changes since commit aef4b9aaae1decc775778903922bd0075cce7a88:

  Merge branch 'next' of
git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2010-06-01
14:13:14 -0700)

are available in the git repository at:

  git@github.com:mrjimenez/linux-2.6.git nanoengine

Marcelo Roberto Jimenez (12):
      ARM: mach-sa1100: Put nanoEngine support back in the kernel.
      ARM: mach-sa1100: Add a defconfig for nanoEngine.
      ARM: mach-sa1100: Fix for compiler warning of uninitialized variable.
      ARM: mach-sa1100: Fix checkpatch.pl issues in
arch/arm/mach-sa1100/cpu-sa1100.c.
      ARM: mach-sa1100: Fix checkpatch.pl issues in
arch/arm/mach-sa1100/cpu-sa1110.c.
      ARM: mach-sa1100: Fix checkpatch.pl issues in drivers/rtc/rtc-sa1100.c.
      ARM: mach-sa1100: Print the value of RTSR on /proc/drivers/rtc.
      ARM: mach-sa1100: Fix for a nasty initialization bug in the RTSR.
      ARM: mach-sa1100: Better use of the RTC framework for sa11xx.
      ARM: pcmcia: Fix for building DEBUG with sa11xx_base.c as a module.
      ARM: pcmcia: Fix checkpatch.pl issues in drivers/pcmcia/soc_common.c
      ARM: pcmcia: Adds nanoEngine PCMCIA support.

 arch/arm/configs/nanoengine_defconfig          | 1396 ++++++++++++++++++++++++
 arch/arm/mach-sa1100/Kconfig                   |    8 +
 arch/arm/mach-sa1100/Makefile                  |    2 +
 arch/arm/mach-sa1100/cpu-sa1100.c              |   56 +-
 arch/arm/mach-sa1100/cpu-sa1110.c              |   51 +-
 arch/arm/mach-sa1100/include/mach/nanoengine.h |   30 +
 arch/arm/mach-sa1100/nanoengine.c              |  115 ++
 drivers/pcmcia/Makefile                        |    3 +-
 drivers/pcmcia/sa1100_generic.c                |    3 +
 drivers/pcmcia/sa1100_generic.h                |    1 +
 drivers/pcmcia/sa1100_nanoengine.c             |  219 ++++
 drivers/pcmcia/soc_common.c                    |  129 ++-
 drivers/rtc/rtc-sa1100.c                       |  153 ++-
 13 files changed, 2021 insertions(+), 145 deletions(-)
 create mode 100644 arch/arm/configs/nanoengine_defconfig
 create mode 100644 arch/arm/mach-sa1100/include/mach/nanoengine.h
 create mode 100644 arch/arm/mach-sa1100/nanoengine.c
 create mode 100644 drivers/pcmcia/sa1100_nanoengine.c
