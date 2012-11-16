Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab2KPV7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:59:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:2958 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460Ab2KPV7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:59:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,266,1352102400"; 
   d="scan'208";a="220838776"
Subject: [PATCH v4 8/8] x86/lguest: Use __pa_symbol instead of __pa on C
 visible symbols
To: tglx@linutronix.de, mingo@redhat.com, andi@firstfloor.org, hpa@zytor.com
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 13:58:12 -0800
Message-ID: <20121116215748.8521.83556.stgit@ahduyck-cp1.jf.intel.com>
In-Reply-To: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function lguest_write_cr3 is using __pa to convert swapper_pg_dir and
initial_page_table from virtual addresses to physical.  The correct function
to use for these values is __pa_symbol since they are C visible symbols.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 arch/x86/lguest/boot.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 642d880..139dd35 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -552,7 +552,8 @@ static void lguest_write_cr3(unsigned long cr3)
 	current_cr3 = cr3;
 
 	/* These two page tables are simple, linear, and used during boot */
-	if (cr3 != __pa(swapper_pg_dir) && cr3 != __pa(initial_page_table))
+	if (cr3 != __pa_symbol(swapper_pg_dir) &&
+	    cr3 != __pa_symbol(initial_page_table))
 		cr3_changed = true;
 }
 

