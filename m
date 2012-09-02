Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2IBKVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 06:21:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52969 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab2IBKV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 06:21:27 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] unicore32: Move PWM driver to PWM framework
Date: Sun,  2 Sep 2012 12:21:07 +0200
Message-Id: <1346581273-7041-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:ZwDyoLFpIVwloPz3b2YSogDlTZP6Co9uiLTl0tRoCD4
 2/giqOSRMXjuOo+gDASwyeLA3c/hBk880qow10WrS2+TwFSYUI
 z+n0wuP8i7agsf0bnGm3DZkyDhC5s/XzE/R/bkC6v9T+m24WQZ
 q1LotL/qaK++dBWEpx9p2lhfC7uQBR2lpqU7koejBh7tlATtDz
 QvyioLnq0Nh0oHwExuIgcssyh2QaX9t1QP0FFeciI2/2ApCmXl
 qJdRQNFpDQDgWrdr+Yt0Uz7nSmjyVPcDZj21ZMIsSsXvJYGF/2
 +Kxk3fPpzZih33gbgP2kheUDAGbkPvRemFm29aqlnuwya+MrEs
 R8ngvMQ6UjU2IPfXd9Tv/CZrbpEJNRfxOI9X6buuttj7ZeG8vZ
 zeRFHW8DpruRgXDm3aeme45HWvP07Olfd5d9U6ch1uVyDvTG6b
 eNv3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series cleans up the PWM driver as well as moves and converts it
to the PWM framework.

Part of this series is a patch that converts the Unicore32 clock code
to the common clock framework, which allows devm_clk_get() to be used
for further cleanup. I'm not very familiar with the clock framework,
so this might need some extra thorough review.

I don't have any Unicore32 hardware, so all I could do was test if the
kernel builds properly with the patches applied. I think except for
the final patch all of these should go through the Unicore32 tree.

Thierry

Thierry Reding (6):
  unicore32: pwm: Properly remap memory-mapped registers
  unicore32: pwm: Use module_platform_driver()
  unicore32: pwm: Remove unnecessary indirection
  unicore32: Add common clock support
  unicore32: pwm: Use managed resource allocations
  pwm: Move PUV3 PWM driver to PWM framework

 arch/unicore32/Kconfig              |  13 +-
 arch/unicore32/include/asm/clkdev.h |  26 ++
 arch/unicore32/kernel/Makefile      |   1 -
 arch/unicore32/kernel/clock.c       | 560 ++++++++++++++++++++----------------
 arch/unicore32/kernel/pwm.c         | 263 -----------------
 drivers/pwm/Kconfig                 |  10 +-
 drivers/pwm/Makefile                |   1 +
 drivers/pwm/pwm-puv3.c              | 165 +++++++++++
 8 files changed, 516 insertions(+), 523 deletions(-)
 create mode 100644 arch/unicore32/include/asm/clkdev.h
 delete mode 100644 arch/unicore32/kernel/pwm.c
 create mode 100644 drivers/pwm/pwm-puv3.c

-- 
1.7.12

