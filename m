Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0JDJpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:45:43 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59281 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab0JDJpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:45:42 -0400
From: vkuzmichev@mvista.com
To: linux-arm-kernel@lists.infradead.org
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: [PATCH 0/4] ARM: smp_twd: mpcore_wdt: Fix MPCORE watchdog setup
Date: Mon,  4 Oct 2010 13:45:36 +0400
Message-Id: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuzmichev <vkuzmichev@mvista.com>

The series of patches fixes various bugs in ARM MPCORE watchdog setup.
They also introduce some changes in common SMP_TWD timer setup code.
The PATCH 1/4 adds an exported function to obtain calibrated timer rate
in mpcore_wdt. However, this solution might be unacceptable, so we may
discuss another 2 variants:
 1) use clock framework
   This may require to fix all MPCORE boards clock implementations.
 2) copy calibration loop to mpcore_wdt
   However, this increases boot time.


Vitaly Kuzmichev (4):
  ARM: smp_twd: mpcore_wdt: Fix watchdog counter loading
  ARM: smp_twd: Fix typo in twd_timer_rate printout
  ARM: mpcore_wdt: Fix WDIOC_SETOPTIONS handling
  ARM: mpcore_wdt: Fix timer mode setup

 arch/arm/include/asm/smp_twd.h |    7 +++++++
 arch/arm/kernel/smp_twd.c      |    8 +++++++-
 drivers/watchdog/mpcore_wdt.c  |   29 +++++++++++++++++++++--------
 3 files changed, 35 insertions(+), 9 deletions(-)

-- 
1.7.2.2

