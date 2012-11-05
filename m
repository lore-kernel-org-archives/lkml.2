Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab2KETGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:06:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:36218 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933202Ab2KETGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:06:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,716,1344236400"; 
   d="scan'208";a="237514588"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v3 8/8] x86/lguest: Use __pa_symbol instead of __pa on C
	visible symbols
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Date: Mon, 05 Nov 2012 11:06:20 -0800
Message-ID: <20121105190618.10205.95341.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121105185657.10205.27419.stgit@gitlad.jf.intel.com>
References: <20121105185657.10205.27419.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
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
index df4176c..1cbd89c 100644
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
 

