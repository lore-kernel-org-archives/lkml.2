Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab2HMU25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:28:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49138 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2HMUZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:25:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marek Vasut <marex@denx.de>, Russell King <linux@arm.linux.org.uk>,
        Wolfgang Denk <wd@denx.de>, Shawn Guo <shawn.guo@linaro.org>
Subject: [ 71/82] ARM: mxs: Remove MMAP_MIN_ADDR setting from mxs_defconfig
Date: Mon, 13 Aug 2012 13:19:47 -0700
Message-Id: <20120813201752.668657573@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/configs/mxs_defconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/configs/mxs_defconfig
+++ b/arch/arm/configs/mxs_defconfig
@@ -33,7 +33,6 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_PREEMPT_VOLUNTARY=y
 CONFIG_AEABI=y
-CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
 CONFIG_AUTO_ZRELADDR=y
 CONFIG_FPE_NWFPE=y
 CONFIG_NET=y


