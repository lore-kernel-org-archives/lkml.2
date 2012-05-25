Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab2EYHWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 03:22:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:56041 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab2EYHWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 03:22:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104167932"
Message-ID: <4FBF32E8.90101@intel.com>
Date: Fri, 25 May 2012 15:21:12 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, andi@firstfloor.org,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] x86 mce: use new printk recursion disabling interface
References: <4FBC444A.6060500@intel.com>  <20120523100138.GA13506@x1.osrc.amd.com> <4FBDCE4A.7050900@intel.com>  <20120524061145.GA18284@liondog.tnic>  <20120524155611.b7aeff4d.akpm@linux-foundation.org> <1337905811.14538.206.camel@ymzhang.sh.intel.com> <4FBF3295.7090608@intel.com>
In-Reply-To: <4FBF3295.7090608@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

Disable printk recursion to make sure MCE logs printed out.

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2afcbd2..365c35d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1015,6 +1015,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	DECLARE_BITMAP(toclear, MAX_NR_BANKS);
 	char *msg = "Unknown";
 
+	printk_recursion_check_disable();
 	atomic_inc(&mce_entry);
 
 	this_cpu_inc(mce_exception_count);
@@ -1144,6 +1145,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
 out:
 	atomic_dec(&mce_entry);
+	printk_recursion_check_enable();
 	sync_core();
 }
 EXPORT_SYMBOL_GPL(do_machine_check);
-- 
1.7.1

