Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2GMH7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 03:59:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38410 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2GMH7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 03:59:18 -0400
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Viresh Kumar <viresh.kumar@st.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <florian@openwrt.org>,
        Maxime Bizon <mbizon@freebox.fr>
Subject: [PATCH] MIPS: BCM63XX: select HAVE_CLK
Date: Fri, 13 Jul 2012 09:58:35 +0200
Message-Id: <1342166315-17765-1-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BCM63XX implements the clk interface, but does not advertise it.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---

This fixes a build failure in linux-next caused by
5afae362dc79cb8b6b3965422d13d118c63d4ee4 ("clk: Add non CONFIG_HAVE_CLK
routines"):

  CC      arch/mips/bcm63xx/clk.o
arch/mips/bcm63xx/clk.c:285:5: error: redefinition of 'clk_enable'
include/linux/clk.h:294:19: note: previous definition of 'clk_enable' was here

and so on (I think you have already seen one of these).

@Andrew: This patch should apply cleanly to any tree, so maybe you
could add it to your patch series in front of the mentioned
patch, to keep bisectability for bcm63xx.

@Ralf: I hope it is okay for you that this goes through a different
tree.

 arch/mips/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 09ab87e..80d9199 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -122,6 +122,7 @@ config BCM63XX
 	select SYS_HAS_EARLY_PRINTK
 	select SWAP_IO_SPACE
 	select ARCH_REQUIRE_GPIOLIB
+	select HAVE_CLK
 	help
 	 Support for BCM63XX based boards
 
-- 
1.7.2.5

