Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab1H2BEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 21:04:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35256 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab1H2BEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 21:04:43 -0400
Date: Mon, 29 Aug 2011 11:04:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20110829110435.e7f2a6ae1637a6b13f2c5874@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-u300/Makefile.boot between commit 74b84ad6c1a5 ("ARM:
7022/1: allow to detect conflicting zreladdrs") from the arm tree and
commit 732851465445 ("mach-u300: retire odd singlemem variant") from the
arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-u300/Makefile.boot
index 69357af,a06bb0d..0000000
--- a/arch/arm/mach-u300/Makefile.boot
+++ b/arch/arm/mach-u300/Makefile.boot
@@@ -1,15 -1,4 +1,4 @@@
- # Note: the following conditions must always be true:
- #   ZRELADDR == virt_to_phys(TEXTADDR)
- #   PARAMS_PHYS must be within 4MB of ZRELADDR
- #   INITRD_PHYS must be in RAM
- 
- ifdef CONFIG_MACH_U300_SINGLE_RAM
-      zreladdr-y	+= 0x28E08000
-   params_phys-y	:= 0x28E00100
- else
-      zreladdr-y	+= 0x48008000
-   params_phys-y	:= 0x48000100
- endif
- 
 -   zreladdr-y	:= 0x48008000
++   zreladdr-y	+= 0x48008000
+ params_phys-y	:= 0x48000100
  # This isn't used.
- #initrd_phys-y	:= 0x29800000
+ #initrd_phys-y	:= 0x48800000
