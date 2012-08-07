Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab2HGNav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:30:51 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:15269 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2HGNau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:30:50 -0400
Message-ID: <5021189C.2010107@atmel.com>
Date: Tue, 7 Aug 2012 15:31:08 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] at91: soc update (for 3.6)
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd, hi Olof,

Here is an additional AT91 pull request that is 
still related with the replacement of sd/mmc 
platform data.

(it doesn't merge seamlessly with current 
Linus' tree: I can provide a resolution hint or
rebase this work if necessary).

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-for-next-soc

for you to fetch changes up to 4cf3326ab5f34a333a46c59d0d3783db9cef13bf:

  ARM: at91: add atmel-mci support for chips and boards which can use it (2012-07-02 18:03:01 +0200)

----------------------------------------------------------------
AT91 SoC related code modifications: a cleanup in defconfigs and
a one liner in a board file.
The most important is the move to atmel-mci driver in AT91 SoC & boards.
The old at91_mci (marked as deprecated) will be removed in 3.7. So all
platform data for this old driver are erased and replace by information
needed by atmel-mci driver.

----------------------------------------------------------------
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
 arch/arm/mach-at91/at91rm9200_devices.c  |   92 ++++++++++++++++++++++++-----------------
 arch/arm/mach-at91/at91sam9260_devices.c |   84 +-------------------------------------
 arch/arm/mach-at91/at91sam9261_devices.c |   60 +++++++++++++--------------
 arch/arm/mach-at91/at91sam9263.c         |    4 +-
 arch/arm/mach-at91/at91sam9263_devices.c |  161 ++++++++++++++++++++++++++++++++++++++++++------------------------------
 arch/arm/mach-at91/at91sam9rl_devices.c  |   60 +++++++++++++--------------
 arch/arm/mach-at91/board-afeb-9260v1.c   |   14 +++----
 arch/arm/mach-at91/board-carmeva.c       |   14 +++----
 arch/arm/mach-at91/board-cpu9krea.c      |   17 ++++----
 arch/arm/mach-at91/board-cpuat91.c       |   13 +++---
 arch/arm/mach-at91/board-csb337.c        |   14 +++----
 arch/arm/mach-at91/board-eb9200.c        |   14 +++----
 arch/arm/mach-at91/board-ecbat91.c       |   14 +++----
 arch/arm/mach-at91/board-eco920.c        |   14 +++----
 arch/arm/mach-at91/board-flexibity.c     |   14 +++----
 arch/arm/mach-at91/board-foxg20.c        |   16 ++++----
 arch/arm/mach-at91/board-kb9202.c        |   14 +++----
 arch/arm/mach-at91/board-neocore926.c    |   13 +++---
 arch/arm/mach-at91/board-picotux200.c    |   14 +++----
 arch/arm/mach-at91/board-qil-a9260.c     |   14 +++----
 arch/arm/mach-at91/board-rm9200dk.c      |   14 +++----
 arch/arm/mach-at91/board-rm9200ek.c      |   14 +++----
 arch/arm/mach-at91/board-rsi-ews.c       |   13 +++---
 arch/arm/mach-at91/board-sam9-l9260.c    |   16 ++++----
 arch/arm/mach-at91/board-sam9260ek.c     |   16 ++++----
 arch/arm/mach-at91/board-sam9261ek.c     |   13 +++---
 arch/arm/mach-at91/board-sam9263ek.c     |   13 +++---
 arch/arm/mach-at91/board-sam9g20ek.c     |   16 +-------
 arch/arm/mach-at91/board-sam9rlek.c      |   13 +++---
 arch/arm/mach-at91/board-stamp9g20.c     |   14 -------
 arch/arm/mach-at91/board-usb-a926x.c     |    2 -
 arch/arm/mach-at91/board-yl-9200.c       |   13 +++---
 drivers/mtd/nand/Kconfig                 |   40 ------------------
 44 files changed, 384 insertions(+), 494 deletions(-)

Thanks, best regards,
-- 
Nicolas Ferre

