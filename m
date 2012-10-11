Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030268Ab2JKUul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:50:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:44714 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030260Ab2JKUuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:50:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="203427811"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v2 8/8] x86/lguest: Use __pa_symbol instead of __pa on C
	visible symbols
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Date: Thu, 11 Oct 2012 13:50:35 -0700
Message-ID: <20121011205035.12787.84083.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121011204324.12787.30514.stgit@gitlad.jf.intel.com>
References: <20121011204324.12787.30514.stgit@gitlad.jf.intel.com>
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
 

