Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1LLUOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:14:24 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36061 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab1LLUOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:14:20 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.olzabs.org
Cc: microblaze-uclinux@itee.uq.edu.au
Subject: Rework gpio phandle parsing
Date: Mon, 12 Dec 2011 13:14:08 -0700
Message-Id: <1323720852-26311-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I originally posted this as part of the DT clock bindings.  I'm reposting
now since I've fixed up some bugs and I'm planning to put them into
linux-next.

The DT clock binding patches will be posted separately.

Cheers,
g.


 arch/arm/boot/dts/testcases/tests-phandle.dtsi |   37 ++++++
 arch/arm/boot/dts/testcases/tests.dtsi         |    1 +
 arch/arm/boot/dts/versatile-pb.dts             |    2 +
 arch/microblaze/kernel/reset.c                 |   43 +-------
 arch/powerpc/sysdev/qe_lib/gpio.c              |   42 ++------
 drivers/gpio/gpiolib.c                         |    2 +-
 drivers/of/Kconfig                             |    9 ++
 drivers/of/Makefile                            |    1 +
 drivers/of/base.c                              |  146 ++++++++++++------------
 drivers/of/gpio.c                              |   43 +++----
 drivers/of/selftest.c                          |  139 ++++++++++++++++++++++
 include/asm-generic/gpio.h                     |    6 +-
 include/linux/of.h                             |   11 ++-
 include/linux/of_gpio.h                        |   10 +-
 14 files changed, 313 insertions(+), 179 deletions(-)

