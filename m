Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541Ab1FKCmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 22:42:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64887 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511Ab1FKCmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 22:42:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cF1u/3o2By1hWegSF2hnrZdkzssg/uIZuURisgB1l2xCvkoywXhks2lb3UBgCLiMwo
         hYGVoIzTUWN000kTOr2EbvZqMzmqX4psjAiVHEkDQEzeQXB1Tq17mqG5LypZLgvdClRe
         4NA7DSFEtkipG+RCmSYXgmeRRzHYJRFo2trdI=
Date: Sat, 11 Jun 2011 10:41:36 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-cris-kernel@axis.com
Subject: [Patch] cris: fix some build warnings in pinmux.c
Message-ID: <20110611024136.GA6522@cr0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix some harmless warnings like,

src/arch/cris/arch-v32/mach-a3/pinmux.c:273: warning: ISO C90 forbids mixed declarations and code:

Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/arch/cris/arch-v32/mach-a3/pinmux.c b/arch/cris/arch-v32/mach-a3/pinmux.c
index 18648ef..591f775 100644
--- a/arch/cris/arch-v32/mach-a3/pinmux.c
+++ b/arch/cris/arch-v32/mach-a3/pinmux.c
@@ -85,6 +85,8 @@ crisv32_pinmux_alloc_fixed(enum fixed_function function)
 	int ret = -EINVAL;
 	char saved[sizeof pins];
 	unsigned long flags;
+	reg_pinmux_rw_hwprot hwprot;
+	reg_clkgen_rw_clk_ctrl clk_ctrl;
 
 	spin_lock_irqsave(&pinmux_lock, flags);
 
@@ -93,9 +95,8 @@ crisv32_pinmux_alloc_fixed(enum fixed_function function)
 
 	crisv32_pinmux_init(); /* must be done before we read rw_hwprot */
 
-	reg_pinmux_rw_hwprot hwprot = REG_RD(pinmux, regi_pinmux, rw_hwprot);
-	reg_clkgen_rw_clk_ctrl clk_ctrl = REG_RD(clkgen, regi_clkgen,
-		rw_clk_ctrl);
+	hwprot = REG_RD(pinmux, regi_pinmux, rw_hwprot);
+	clk_ctrl = REG_RD(clkgen, regi_clkgen, rw_clk_ctrl);
 
 	switch (function) {
 	case pinmux_eth:
@@ -262,6 +263,7 @@ crisv32_pinmux_dealloc_fixed(enum fixed_function function)
 	int ret = -EINVAL;
 	char saved[sizeof pins];
 	unsigned long flags;
+	reg_pinmux_rw_hwprot hwprot;
 
 	spin_lock_irqsave(&pinmux_lock, flags);
 
@@ -270,7 +272,7 @@ crisv32_pinmux_dealloc_fixed(enum fixed_function function)
 
 	crisv32_pinmux_init(); /* must be done before we read rw_hwprot */
 
-	reg_pinmux_rw_hwprot hwprot = REG_RD(pinmux, regi_pinmux, rw_hwprot);
+	hwprot = REG_RD(pinmux, regi_pinmux, rw_hwprot);
 
 	switch (function) {
 	case pinmux_eth:
