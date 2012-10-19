Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2JSGUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 02:20:08 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:53616 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab2JSGUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 02:20:06 -0400
Message-ID: <5080F0EF.5040100@ahsoftware.de>
Date: Fri, 19 Oct 2012 08:19:27 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: linux-kernel@vger.kernel.org, airlied <airlied@linux.ie>,
        "David S. Miller" <davem@davemloft.net>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        stable@vger.kernel.org
Subject: Re: "read_current_timer" undefined!
References: <1350562575.1270.3.camel@localhost.localdomain>
In-Reply-To: <1350562575.1270.3.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 18.10.2012 14:16, schrieb Thomas Meyer:

> ERROR: "read_current_timer" [drivers/gpu/drm/udl/udl.ko] undefined!
> ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!

There is already a long thread about that, along with patches:

https://lkml.org/lkml/2012/10/9/393

If you need a patch for 3.6, here is what I did before I found the above 
thread:

------------------------------
 From a026451fdc98a5981e10a18ffa394e53a40b0691 Mon Sep 17 00:00:00 2001
From: Alexander Holler <holler@ahsoftware.de>
Date: Thu, 18 Oct 2012 07:29:39 +0200
Subject: [PATCH] arm: arch timer: export read_current_timer()

Exporting read_current_timmer is needed e.g. for users of get_cycles()
like udlfb which otherwise can't be build as a module.

This seems to have been forgotten in
commit 923df96b9f31b7d08d8438ff9677326d9537accf.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
  arch/arm/kernel/arch_timer.c |    2 ++
  1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
index cf25880..7f24d1f 100644
--- a/arch/arm/kernel/arch_timer.c
+++ b/arch/arm/kernel/arch_timer.c
@@ -19,6 +19,7 @@
  #include <linux/interrupt.h>
  #include <linux/of_irq.h>
  #include <linux/io.h>
+#include <linux/export.h>

  #include <asm/cputype.h>
  #include <asm/localtimer.h>
@@ -232,6 +233,7 @@ int read_current_timer(unsigned long *timer_val)
  	*timer_val = arch_counter_get_cntpct();
  	return 0;
  }
+EXPORT_SYMBOL(read_current_timer);

  static struct clocksource clocksource_counter = {
  	.name	= "arch_sys_counter",
-- 
1.7.3.4
------------------------------

Regards,

Alexander
