Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1G1WG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:06:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54794 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab1G1WGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:06:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [GIT PULL] arm soc cleanups for 3.1, part 2
Date: Fri, 29 Jul 2011 00:04:14 +0200
Message-ID: <1516952.7OUnxdoZRc@wuerfel>
User-Agent: KMail/4.6.0 (Linux/3.0.0-rc1nosema+; KDE/4.6.90; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Pp4nZe4QL6u+CegbJmaYEdAzATLHjqTJsO8URNRDgCp
 WEFFyfaYs/i1UOzk6IMaEX3F4TnPjysg5+7zRaw72WuxcsbPWZ
 ewTrSoge4wuXL8LLaCMJyo2MvLHL48QknqJwM/lZr6SLYLRmHA
 6IbEvWVM005vQrdQejsE6C03vQNYkY5WdxsmHF2u3MkMjV90gc
 gH/GFk5M58VEU8cBjd58Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a late set of cleanups that I got from Jean-Christophe after you
had already merged all the other patches. I already told him that it's too
late for 3.1, but it seems a bit unfair when I'm also pushing the device
tree rework now.

Please pull if you really feel like it.

	Arnd

The following changes since commit 95b6886526bb510b8370b625a49bc0ab3b8ff10f:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 (2011-07-27 19:26:38 -0700)

are available in the git repository at:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git/ at91/cleanup

Jean-Christophe PLAGNIOL-VILLARD (8):
      at91: introduce commom AT91_BASE_SYS
      at91: factorize at91 interrupts init to soc
      at91: remove AT91_DBGU offset from dbgu register macro
      at91: use structure to store the current soc
      at91: move clock subsystem init to soc generic init
      at91: move register clocks to soc generic init
      at91: factorize sram init
      at91: add arch specific ioremap support

 arch/arm/mach-at91/Makefile                   |    2 +-
 arch/arm/mach-at91/at91cap9.c                 |   45 +---
 arch/arm/mach-at91/at91rm9200.c               |   47 +---
 arch/arm/mach-at91/at91sam9260.c              |  100 ++-------
 arch/arm/mach-at91/at91sam9261.c              |   62 +-----
 arch/arm/mach-at91/at91sam9263.c              |   51 +----
 arch/arm/mach-at91/at91sam9g45.c              |   45 +---
 arch/arm/mach-at91/at91sam9rl.c               |   59 +----
 arch/arm/mach-at91/board-1arm.c               |   11 +-
 arch/arm/mach-at91/board-afeb-9260v1.c        |   12 +-
 arch/arm/mach-at91/board-cam60.c              |   12 +-
 arch/arm/mach-at91/board-cap9adk.c            |   12 +-
 arch/arm/mach-at91/board-carmeva.c            |   11 +-
 arch/arm/mach-at91/board-cpu9krea.c           |   11 +-
 arch/arm/mach-at91/board-cpuat91.c            |   11 +-
 arch/arm/mach-at91/board-csb337.c             |   11 +-
 arch/arm/mach-at91/board-csb637.c             |   11 +-
 arch/arm/mach-at91/board-eb9200.c             |   11 +-
 arch/arm/mach-at91/board-ecbat91.c            |   11 +-
 arch/arm/mach-at91/board-eco920.c             |   11 +-
 arch/arm/mach-at91/board-flexibity.c          |   11 +-
 arch/arm/mach-at91/board-foxg20.c             |   12 +-
 arch/arm/mach-at91/board-gsia18s.c            |    9 +-
 arch/arm/mach-at91/board-kafa.c               |   11 +-
 arch/arm/mach-at91/board-kb9202.c             |   11 +-
 arch/arm/mach-at91/board-neocore926.c         |   12 +-
 arch/arm/mach-at91/board-pcontrol-g20.c       |   11 +-
 arch/arm/mach-at91/board-picotux200.c         |   11 +-
 arch/arm/mach-at91/board-qil-a9260.c          |   12 +-
 arch/arm/mach-at91/board-rm9200dk.c           |   11 +-
 arch/arm/mach-at91/board-rm9200ek.c           |   11 +-
 arch/arm/mach-at91/board-sam9-l9260.c         |   12 +-
 arch/arm/mach-at91/board-sam9260ek.c          |   12 +-
 arch/arm/mach-at91/board-sam9261ek.c          |   12 +-
 arch/arm/mach-at91/board-sam9263ek.c          |   12 +-
 arch/arm/mach-at91/board-sam9g20ek.c          |   16 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c       |   12 +-
 arch/arm/mach-at91/board-sam9rlek.c           |   12 +-
 arch/arm/mach-at91/board-snapper9260.c        |   11 +-
 arch/arm/mach-at91/board-stamp9g20.c          |   16 +-
 arch/arm/mach-at91/board-usb-a9260.c          |   12 +-
 arch/arm/mach-at91/board-usb-a9263.c          |   12 +-
 arch/arm/mach-at91/board-yl-9200.c            |   12 +-
 arch/arm/mach-at91/generic.h                  |   34 +--
 arch/arm/mach-at91/include/mach/at91_dbgu.h   |   27 ++-
 arch/arm/mach-at91/include/mach/at91cap9.h    |    1 -
 arch/arm/mach-at91/include/mach/at91rm9200.h  |    1 -
 arch/arm/mach-at91/include/mach/at91sam9260.h |    1 -
 arch/arm/mach-at91/include/mach/at91sam9261.h |    1 -
 arch/arm/mach-at91/include/mach/at91sam9263.h |    1 -
 arch/arm/mach-at91/include/mach/at91sam9g45.h |    1 -
 arch/arm/mach-at91/include/mach/at91sam9rl.h  |    1 -
 arch/arm/mach-at91/include/mach/cpu.h         |  159 ++++++++------
 arch/arm/mach-at91/include/mach/debug-macro.S |   14 +-
 arch/arm/mach-at91/include/mach/hardware.h    |   14 ++
 arch/arm/mach-at91/include/mach/io.h          |   11 +-
 arch/arm/mach-at91/setup.c                    |  297 +++++++++++++++++++++++++
 arch/arm/mach-at91/soc.h                      |   59 +++++
 58 files changed, 696 insertions(+), 745 deletions(-)
 create mode 100644 arch/arm/mach-at91/setup.c
 create mode 100644 arch/arm/mach-at91/soc.h
