Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0ICW3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 18:29:12 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45927 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab0ICW3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 18:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XYYU7XGTR/irYT9l0PJae+O1Mm/bagwGJmR3wO3CqsGl96yn58VHaOnzAU7lGuiO5b
         8ehU0Ydip63qE+DNdFMWuaL6yV7iQUzPfzYncmphm395yo4TqR/ipbTSzkt0ZRGVeDom
         q66i8ADIvZfTT2jTFSMHBz7dB/aZmUXFnGo+g=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH v2 0/6 RESEND] ARM: pxa168: add keypad support
Date: Fri,  3 Sep 2010 18:28:05 -0400
Message-Id: <1283552891-13966-1-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 1
1) Make pxa27x_keypad.h accessible to mach-mmp
2) Add a wakeup handler for pxa27x_keypad interrupts
The wakeup callback fixes an issue on the pxa168 that prevents the keypad
driver from being able to clear the keypad interrupt after reading KPC_PC
3) Add initial board level support

Version 2
1) Clean up for wakeup handler moved from pxa168-irq to pxa27x_keypad
2) Reduced the number of rows to 5 for Aspenite

Resend
1) System time was wrong when email was sent

Mark F. Brown (6):
  ARM: pxa27x/pxa3xx: moved pxa27x_keypad.h to platform pxa directory
  ARM: pxa168: added keypad support
  ARM: pxa168: added wake clear register support for APMU
  ARM: pxa27x_keypad: added wakeup event handler for keypad interrupts
  ARM: pxa168: added keypad wake clear event support for platform
  ARM: pxa168: aspenite: add board support for keypad

 arch/arm/mach-mmp/aspenite.c                       |   27 ++++++++++++++++++++
 arch/arm/mach-mmp/include/mach/mfp-pxa168.h        |    7 +++++
 arch/arm/mach-mmp/include/mach/pxa168.h            |   12 +++++++++
 arch/arm/mach-mmp/include/mach/regs-apmu.h         |   12 +++++++++
 arch/arm/mach-mmp/pxa168.c                         |   13 +++++++++
 arch/arm/mach-pxa/devices.c                        |    2 +-
 arch/arm/mach-pxa/em-x270.c                        |    2 +-
 arch/arm/mach-pxa/ezx.c                            |    2 +-
 arch/arm/mach-pxa/littleton.c                      |    2 +-
 arch/arm/mach-pxa/mainstone.c                      |    4 +-
 arch/arm/mach-pxa/mioa701.c                        |    2 +-
 arch/arm/mach-pxa/palmld.c                         |    2 +-
 arch/arm/mach-pxa/palmt5.c                         |    2 +-
 arch/arm/mach-pxa/palmtreo.c                       |    2 +-
 arch/arm/mach-pxa/palmtx.c                         |    2 +-
 arch/arm/mach-pxa/palmz72.c                        |    2 +-
 arch/arm/mach-pxa/tavorevb.c                       |    2 +-
 arch/arm/mach-pxa/z2.c                             |    2 +-
 arch/arm/mach-pxa/zylonite.c                       |    2 +-
 .../mach => plat-pxa/include/plat}/pxa27x_keypad.h |    1 +
 drivers/input/keyboard/Kconfig                     |    2 +-
 drivers/input/keyboard/pxa27x_keypad.c             |   12 ++++++++-
 22 files changed, 99 insertions(+), 17 deletions(-)
 rename arch/arm/{mach-pxa/include/mach => plat-pxa/include/plat}/pxa27x_keypad.h (97%)

