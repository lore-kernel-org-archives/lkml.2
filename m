Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1IMLLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 07:11:53 -0400
Received: from vm4.telegraphics.com.au ([98.124.60.149]:42135 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1IMLLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 07:11:52 -0400
Date: Tue, 13 Sep 2011 21:11:44 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/28 v6] m68k: Convert to genirq
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Message-ID: <alpine.LNX.2.00.1109132030020.14483@nippy.intranet>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Geert,

When I was testing your v5 patch series, I had to patch macmace.c to 
resolve some compiler errors --

--- linux-m68k.orig/drivers/net/macmace.c	2011-09-13 18:33:55.000000000 +1000
+++ linux-m68k/drivers/net/macmace.c	2011-09-13 18:34:05.000000000 +1000
@@ -31,8 +31,8 @@
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
 #include <linux/gfp.h>
+#include <linux/interrupt.h>
 #include <asm/io.h>
-#include <asm/irq.h>
 #include <asm/macints.h>
 #include <asm/mac_psc.h>
 #include <asm/page.h>

Would you please check whether this is still needed after the v6 series? 
(I'd check myself, but I don't have the source tree on which your emailed 
patches were based...)

BTW, you'll probably want to patch this comment in 
include/linux/interrupt.h --

/*
 * Special function to avoid ifdeffery in kernel/irq/devres.c which
 * gets magically built by GENERIC_HARDIRQS=n architectures (sparc,
 * m68k).

Finn
