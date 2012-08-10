Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086Ab2HJTGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 15:06:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab2HJTGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 15:06:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL 2/3] arm-soc: late at91 changes
Date: Fri, 10 Aug 2012 21:06:14 +0200
Message-Id: <1344625575-27560-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344625575-27560-1-git-send-email-arnd@arndb.de>
References: <1344625575-27560-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:G/sywAsMxddRAOK7AID2Vpfaw9UO1CKGiYp91hMhHsX
 2wfqA/+T0XUL5Gbzml9gF72zSu0LDMpTpwBuuewReE2+2XiWM6
 GHOlGMYupSsNLJkkCKma/YUqhRYiSnpzkDfaNbaUaQ4WBsWJPe
 V8HoVe8QONk4wzdBLHszYQrH6A5wXUoO4WazJ+FLw19H0ZzXnE
 0ZHga+mRJcBK5kuamGRxBq8YdaAMHklhVzQ7WJrZ/3f9h8U221
 aOD9LOSKiqIAltvh6cOt/+zkWEcfL0x42/jIcDORks84qwUzhq
 NY99zqkiy+1mDUutGVHX4XodDW8JNg2n0C6jP0i83j9iQfonH/
 qWEJEib870KMJN4FpLMol9KZAnZ4ft64e0pjHYlgQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/late-at91-mci

for you to fetch changes up to b3ce167791c02da98f6e527be7d19213b3abddf0:

  Merge tag 'at91-for-next-soc' of git://github.com/at91linux/linux-at91 into at91/mci (2012-08-10 12:34:18 +0200)

----------------------------------------------------------------

arm-soc: late at91 changes

This series was originally sent for inclusion in v3.5 but missed out
twice, first time because it was late for v3.5 and we decided not to
push it then, and this time because the maintainer was on a long
vacation before the merge window and nobody noticed that it was missing
from the v3.6 list.

The main purpose of this series is to move over the at91 board files
to use the atmel-mci driver instead of the old at91_mci that is
scheduled for removal in v3.7.

Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
----------------------------------------------------------------
Arnd Bergmann (1):
      Merge tag 'at91-for-next-soc' of git://github.com/at91linux/linux-at91 into at91/mci

Ludovic Desroches (1):
      ARM: at91: add atmel-mci support for chips and boards which can use it

Nicolas Ferre (1):
      ARM: at91/defconfig: change the MCI driver to use in defconfigs

Paul Bolle (1):
      ARM: at91: set i2c_board_info.type to "ds1339" directly

Richard Genoud (1):
      ARM: at91/defconfig: Remove unaffected config option

 arch/arm/configs/afeb9260_defconfig      |    1 -
 arch/arm/configs/at91rm9200_defconfig    |    2 +-
 arch/arm/configs/at91sam9261_defconfig   |    2 +-
 arch/arm/configs/at91sam9263_defconfig   |    3 +-
 arch/arm/configs/at91sam9g20_defconfig   |    2 +-
 arch/arm/configs/at91sam9rl_defconfig    |    2 +-
 arch/arm/configs/cpu9260_defconfig       |    2 +-
 arch/arm/configs/cpu9g20_defconfig       |    2 +-
 arch/arm/configs/qil-a9260_defconfig     |    3 +-
 arch/arm/configs/stamp9g20_defconfig     |    1 -
 arch/arm/configs/usb-a9260_defconfig     |    1 -
 arch/arm/mach-at91/at91rm9200_devices.c  |   92 ++++++++++-------
 arch/arm/mach-at91/at91sam9260_devices.c |   84 +---------------
 arch/arm/mach-at91/at91sam9261_devices.c |   60 +++++------
 arch/arm/mach-at91/at91sam9263.c         |    4 +-
 arch/arm/mach-at91/at91sam9263_devices.c |  161 +++++++++++++++++-------------
 arch/arm/mach-at91/at91sam9rl_devices.c  |   60 +++++------
 arch/arm/mach-at91/board-afeb-9260v1.c   |   14 +--
 arch/arm/mach-at91/board-carmeva.c       |   14 +--
 arch/arm/mach-at91/board-cpu9krea.c      |   17 ++--
 arch/arm/mach-at91/board-cpuat91.c       |   13 +--
 arch/arm/mach-at91/board-csb337.c        |   14 +--
 arch/arm/mach-at91/board-eb9200.c        |   14 +--
 arch/arm/mach-at91/board-ecbat91.c       |   14 +--
 arch/arm/mach-at91/board-eco920.c        |   14 +--
 arch/arm/mach-at91/board-flexibity.c     |   14 +--
 arch/arm/mach-at91/board-foxg20.c        |   16 +--
 arch/arm/mach-at91/board-kb9202.c        |   14 +--
 arch/arm/mach-at91/board-neocore926.c    |   13 +--
 arch/arm/mach-at91/board-picotux200.c    |   14 +--
 arch/arm/mach-at91/board-qil-a9260.c     |   14 +--
 arch/arm/mach-at91/board-rm9200dk.c      |   14 +--
 arch/arm/mach-at91/board-rm9200ek.c      |   14 +--
 arch/arm/mach-at91/board-rsi-ews.c       |   13 +--
 arch/arm/mach-at91/board-sam9-l9260.c    |   16 +--
 arch/arm/mach-at91/board-sam9260ek.c     |   16 +--
 arch/arm/mach-at91/board-sam9261ek.c     |   13 +--
 arch/arm/mach-at91/board-sam9263ek.c     |   13 +--
 arch/arm/mach-at91/board-sam9g20ek.c     |   16 +--
 arch/arm/mach-at91/board-sam9rlek.c      |   13 +--
 arch/arm/mach-at91/board-stamp9g20.c     |   14 ---
 arch/arm/mach-at91/board-usb-a926x.c     |    2 -
 arch/arm/mach-at91/board-yl-9200.c       |   13 +--
 drivers/mtd/nand/Kconfig                 |   40 --------
 44 files changed, 384 insertions(+), 494 deletions(-)
