Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab1JQLxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:53:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44300 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1JQLxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:53:06 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, linus.walleij@stericsson.com, jamie@jamieiles.com,
        arnd@arndb.de
Subject: [PATCH 0/6] ux500: Export SoC information and some platform clean-up
Date: Mon, 17 Oct 2011 12:52:52 +0100
Message-Id: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set satisfies 4 objectives:
  1. Ensures each platform device can specify a suitable parent
  2. Provides a bus for SoC devices as a means to export information
  3. Allows ux500 to make use of the new SoC bus
  4. Cleans up unnecessary complexity from ux500 code 

 Documentation/ABI/testing/sysfs-devices-soc    |   24 ++++
 arch/arm/mach-ux500/Kconfig                    |    1 +
 arch/arm/mach-ux500/board-mop500-sdi.c         |   30 ++--
 arch/arm/mach-ux500/board-mop500.c             |   74 +++++++----
 arch/arm/mach-ux500/board-mop500.h             |    6 +-
 arch/arm/mach-ux500/board-u5500-sdi.c          |    4 +-
 arch/arm/mach-ux500/board-u5500.c              |   27 +++--
 arch/arm/mach-ux500/cpu-db5500.c               |   37 ++++-
 arch/arm/mach-ux500/cpu-db8500.c               |   45 +++++-
 arch/arm/mach-ux500/cpu.c                      |   67 +++++++++
 arch/arm/mach-ux500/devices-common.c           |   79 +++---------
 arch/arm/mach-ux500/devices-common.h           |   71 +++++-----
 arch/arm/mach-ux500/devices-db5500.h           |  116 +++++++++-------
 arch/arm/mach-ux500/devices-db8500.h           |  176 ++++++++++++++----------
 arch/arm/mach-ux500/dma-db5500.c               |    3 +-
 arch/arm/mach-ux500/include/mach/db8500-regs.h |    3 +
 arch/arm/mach-ux500/include/mach/setup.h       |   10 +-
 arch/arm/mach-ux500/include/mach/usb.h         |    4 +-
 arch/arm/mach-ux500/usb.c                      |    7 +-
 drivers/base/Kconfig                           |    3 +
 drivers/base/Makefile                          |    1 +
 drivers/base/soc.c                             |  115 +++++++++++++++
 include/linux/sys_soc.h                        |   38 +++++
 23 files changed, 639 insertions(+), 302 deletions(-)

