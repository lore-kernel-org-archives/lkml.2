Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab2BMRuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:50:13 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:10188 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab2BMRuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:50:11 -0500
Message-ID: <4F394D34.6000604@atmel.com>
Date: Mon, 13 Feb 2012 18:49:40 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Ryan Mallon <rmallon@gmail.com>, Sergei Shtylyov <sshtylyov@mvista.com>
Subject: [GIT PULL] at91: fixes for 3.3-rc4
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof, Arnd,

Here is the second "fixes" pull request. It collects a simple #ifdef fix, the
proper use of ioremap() in the RTC driver and a set of SMC related
modifications.
The SMC has been modified recently and has broken the pata_at91 driver. The
new accessors are fixing this situation. Finally, the old at91_ide driver is
removed because it is not maintained anymore, the IDE tree is frozen and PATA
should be used instead.

I have also verified that it merges correctly with depends/rmk/for-armsoc and all
at91 related 3.4 material...

You can find all this here:

The following changes since commit d65b4e98d7ea3038b767b70fe8be959b2913f16d:

  Linux 3.3-rc3 (2012-02-08 19:21:53 -0800)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git at91-fixes

for you to fetch changes up to cf844751fb25e095d8fa30332cb173a73e5a736c:

  ARM: at91: drop ide driver in favor of the pata one (2012-02-13 18:31:37 +0100)

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (4):
      ARM: at91:rtc/rtc-at91sam9: ioremap register bank
      ARM: at91: add accessor to manage SMC
      pata/at91: use newly introduced SMC accessors
      ARM: at91: drop ide driver in favor of the pata one

Nicolas Ferre (1):
      ARM: at91: USB AT91 gadget registration for module

 arch/arm/mach-at91/at91rm9200_devices.c        |    2 +-
 arch/arm/mach-at91/at91sam9260_devices.c       |    9 +-
 arch/arm/mach-at91/at91sam9261_devices.c       |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c       |    8 +-
 arch/arm/mach-at91/include/mach/at91sam9_smc.h |   29 ++
 arch/arm/mach-at91/sam9_smc.c                  |   76 +++++-
 arch/arm/mach-at91/sam9_smc.h                  |   23 --
 drivers/ata/pata_at91.c                        |   48 ++--
 drivers/ide/Makefile                           |    1 -
 drivers/ide/at91_ide.c                         |  366 ------------------------
 drivers/rtc/rtc-at91sam9.c                     |   13 +-
 11 files changed, 140 insertions(+), 437 deletions(-)
 delete mode 100644 drivers/ide/at91_ide.c

Thanks a lot, best regards,
-- 
Nicolas Ferre
