Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab0IGOgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:36:09 -0400
Received: from www.tglx.de ([62.245.132.106]:43935 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab0IGOdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:55 -0400
Message-Id: <20100907125056.990178973@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:33:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Tony Luck <tony.luck@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [patch 24/30] ia64: salinfo: sema_init instead of init_MUTEX
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=ia64-salinfo-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-ia64@vger.kernel.org

---
 arch/ia64/kernel/salinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/ia64/kernel/salinfo.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/salinfo.c
+++ linux-2.6/arch/ia64/kernel/salinfo.c
@@ -642,7 +642,7 @@ salinfo_init(void)
 	for (i = 0; i < ARRAY_SIZE(salinfo_log_name); i++) {
 		data = salinfo_data + i;
 		data->type = i;
-		init_MUTEX(&data->mutex);
+		sema_init(&data->mutex, 1);
 		dir = proc_mkdir(salinfo_log_name[i], salinfo_dir);
 		if (!dir)
 			continue;


