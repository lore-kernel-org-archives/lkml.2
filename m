Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab2CBMzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 07:55:38 -0500
Received: from h1778886.stratoserver.net ([85.214.133.74]:56696 "EHLO
	h1778886.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab2CBMzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 07:55:36 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Remove bq24022 driver superseeded by gpio-regulator
Date: Fri, 2 Mar 2012 13:55:21 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.39-2-amd64; KDE/4.6.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203021355.21669.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bq24022 regulator is simply a more specialised variant of the now
present gpio-regulator. Therefore it probably shouldn't stay around.

This series converts the two users of bq24022 pxa/hx4700 and
pxa/magician to use the gpio-regulator instead, and after this removes
the then unused bq24022 driver.

The series was compile-tested only, but the gpio-regulator itself is
sucessfully used on my platform for the dcdc3 of a tps650240 (voltage
regulator with one gpio) and for a bq24075 (current regulator with two
gpios). So I'm quite sure it should work correctly but would welcome
testers :-) .

Heiko Stuebner (2):
  pxa: magician/hx4700: Convert to gpio-regulator from bq24022
  regulator: Remove bq24022 regulator driver

 arch/arm/configs/magician_defconfig |    2 +-
 arch/arm/mach-pxa/hx4700.c          |   33 ++++++--
 arch/arm/mach-pxa/magician.c        |   33 ++++++--
 drivers/regulator/Kconfig           |    8 --
 drivers/regulator/Makefile          |    1 -
 drivers/regulator/bq24022.c         |  162 -----------------------------------
 include/linux/regulator/bq24022.h   |   24 -----
 7 files changed, 55 insertions(+), 208 deletions(-)
 delete mode 100644 drivers/regulator/bq24022.c
 delete mode 100644 include/linux/regulator/bq24022.h

-- 
1.7.5.4

