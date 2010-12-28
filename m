Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab0L1RQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:16:56 -0500
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:43966 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242Ab0L1RQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:16:55 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 0/3] TWL4030 IRQ Changes
Date: Tue, 28 Dec 2010 19:14:16 +0200
Message-Id: <1293556459-28613-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.3.4.598.g85356
In-Reply-To: <20101228161657.GF2239@legolas.emea.dhcp.ti.com>
References: <20101228161657.GF2239@legolas.emea.dhcp.ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I dropped the twl6030-irq.c changes because that
thing is a bit messy. I hope the original author
will feel inspired and fix that one up.

Anyway, twl4030-irq.c seems to be going to the
right direction now. Thanks to Mark Brown for
pointing out the need to drop the locking and
implement bus_lock/bus_sync_unlock methods.

Compile tested only with omap2plus_defconfig.

I'll test after merge window to be sure I have
all the newest code.

Felipe Balbi (3):
  mfd: twl4030-irq: move to threaded_irq
  mfd: twl4030-irq: drop the workqueue hackery
  mfd: twl4030-irq: implement bus_*lock

 drivers/mfd/twl4030-irq.c |  363 +++++++++++++++++---------------------------
 1 files changed, 140 insertions(+), 223 deletions(-)

-- 
1.7.3.4.598.g85356

