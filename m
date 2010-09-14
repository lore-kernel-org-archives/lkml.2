Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0INJAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 05:00:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:36365 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab0INJAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 05:00:51 -0400
Message-ID: <4C8F39A6.10504@kernel.org>
Date: Tue, 14 Sep 2010 11:00:22 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: fix build breakage in asm/cacheflush.h
References: <20100914002132.bf17c19e.sfr@canb.auug.org.au>
In-Reply-To: <20100914002132.bf17c19e.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Sep 2010 09:00:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alpha SMP flush_icache_user_range() is implemented as an inline
function inside include/asm/cacheflush.h.  It dereferences @current
but doesn't include linux/sched.h and thus causes build failure if
linux/sched.h wasn't included previously.  Fix it by including the
needed header file explicitly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/alpha/include/asm/cacheflush.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/alpha/include/asm/cacheflush.h b/arch/alpha/include/asm/cacheflush.h
index 01d71e1..012f124 100644
--- a/arch/alpha/include/asm/cacheflush.h
+++ b/arch/alpha/include/asm/cacheflush.h
@@ -43,6 +43,8 @@ extern void smp_imb(void);
 /* ??? Ought to use this in arch/alpha/kernel/signal.c too.  */

 #ifndef CONFIG_SMP
+#include <linux/sched.h>
+
 extern void __load_new_mm_context(struct mm_struct *);
 static inline void
 flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
