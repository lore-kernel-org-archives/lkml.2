Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1K0Dpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 22:45:54 -0500
Received: from d1.icnet.pl ([212.160.220.21]:56769 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab1K0Dpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 22:45:51 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: [PATCH 0/5] ARM: OMAP1: Fix dpll1 reprogramming related issues
Date: Sun, 27 Nov 2011 04:32:26 +0100
Message-Id: <1322364751-29980-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After dpll1 reprogramming has been moved from setup_arch() to
kernel_init(), I've been observing several issues, resulting in
undesired system behaviour on my Amstrad Delta. This series fixes
those issues.

Janusz Krzysztofik (5):
  ARM: OMAP1: Fix dpll1 default rate reprogramming method
  ARM: OMAP1: Fix ckctl value used for dpll1 defualt rate
  ARM: OMAP1: Fix dpll1 reprogramming not actually allowed
  init/calibrate.c: allow for recalibration of loops per jiffy
  ARM: OMAP1: recalibrate loops per jiffy after dpll1 reprogram

 arch/arm/mach-omap1/clock.c      |   10 +---------
 arch/arm/mach-omap1/clock_data.c |    9 +++++++--
 arch/arm/plat-omap/sram.c        |    3 +++
 include/linux/delay.h            |    4 +++-
 init/calibrate.c                 |    6 ++++--
 5 files changed, 18 insertions(+), 14 deletions(-)

-- 
1.7.3.4

