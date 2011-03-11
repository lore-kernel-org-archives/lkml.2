Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1CKKyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 05:54:45 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:49766 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948Ab1CKKyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 05:54:41 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 0/4] Regulator delays and AB8500 init
Date: Fri, 11 Mar 2011 11:54:17 +0100
Message-ID: <1299840857-20578-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This provides some infrastructure to do delays when enabling
or setting the voltage of an active regulator.

There is one thing I'm hesitant about here: our AB8500-local
code was using msleep() whereas the code from the
regulator framework was using mdelay() exclusively. Is
there some generic way to determine a threshold for whether
this should delay or sleep? I've seen msleep(100) frequently
for example but ultimately it depends on system speed
I guess...?

Also, inside the ab8500 driver I always return 0 delay time
for set_voltage_time() if the regulator is not enabled,
I don't know if this clause is proper to move to the core,
I think so but maybe there are corner cases out there?

Linus Walleij


Bengt Jonsson (2):
  regulator: initialization for ab8500 regulators
  mach-ux500: provide ab8500 init vector

Linus Walleij (2):
  regulator: add set_voltage_time[_sel] infrastructure
  regulator: add ab8500 enable and raise time delays

 arch/arm/mach-ux500/board-mop500-regulators.c |  177 ++++++++++++++++++
 arch/arm/mach-ux500/board-mop500-regulators.h |    2 +
 arch/arm/mach-ux500/board-mop500.c            |    3 +
 drivers/regulator/ab8500.c                    |  246 ++++++++++++++++++++++++-
 drivers/regulator/core.c                      |   43 +++++
 include/linux/mfd/ab8500.h                    |    6 +
 include/linux/regulator/ab8500.h              |   50 +++++-
 include/linux/regulator/driver.h              |   15 ++-
 8 files changed, 537 insertions(+), 5 deletions(-)

-- 
1.7.3.2

