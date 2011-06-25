Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1FYWKO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 18:10:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65268 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1FYWKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 18:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=vGnz+LVKv+NgYrejmeQ+OeuB1SUCJpe7UkAbYTIVQww31EpUkbpC79b+43BZ1lF9uz
         sTEMLiaVuhKllA7Aa79ymazYilcWhvPW9gjwhjYmcfO7MlsQcGnVshFi5UGjVKQCdKmu
         9DpNez4Jogy1jUELdxtYx1j2f7njoEj/BRRGQ=
From: Bryan Wu <bryan.wu@canonical.com>
To: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Introduce a led trigger for CPU activity
Date: Sun, 26 Jun 2011 06:10:00 +0800
Message-Id: <1309039804-659-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Linus Walleij's ARM LED consolidation work, this patchset introduce a
new generic led trigger for CPU not only for ARM but also for others.

For enabling CPU idle event, CPU arch code should call ledtrig_cpu() stub to
trigger idle start or idle end event.

These 4 patches is against 3.0-rc4 and build successfully for versatile and
realview.

Bryan Wu (2):
  leds: create a trigger for CPU activity
  ARM: use new LEDS CPU trigger stub to replace old one

Linus Walleij (2):
  mach-realview: retire custom LED code
  mach-versatile: retire custom LED code

 arch/arm/kernel/process.c                |    6 +-
 arch/arm/mach-realview/core.c            |   39 --------
 arch/arm/mach-realview/core.h            |    2 -
 arch/arm/mach-realview/realview_eb.c     |    4 -
 arch/arm/mach-realview/realview_pb1176.c |    4 -
 arch/arm/mach-realview/realview_pb11mp.c |    4 -
 arch/arm/mach-realview/realview_pba8.c   |    4 -
 arch/arm/mach-realview/realview_pbx.c    |    4 -
 arch/arm/mach-versatile/core.c           |   42 ---------
 arch/arm/plat-versatile/Kconfig          |    6 +-
 arch/arm/plat-versatile/leds.c           |   13 ++-
 drivers/leds/Kconfig                     |   10 ++
 drivers/leds/Makefile                    |    1 +
 drivers/leds/ledtrig-cpu.c               |  145 ++++++++++++++++++++++++++++++
 include/linux/leds.h                     |   15 +++
 15 files changed, 188 insertions(+), 111 deletions(-)
 create mode 100644 drivers/leds/ledtrig-cpu.c

-- 
1.7.4.1
