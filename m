Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030727Ab2HQD2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:28:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46870 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030628Ab2HQD1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:27:09 -0400
Message-Id: <20120817030246.875440689@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marek Vasut <marex@denx.de>,
        Russell King <linux@arm.linux.org.uk>, Wolfgang Denk <wd@denx.de>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [ 20/37] ARM: mxs: Remove MMAP_MIN_ADDR setting from mxs_defconfig
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

commit 3bed491c8d28329e34f8a31e3fe64d03f3a350f1 upstream.

The CONFIG_DEFAULT_MMAP_MIN_ADDR was set to 65536 in mxs_defconfig,
this caused severe breakage of userland applications since the upper
limit for ARM is 32768. By default CONFIG_DEFAULT_MMAP_MIN_ADDR is
set to 4096 and can also be changed via /proc/sys/vm/mmap_min_addr
if needed.

Quoting Russell King [1]:

"4096 is also fine for ARM too. There's not much point in having
defconfigs change it - that would just be pure noise in the config
files."

the CONFIG_DEFAULT_MMAP_MIN_ADDR can be removed from the defconfig
altogether.

This problem was introduced by commit cde7c41 (ARM: configs: add
defconfig for mach-mxs).

[1] http://marc.info/?l=linux-arm-kernel&m=134401593807820&w=2

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Wolfgang Denk <wd@denx.de>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/configs/mxs_defconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/configs/mxs_defconfig b/arch/arm/configs/mxs_defconfig
index ccdb635..4edcfb4 100644
--- a/arch/arm/configs/mxs_defconfig
+++ b/arch/arm/configs/mxs_defconfig
@@ -34,7 +34,6 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_PREEMPT_VOLUNTARY=y
 CONFIG_AEABI=y
-CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
 CONFIG_AUTO_ZRELADDR=y
 CONFIG_FPE_NWFPE=y
 CONFIG_NET=y


