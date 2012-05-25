Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab2EYJvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:51:42 -0400
Received: from mail1.windriver.com ([147.11.146.13]:44669 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2EYJvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:51:39 -0400
From: <jgq516@gmail.com>
To: <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <rnayak@ti.com>, <tony@atomide.com>,
        <wim@iguana.be>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-watchdog@vger.kernel.org>
Subject: [PATCH 2/3] OMAP: avoid build wdt platform device if with dt support
Date: Fri, 25 May 2012 18:42:31 +0800
Message-ID: <1337942552-28218-3-git-send-email-jgq516@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1337942552-28218-1-git-send-email-jgq516@gmail.com>
References: <1337942552-28218-1-git-send-email-jgq516@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Jiang <jgq516@gmail.com>

If provided dt support, then skip add wdt platform device as usual.

Signed-off-by: Xiao Jiang <jgq516@gmail.com>
---
 arch/arm/mach-omap2/devices.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index ae62ece..80d7e3f 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -759,7 +759,7 @@ static int __init omap_init_wdt(void)
 	char *oh_name = "wd_timer2";
 	char *dev_name = "omap_wdt";
 
-	if (!cpu_class_is_omap2())
+	if (!cpu_class_is_omap2() || of_have_populated_dt())
 		return 0;
 
 	oh = omap_hwmod_lookup(oh_name);
-- 
1.7.3

