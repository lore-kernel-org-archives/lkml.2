Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab2EYKjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:39:39 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:51374 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab2EYKjh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 25 May 2012 06:39:37 -0400
Message-Id: <4FBF7DA902000078000861EE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 25 May 2012 11:40:09 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/hpet: fix copy-and-paste mistake in earlier change
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes an oversight in 396e2c6fed4ff13b53ce0e573105531cf53b0cad
("x86: Clear HPET configuration registers on startup"), noticed by
Thomas Gleixner.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

--- tip.orig/arch/x86/kernel/hpet.c
+++ tip/arch/x86/kernel/hpet.c
@@ -870,7 +870,7 @@ int __init hpet_enable(void)
 	else
 		pr_warn("HPET initial state will not be saved\n");
 	cfg &= ~(HPET_CFG_ENABLE | HPET_CFG_LEGACY);
-	hpet_writel(cfg, HPET_Tn_CFG(i));
+	hpet_writel(cfg, HPET_CFG);
 	if (cfg)
 		pr_warn("HPET: Unrecognized bits %#x set in global cfg\n",
 			cfg);



