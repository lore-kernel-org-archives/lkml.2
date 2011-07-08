Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1GHQP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 12:15:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55769 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1GHQPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 12:15:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] arm-soc fixes for 3.0
Date: Fri, 8 Jul 2011 18:15:14 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Simon Guinot <sguinot@lacie.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Lei Wen <leiwen@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107081815.14283.arnd@arndb.de>
X-Provags-ID: V02:K0:rJkFoQ1GJ7EsffTxhUumBx0u/9VqoDhMLTaWFLbUs4X
 /HHXPvlG3EMe8KH/yDUED54qV2cv9oyJHwbfcZrYqBzpL7sF9a
 EM1yb4Act7slU2J5CrmPhgBj+eS+bZ5M6ltfrK+VhiI2Cmcada
 /z5C8pudujaMFi+f27JgFewdw0xtE+hXFF6WVJunlX3GGbFAtc
 XMXFbUlUC4bhd91VXaOTA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Another round of fixes from the arm-soc tree. The three patches for pxa are for
long-standing bugs and will go in the stable trees. The other two are fixing
fallout from the generic irqchip conversion.

	Arnd

---
The following changes since commit f1bb20a8365f6753e0f7b6e94981ca2b662bae13:

  Merge branch 'for-30-rc5/all-i2c' of git://git.fluff.org/bjdooks/linux (2011-07-07 16:29:29 -0700)

are available in the git repository at:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git fixes

Lei Wen (2):
      ARM: pxa910: correct nand pmu setting
      ARM: pxa168: correct nand pmu setting

Paul Parsons (1):
      ARM: pxa: fix PGSR register address calculation

Simon Guinot (1):
      genirq: replace irq_gc_ack() with {set,clr}_bit variants (fwd)

Wolfram Sang (1):
      arm: mach-vt8500: add forgotten irq_data conversion

 arch/arm/mach-davinci/irq.c      |    2 +-
 arch/arm/mach-mmp/pxa168.c       |    2 +-
 arch/arm/mach-mmp/pxa910.c       |    2 +-
 arch/arm/mach-pxa/mfp-pxa2xx.c   |    4 ++--
 arch/arm/mach-vt8500/irq.c       |   21 ++++++++++++---------
 arch/arm/plat-orion/gpio.c       |    2 +-
 arch/arm/plat-s5p/irq-gpioint.c  |    2 +-
 arch/arm/plat-samsung/irq-uart.c |    2 +-
 include/linux/irq.h              |    3 ++-
 kernel/irq/generic-chip.c        |   18 ++++++++++++++++--
 10 files changed, 38 insertions(+), 20 deletions(-)
