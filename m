Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2IJMFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:05:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50115 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2IJMF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:05:29 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Antony Pavlov <antonynpavlov@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: [PATCH v2 0/3] MIPS: JZ4740: Move PWM driver to PWM framework
Date: Mon, 10 Sep 2012 14:05:16 +0200
Message-Id: <1347278719-15276-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:n+yP6mng7YgOvO61oGfh2jjrxo260QIM+tPDlygG/98
 J67g1c5PE5Msj1DDC976bof1oI7FQ2UXb4WFDo1FUkukY0KI1Q
 In0cvla3RbhQVcy7yTXpeRbiOn6+ou5DK7QuncEpdn6+OxLhy9
 CMBhu3l4AJQCI7sVHBmXmqXstKsDtEXCtDQzmMKg8OgNvqds/S
 w8jM8bk0ai26JWcsT9Kjhr4z/vpeBaL1WpLUtdxbxDcmaQNCPa
 AJ5be4EPcUbuW1X5zDW2fa2XLHAaVOW57mRbxeTFKFyLm50/md
 AZcwiusW6IYlUawCUCYM3EX/+3sX1R8P+szHBSFK6UnBhneFXW
 flchSr83+qGQjA0dEkNt9xFAnEy1rSKzaf4EABE405n0xM0Gd5
 Ox53IgzlbKYyeW347QPgrV0sLNkXJQiZII9l18RgZ5iwI5wmTU
 AE81H
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This small series fixes a build error due to a circular header
dependency, exports the timer API so it can be used outside of
the arch/mips/jz4740 tree and finally moves and converts the
JZ4740 PWM driver to the PWM framework.

Note that I don't have any hardware to test this on, so I had to
rely on compile tests only. Patches 1 and 2 should probably go
through the MIPS tree, while I can take patch 3 through the PWM
tree. It touches a couple of files in arch/mips but the changes
are unlikely to cause conflicts.

Thierry

Thierry Reding (3):
  MIPS: JZ4740: Break circular header dependency
  MIPS: JZ4740: Export timer API
  pwm: Add Ingenic JZ4740 support

 arch/mips/include/asm/mach-jz4740/irq.h      |   5 +
 arch/mips/include/asm/mach-jz4740/platform.h |   1 +
 arch/mips/include/asm/mach-jz4740/timer.h    | 113 ++++++++++++++
 arch/mips/jz4740/Kconfig                     |   3 -
 arch/mips/jz4740/Makefile                    |   2 +-
 arch/mips/jz4740/board-qi_lb60.c             |   1 +
 arch/mips/jz4740/irq.h                       |  23 ---
 arch/mips/jz4740/platform.c                  |   6 +
 arch/mips/jz4740/pwm.c                       | 177 ---------------------
 arch/mips/jz4740/time.c                      |   2 +-
 arch/mips/jz4740/timer.c                     |   4 +-
 arch/mips/jz4740/timer.h                     | 136 -----------------
 drivers/pwm/Kconfig                          |  12 +-
 drivers/pwm/Makefile                         |   1 +
 drivers/pwm/pwm-jz4740.c                     | 221 +++++++++++++++++++++++++++
 15 files changed, 363 insertions(+), 344 deletions(-)
 delete mode 100644 arch/mips/jz4740/irq.h
 delete mode 100644 arch/mips/jz4740/pwm.c
 delete mode 100644 arch/mips/jz4740/timer.h
 create mode 100644 drivers/pwm/pwm-jz4740.c

-- 
1.7.12

