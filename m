Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab2HNQXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 12:23:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab2HNQXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 12:23:03 -0400
Subject: Re: [PATCH] select GENERIC_ATOMIC64 for c6x/score/unicore32 archs
From: Mark Salter <msalter@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Aurelien Jacquiot <a-jacquiot@ti.com>,
        linux-c6x-dev@linux-c6x.org, Lennox Wu <lennox.wu@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Date: Tue, 14 Aug 2012 12:22:49 -0400
In-Reply-To: <20120814153413.GA18601@localhost>
References: <20120814153413.GA18601@localhost>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1344961371.30830.43.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 23:34 +0800, Fengguang Wu wrote:
> Sorry I have no compilers for build testing these changes, however the
> risk looks low and it's much better than to leave the arch broken,
> considering that Eric will do atomic64_t in the core fs/namespace.c
> code.
> 
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
> 
> Andrew: the arch maintainers have been CCed. Best is the maintainers
> respond, test and perhaps take the corresponding change. Let's see how
> this will work out..
> 
> 
>  arch/c6x/Kconfig       |    1 +

The c6x port also needs this:

C6X: add L*_CACHE_SHIFT defines
    
C6X currently lacks L*_CACHE_SHIFT defines which are used in a few
places in the generic kernel. This patch adds those missing defines.
    
Signed-off-by: Mark Salter <msalter@redhat.com>
---

diff --git a/arch/c6x/include/asm/cache.h b/arch/c6x/include/asm/cache.h
index 6d521d9..feff1d7 100644
--- a/arch/c6x/include/asm/cache.h
+++ b/arch/c6x/include/asm/cache.h
@@ -1,7 +1,7 @@
 /*
  *  Port on Texas Instruments TMS320C6x architecture
  *
- *  Copyright (C) 2005, 2006, 2009, 2010 Texas Instruments Incorporated
+ *  Copyright (C) 2005, 2006, 2009, 2010, 2012 Texas Instruments Incorporated
  *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -16,9 +16,14 @@
 /*
  * Cache line size
  */
-#define L1D_CACHE_BYTES   64
-#define L1P_CACHE_BYTES   32
-#define L2_CACHE_BYTES   128
+#define L1D_CACHE_SHIFT   6
+#define L1D_CACHE_BYTES   (1 << L1D_CACHE_SHIFT)
+
+#define L1P_CACHE_SHIFT   5
+#define L1P_CACHE_BYTES   (1 << L1P_CACHE_SHIFT)
+
+#define L2_CACHE_SHIFT    7
+#define L2_CACHE_BYTES    (1 << L2_CACHE_SHIFT)
 
 /*
  * L2 used as cache
@@ -29,7 +34,8 @@
  * For practical reasons the L1_CACHE_BYTES defines should not be smaller than
  * the L2 line size
  */
-#define L1_CACHE_BYTES        L2_CACHE_BYTES
+#define L1_CACHE_SHIFT        L2_CACHE_SHIFT
+#define L1_CACHE_BYTES        (1 << L2_CACHE_SHIFT)
 
 #define L2_CACHE_ALIGN_LOW(x) \
        (((x) & ~(L2_CACHE_BYTES - 1)))



