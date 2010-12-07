Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0LGFpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 00:45:49 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:45663 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113Ab0LGFpn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 00:45:43 -0500
From: Sundar R IYER <sundar.iyer@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Date: Tue, 7 Dec 2010 06:45:32 +0100
Subject: RE: [PATCH 00/20] ux500: platform data, TC3589x keypad driver
Thread-Topic: [PATCH 00/20] ux500: platform data, TC3589x keypad driver
Thread-Index: AcuS98cPLLKrtEzPTl+yofzGeqlLFAC16Lcg
Message-ID: <33A307AF30D7BF4F811B1568FE7A9B18047C458ED4@EXDCVYMBSTM006.EQ1STM.local>
References: <1291387112-10570-1-git-send-email-sundar.iyer@stericsson.com>
In-Reply-To: <1291387112-10570-1-git-send-email-sundar.iyer@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

I am waiting for your comments for the MFD parts. 

Dmitry has already a Acked-by for the keypad with some changes; Linus W has a Acked-by
for most of the platform changes; I would like to wait to incorporate your comments to push 
the v2 for the patch set.

Cheers!
Sundar

>-----Original Message-----
>From: Sundar R IYER
>Cc: Sundar R IYER
>Subject: [PATCH 00/20] ux500: platform data, TC3589x keypad driver
>
>These set of patches add platform data to most of our mainlined
>input drivers. Also included herein is a revised version of the
>TC3589x keypad drivers, incorporating reviews from Dmitry.
>
>(I am still not sure if this is the list to be sent for reviews, but
>I decided sending it internally first; probably Linus/Srinidhi/Rabin
>would like to have a view of the changes before it goes out mainline)
>
>Rabin Vincent (1):
>  nomadik-gpio: allow sleep mode dir/pull to differ from normal mode
>
>Sundar Iyer (19):
>  mfd/ab8500: remove spi support
>  mach-ux500: deprecate spi support for ab8500
>  mach-ux500: move keymaps to new file
>  mach-ux500: add STMPE1601 platform data
>  mfd/tc35892: rename tc35892 header to tc3589x
>  mfd/tc35892: rename tc35892 core driver to tc3589x
>  mfd/tc3589x: rename tc35892 structs/registers to tc359x
>  mfd/tc3589x: add block identifier for multiple child devices
>  input/tc3589x: add tc3589x keypad support
>  mfd/tc3589x: fix random interrupt misses
>  mfd/tc3589x: undo gpio module reset during chip init
>  mfd/tc3589x: add suspend/resume support
>  plat-nomadik/gpio: add expander gpio pins enumeration
>  mach-ux500: add touchscreen interfaces platform data
>  i2c/nomadik: add adapter name for updated sanity checkings
>  mach-ux500: add TC35893 keypad platform data
>  mach-ux500: explicit enable MTU TCR in the kernel
>  mach-ux500: clean up checkpatch spits
>  i2c/nomadik: some checkpatch warnings
>
> arch/arm/mach-ux500/Makefile                       |    2 +
> arch/arm/mach-ux500/board-mop500-keypads.c         |  229 ++++++++++
> arch/arm/mach-ux500/board-mop500-touchscreen.c     |  170 ++++++++
> arch/arm/mach-ux500/board-mop500.c                 |  164 +-------
> arch/arm/mach-ux500/board-mop500.h                 |    3 +-
> arch/arm/mach-ux500/clock.c                        |  167 +++-----
> arch/arm/mach-ux500/devices-db8500.c               |    2 +-
> arch/arm/mach-ux500/include/mach/gpio.h            |   28 ++
> .../mach-ux500/include/mach/irqs-board-mop500.h    |   13 +-
> arch/arm/plat-nomadik/gpio.c                       |   50 ++-
> arch/arm/plat-nomadik/include/plat/pincfg.h        |   70 +++-
> drivers/gpio/Kconfig                               |    8 +-
> drivers/gpio/Makefile                              |    2 +-
> drivers/gpio/tc35892-gpio.c                        |  389 -----------------
> drivers/gpio/tc3589x-gpio.c                        |  389 +++++++++++++++++
> drivers/i2c/busses/i2c-nomadik.c                   |   35 +-
> drivers/input/keyboard/Kconfig                     |   10 +
> drivers/input/keyboard/Makefile                    |    1 +
> drivers/input/keyboard/tc3589x-keypad.c            |  440 ++++++++++++++++++++
> drivers/mfd/Kconfig                                |   14 +-
> drivers/mfd/Makefile                               |    4 +-
> drivers/mfd/ab8500-spi.c                           |  143 -------
> drivers/mfd/tc35892.c                              |  345 ---------------
> drivers/mfd/tc3589x.c                              |  438 +++++++++++++++++++
> include/linux/mfd/tc35892.h                        |  136 ------
> include/linux/mfd/tc3589x.h                        |  195 +++++++++
> 26 files changed, 2130 insertions(+), 1317 deletions(-)
> create mode 100644 arch/arm/mach-ux500/board-mop500-keypads.c
> create mode 100644 arch/arm/mach-ux500/board-mop500-touchscreen.c
> delete mode 100644 drivers/gpio/tc35892-gpio.c
> create mode 100644 drivers/gpio/tc3589x-gpio.c
> create mode 100644 drivers/input/keyboard/tc3589x-keypad.c
> delete mode 100644 drivers/mfd/ab8500-spi.c
> delete mode 100644 drivers/mfd/tc35892.c
> create mode 100644 drivers/mfd/tc3589x.c
> delete mode 100644 include/linux/mfd/tc35892.h
> create mode 100644 include/linux/mfd/tc3589x.h
>
>--
>1.7.2.dirty

