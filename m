Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab2E1C5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 22:57:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:36293 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab2E1C5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 22:57:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="157794325"
Message-ID: <4FC2E944.6060903@intel.com>
Date: Mon, 28 May 2012 10:56:04 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v3 2/2] x86 mce: use new printk recursion disabling interface
References: <4FBC444A.6060500@intel.com>  <20120523100138.GA13506@x1.osrc.amd.com> <4FBDCE4A.7050900@intel.com>  <20120524061145.GA18284@liondog.tnic>  <20120524155611.b7aeff4d.akpm@linux-foundation.org>  <1337905811.14538.206.camel@ymzhang.sh.intel.com>  <4FBF3295.7090608@intel.com>  <3908561D78D1C84285E8C5FCA982C28F192F4D39@ORSMSX104.amr.corp.intel.com> <1338165058.14538.209.camel@ymzhang.sh.intel.com> <4FC2E8CF.2040109@intel.com>
In-Reply-To: <4FC2E8CF.2040109@intel.com>
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

