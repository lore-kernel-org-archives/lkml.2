Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2IBJxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 05:53:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57467 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2IBJwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 05:52:43 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Antony Pavlov <antonynpavlov@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: [PATCH 0/3] MIPS: JZ4740: Move PWM driver to PWM framework
Date: Sun,  2 Sep 2012 11:52:27 +0200
Message-Id: <1346579550-5990-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:Y4bA/5CKk5Dd3Ey41RPM6LHj6BDA9/gLkEb5dPTFqcQ
 jKzCCtGMrlx3LCpv+OXBJeeH9pe/i+4x3KT6XSDn7mjEPLv7+C
 mKaJIakaY8igAFOgWbzM8vCYP/kWgeYdXpDa5EhquVni1bCRlA
 cOb1TwTqmMERzjaNX7s2VvGXbVr7q0KEYSkoXCiPxVXgQKXPi9
 FycTfEQvcFmLzWOCeoQSvCMrSarkZynsqsyM4/9gmVm97lSSp1
 8yyxeITSLSHYbTx07XD1VKsAjYBgSGaa5xOJR7POSt2XKgtm+o
 phXjq0b/eDilil8g/9TqQdQCcZ90tAW0mw+vELxrYYmBRZIFIg
 LpY5TvfgONTPu80IXYYqbUzNyFj+rgwl2puDMoswjAP0ND23Cc
 iw0c3yTf4OKZvU34oN+CXqjN1oTxyd2Ym1odlyGWfJFS1YToxq
 m9PWz
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
 arch/mips/include/asm/mach-jz4740/timer.h    |  35 +++++
 arch/mips/jz4740/Kconfig                     |   3 -
 arch/mips/jz4740/Makefile                    |   2 +-
 arch/mips/jz4740/board-qi_lb60.c             |   3 +-
 arch/mips/jz4740/irq.h                       |  23 ---
 arch/mips/jz4740/platform.c                  |   6 +
 arch/mips/jz4740/pwm.c                       | 177 -----------------------
 arch/mips/jz4740/time.c                      |   2 +-
 arch/mips/jz4740/timer.c                     | 128 +++++++++++++++--
 arch/mips/jz4740/timer.h                     | 136 ------------------
 drivers/pwm/Kconfig                          |  12 +-
 drivers/pwm/Makefile                         |   1 +
 drivers/pwm/core.c                           |   2 +-
 drivers/pwm/pwm-jz4740.c                     | 205 +++++++++++++++++++++++++++
 16 files changed, 386 insertions(+), 355 deletions(-)
 delete mode 100644 arch/mips/jz4740/irq.h
 delete mode 100644 arch/mips/jz4740/pwm.c
 delete mode 100644 arch/mips/jz4740/timer.h
 create mode 100644 drivers/pwm/pwm-jz4740.c

-- 
1.7.12

