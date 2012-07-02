Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab2GBNAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:00:33 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:35044 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2GBNAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:00:32 -0400
Message-ID: <4FF19B6D.3010704@atmel.com>
Date: Mon, 2 Jul 2012 15:00:29 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: [GIT PULL] at91: first batch of cleanup for 3.6
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Arnd, Olof,

The following changes since commit
6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-for-next-cleanup

for you to fetch changes up to c4b68520dc0ec96153bc0d87bca5ffba508edfcf:

  ARM: at91: add AIC5 support (2012-07-02 14:31:00 +0200)

- ----------------------------------------------------------------
A series about interrupt controller cleanup. AT91 AIC is moving to
fasteoi type of handler and sparse IRQ.
The Device Tree support is added to take into account priority
and external IRQ.
In addition to that, the new AIC5 IP is introduced.

- ----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: aic add dt support for external irqs

Ludovic Desroches (8):
      ARM: at91: fix at91_aic_write macro
      ARM: at91: aic can use fast eoi handler type
      ARM: at91: add of irq priorities support
      ARM: at91: remove static irq priorities for sam9x5
      ARM: at91: at91 based machines specify their own irq handler at
run time
      ARM: at91: sparse irq support
      ARM: at91: remove mach/irqs.h
      ARM: at91: add AIC5 support

Paul Bolle (1):
      ARM: at91: remove two unused headers

 .../devicetree/bindings/arm/atmel-aic.txt          |    9 +-
 arch/arm/boot/dts/at91sam9260.dtsi                 |   37 +-
 arch/arm/boot/dts/at91sam9263.dtsi                 |   31 +-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   39 +-
 arch/arm/boot/dts/at91sam9n12.dtsi                 |   30 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   39 +-
 arch/arm/kernel/irq.c                              |   10 -
 arch/arm/mach-at91/Kconfig                         |    2 +
 arch/arm/mach-at91/at91rm9200.c                    |    1 +
 arch/arm/mach-at91/at91rm9200_devices.c            |   84 ++--
 arch/arm/mach-at91/at91sam9260.c                   |    1 +
 arch/arm/mach-at91/at91sam9260_devices.c           |   92 ++---
 arch/arm/mach-at91/at91sam9261.c                   |    1 +
 arch/arm/mach-at91/at91sam9261_devices.c           |   68 ++--
 arch/arm/mach-at91/at91sam9263.c                   |    1 +
 arch/arm/mach-at91/at91sam9263_devices.c           |   80 ++--
 arch/arm/mach-at91/at91sam926x_time.c              |    2 +-
 arch/arm/mach-at91/at91sam9g45.c                   |    1 +
 arch/arm/mach-at91/at91sam9g45_devices.c           |  108 ++---
 arch/arm/mach-at91/at91sam9rl.c                    |    1 +
 arch/arm/mach-at91/at91sam9rl_devices.c            |   76 ++--
 arch/arm/mach-at91/at91sam9x5.c                    |   40 --
 arch/arm/mach-at91/at91x40.c                       |    1 +
 arch/arm/mach-at91/board-1arm.c                    |    2 +
 arch/arm/mach-at91/board-afeb-9260v1.c             |    2 +
 arch/arm/mach-at91/board-cam60.c                   |    2 +
 arch/arm/mach-at91/board-carmeva.c                 |    2 +
 arch/arm/mach-at91/board-cpu9krea.c                |    2 +
 arch/arm/mach-at91/board-cpuat91.c                 |    2 +
 arch/arm/mach-at91/board-csb337.c                  |    2 +
 arch/arm/mach-at91/board-csb637.c                  |    2 +
 arch/arm/mach-at91/board-dt.c                      |    2 +
 arch/arm/mach-at91/board-eb01.c                    |    2 +
 arch/arm/mach-at91/board-eb9200.c                  |    2 +
 arch/arm/mach-at91/board-ecbat91.c                 |    2 +
 arch/arm/mach-at91/board-eco920.c                  |    2 +
 arch/arm/mach-at91/board-flexibity.c               |    2 +
 arch/arm/mach-at91/board-foxg20.c                  |    2 +
 arch/arm/mach-at91/board-gsia18s.c                 |    2 +
 arch/arm/mach-at91/board-kafa.c                    |    2 +
 arch/arm/mach-at91/board-kb9202.c                  |    2 +
 arch/arm/mach-at91/board-neocore926.c              |    2 +
 arch/arm/mach-at91/board-pcontrol-g20.c            |    2 +
 arch/arm/mach-at91/board-picotux200.c              |    2 +
 arch/arm/mach-at91/board-qil-a9260.c               |    2 +
 arch/arm/mach-at91/board-rm9200dk.c                |    2 +
 arch/arm/mach-at91/board-rm9200ek.c                |    2 +
 arch/arm/mach-at91/board-rsi-ews.c                 |    2 +
 arch/arm/mach-at91/board-sam9-l9260.c              |    2 +
 arch/arm/mach-at91/board-sam9260ek.c               |    2 +
 arch/arm/mach-at91/board-sam9261ek.c               |    2 +
 arch/arm/mach-at91/board-sam9263ek.c               |    2 +
 arch/arm/mach-at91/board-sam9g20ek.c               |    3 +
 arch/arm/mach-at91/board-sam9m10g45ek.c            |    2 +
 arch/arm/mach-at91/board-sam9rlek.c                |    2 +
 arch/arm/mach-at91/board-snapper9260.c             |    2 +
 arch/arm/mach-at91/board-stamp9g20.c               |    3 +
 arch/arm/mach-at91/board-usb-a926x.c               |    4 +
 arch/arm/mach-at91/board-yl-9200.c                 |    2 +
 arch/arm/mach-at91/generic.h                       |    2 +
 arch/arm/mach-at91/gpio.c                          |    9 +-
 arch/arm/mach-at91/include/mach/at91_aic.h         |   36 +-
 arch/arm/mach-at91/include/mach/at91_spi.h         |   81 ----
 arch/arm/mach-at91/include/mach/at91_ssc.h         |  106 -----
 arch/arm/mach-at91/include/mach/entry-macro.S      |   27 --
 arch/arm/mach-at91/include/mach/irqs.h             |   48 ---
 arch/arm/mach-at91/irq.c                           |  413
+++++++++++++++++---
 arch/arm/mach-at91/pm.c                            |    1 +
 68 files changed, 835 insertions(+), 718 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_spi.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_ssc.h
 delete mode 100644 arch/arm/mach-at91/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-at91/include/mach/irqs.h

Thanks, best regards,
- -- 
Nicolas Ferre

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJP8ZtmAAoJEAf03oE53VmQkZoIAKiDMeHdLJXuvZDc0Mt3JvOg
dDB+k8dfyW3IpEjxcn1pfhki9mnOC/EWHYYGrzxwzHZNMgArI7JjgHZq2wfuZJfZ
Hv0raEBnQxXwPxQYt9ZOagdVw0sWVQ3Pj98uxSFQPS43U7M9tW5bjdLOAJZwpvQW
MQcY5+cfAfeP8AOdwNVrlE/KkmvIl4FlikweSzJBA2IYE+djr7YJ5mVUp1Uuj+NQ
AzYc2qnMMPd1fjGXQzR6hpljjhDiMQlC7RXHEGJCIkFNg5noEHGRE0vxesdrLI8N
d4MkXhIQKVbuZhmAIrV7v2EtvJp7Wv+htTfjh+nnZsEYCxbR0AJnOXrj9yroMYM=
=FPgl
-----END PGP SIGNATURE-----
