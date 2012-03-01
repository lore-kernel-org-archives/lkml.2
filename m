Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866Ab2CAOxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 09:53:52 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:19493 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab2CAOxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 09:53:50 -0500
Message-ID: <4F4F8D66.7040205@atmel.com>
Date: Thu, 01 Mar 2012 15:53:26 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL v2] at91: irqdomain and device tree for 3.4
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd and Olof,

This pull request supersedes the previous:
"[GIT PULL] at91: irqdomain and device tree for AIC and GPIO"

This series adds irqdomain and device tree support for both the
interrupt and GPIO controllers of AT91 SoC. It has been discussed a lot
and I think that I have addressed all comments and advices.

To the AIC, GPIO device tree work, it also adds the the conversion of the 
PIT and TC timers, the PIO3 support and some basic LED and gpio-keys entries.

The irqdomain work takes advantage of Grant's patch series that is present
in:
git://git.secretlab.ca/git/linux-2.6 irqdomain/next
This branch is merged into this tree, on top of at91/base2+cleanup (aka cleanup2)
and before the application of new AT91 material.


The following changes since commit 89d4a1753b6632327f18d6c8e0842b366b736621:

  Merge branch 'irqdomain/next' of git://git.secretlab.ca/git/linux-2.6 (2012-03-01 13:26:51 +0100)

are available in the git repository at:


  git://github.com/at91linux/linux-at91.git at91-3.4-cleanup2+DT


for you to fetch changes up to f75622f4679479d352d2fa83e0d84c6c13cfcb5f:

  ARM: at91: at91sam9x5cm/dt: add leds support (2012-03-01 22:34:22 +0800)

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (6):
      ARM: at91: pit add DT support
      ARM: at91: usb_a9g20/dt: add leds support
      ARM: at91: at91sam9m10g45ek/dt: add gpio-keys support
      ARM: at91: usb_a9g20/dt: add gpio-keys support
      ARM: at91: at91sam9x5cm/dt: add leds support

Nicolas Ferre (16):
      ARM: at91/aic: add irq domain and device tree support
      ARM: at91/snapper9260: move gpio_to_irq out of structure initialization
      ARM/USB: at91/ohci-at91: remove the use of irq_to_gpio
      ARM: at91/gpio: change comments and one variable name
      ARM: at91/gpio: add irqdomain and DT support
      ARM: at91/gpio: non-DT builds do not have gpio_chip.of_node field
      ARM: at91/gpio: add .to_irq gpio_chip handler
      ARM: at91/gpio: remove the static specification of gpio_chip.base
      ARM: at91/board-dt: remove AIC irq domain from board file
      ARM: at91: AIC and GPIO IRQ device tree initialization
      ARM: at91/pit: add traces in case of error  
      ARM: at91/tclib: take iomem size from resource
      ARM: at91/tc: add device tree support to atmel_tclib
      ARM: at91/tc/clocksource: Add 32 bit variant to Timer Counter
      ARM: at91: add sam9_smc.o to at91sam9x5 build
      ARM: at91/pio: add new PIO3 features

 .../devicetree/bindings/arm/atmel-aic.txt          |   38 ++
 .../devicetree/bindings/arm/atmel-at91.txt         |   32 +
 .../devicetree/bindings/gpio/gpio_atmel.txt        |   20 +
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/at91sam9g20.dtsi                 |   68 ++-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   87 +++-
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |   72 +++
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   12 +-
 arch/arm/boot/dts/at91sam9x5cm.dtsi                |   15 +
 arch/arm/boot/dts/usb_a9g20.dts                    |   23 +
 arch/arm/mach-at91/Makefile                        |    2 +-
 arch/arm/mach-at91/at91sam9260.c                   |    7 +
 arch/arm/mach-at91/at91sam9260_devices.c           |   21 +-
 arch/arm/mach-at91/at91sam926x_time.c              |   68 ++-
 arch/arm/mach-at91/at91sam9g45.c                   |    3 +
 arch/arm/mach-at91/at91sam9g45_devices.c           |   21 +-
 arch/arm/mach-at91/at91sam9x5.c                    |    2 -
 arch/arm/mach-at91/board-dt.c                      |   14 +-
 arch/arm/mach-at91/board-snapper9260.c             |   10 +-
 arch/arm/mach-at91/generic.h                       |    6 +
 arch/arm/mach-at91/gpio.c                          |  625 +++++++++++++++++---
 arch/arm/mach-at91/include/mach/at91_pio.h         |   25 +
 arch/arm/mach-at91/include/mach/gpio.h             |   17 +-
 arch/arm/mach-at91/irq.c                           |  132 ++++-
 drivers/clocksource/tcb_clksrc.c                   |   90 ++-
 drivers/misc/atmel_tclib.c                         |   64 ++-
 drivers/usb/host/ohci-at91.c                       |    5 +-
 include/linux/atmel_tc.h                           |   10 +
 28 files changed, 1286 insertions(+), 204 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/atmel-aic.txt
 create mode 100644 Documentation/devicetree/bindings/arm/atmel-at91.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio_atmel.txt

Thanks, best regards,
-- 
Nicolas Ferre
