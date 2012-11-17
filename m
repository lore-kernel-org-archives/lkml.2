Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2KQAal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:30:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37738 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2KQAak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:30:40 -0500
Date: Fri, 16 Nov 2012 16:30:02 -0800
From: tip-bot for Alexander Duyck <alexander.h.duyck@intel.com>
Message-ID: <tip-0fde5066220588e8144b996ac4a3df5a91c93459@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, alexander.h.duyck@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        alexander.h.duyck@intel.com, rusty@rustcorp.com.au, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20121116215748.8521.83556.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116215748.8521.83556.stgit@ahduyck-cp1.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/lguest:
  Use __pa_symbol instead of __pa on C visible symbols
Git-Commit-ID: 0fde5066220588e8144b996ac4a3df5a91c93459
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Nov 2012 16:30:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0fde5066220588e8144b996ac4a3df5a91c93459
Gitweb:     http://git.kernel.org/tip/0fde5066220588e8144b996ac4a3df5a91c93459
Author:     Alexander Duyck <alexander.h.duyck@intel.com>
AuthorDate: Fri, 16 Nov 2012 13:58:12 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 16 Nov 2012 15:20:53 -0800

x86/lguest: Use __pa_symbol instead of __pa on C visible symbols

The function lguest_write_cr3 is using __pa to convert swapper_pg_dir and
initial_page_table from virtual addresses to physical.  The correct function
to use for these values is __pa_symbol since they are C visible symbols.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Link: http://lkml.kernel.org/r/20121116215748.8521.83556.stgit@ahduyck-cp1.jf.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/lguest/boot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
 
