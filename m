Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab2IRIYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:24:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50190 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab2IRIYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:24:15 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Qin Rui <qinrui@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] unicore32: Move PWM driver to PWM framework
Date: Tue, 18 Sep 2012 10:23:48 +0200
Message-Id: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:odIVdCkOOCiZBdyhkWjFKaWehWx9w+RAoUN/+SE0uEr
 gk/xUcv49r8zeWc4HIlMnO9OdRTQPAMcbsDTVYiuvNlv4Q+5fq
 ecvl0jZG7fCH9oDn72TX7X1g7JO7VbtEnBqwfibHAtQTAGc4/t
 hluy+JkzpNigjDw4tdB1OtokI+CxEGes+XVaVkOk9919mngdxM
 /JRsQsaTRK9F7+wfgD8Tae4W5j65uPjiWDwyg3jIbsJDtytT18
 sM0ofW91RDPWV+sRXwa/fNA8jeIS6WLglohTvTeEnvtsKpCsm5
 ln4XlhPVd2gU28S7oYGBxrB039lrWppsLUlkXVMcYJz8aT2Olg
 FRu1uvzJSTnFJdU4TlfT/V8XrPkn6gxi7O2QR6mFmASeOOmAKV
 iUh/WHPOkzv/0QYmbv8L9qAMnYYit+YtQgMucmPpUThoRpSJcZ
 hF2j5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series cleans up the PWM driver as well as moves and converts it
to the PWM framework. I don't have any Unicore32 hardware, so all I
could do was test if the kernel builds properly with the patches
applied. I think except for the final patch all of these should go
through the Unicore32 tree.

Changes in v2:
- drop common clock framework support (this series now depends on a
  patch (https://lkml.org/lkml/2012/9/9/54) by Lars-Peter Clausen that
  should soon appear in linux-next and which makes devm_clk_get()
  available outside of the common clock framework)
- update patch 1 to incorporate changes by Guan Xuetao

Thierry

Thierry Reding (5):
  unicore32: pwm: Properly remap memory-mapped registers
  unicore32: pwm: Use module_platform_driver()
  unicore32: pwm: Remove unnecessary indirection
  unicore32: pwm: Use managed resource allocations
  pwm: Move PUV3 PWM driver to PWM framework

 arch/unicore32/Kconfig                 |  12 +-
 arch/unicore32/include/mach/regs-ost.h |  18 +--
 arch/unicore32/kernel/Makefile         |   1 -
 arch/unicore32/kernel/pwm.c            | 263 ---------------------------------
 drivers/pwm/Kconfig                    |  10 +-
 drivers/pwm/Makefile                   |   1 +
 drivers/pwm/pwm-puv3.c                 | 161 ++++++++++++++++++++
 7 files changed, 181 insertions(+), 285 deletions(-)
 delete mode 100644 arch/unicore32/kernel/pwm.c
 create mode 100644 drivers/pwm/pwm-puv3.c

-- 
1.7.12

