Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab2IUVCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:02:05 -0400
Received: from mail1.windriver.com ([147.11.146.13]:52960 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab2IUVCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:02:04 -0400
Message-ID: <505CD5C3.3020009@windriver.com>
Date: Fri, 21 Sep 2012 16:01:55 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] kgdb: Fix warning with !CONFIG_DEBUG_RODATA
References: <1348261150-12423-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1348261150-12423-1-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 03:59 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Fixes
> 
> arch/x86/kernel/kgdb.c: In function ‘kgdb_arch_set_breakpoint’:
> arch/x86/kernel/kgdb.c:749:7: warning: unused variable ‘opc’ [-Wunused-variable]
> 
> when CONFIG_DEBUG_RODATA is not defined.
> 

This is already pending along with other fixes in kgdb-next / linux next for the 3.7 merge window.

Jason.

--
commit 9a15c35d16cf76482be076125f631f1193e29413
Author: Jason Wessel <jason.wessel@windriver.com>
Date:   Wed Aug 8 21:12:19 2012 -0500

    kgdb,x86: fix warning about unused variable
    
    When compiling without CONFIG_DEBUG_RODATA the following
    compiler warning is generated:
    
    arch/x86/kernel/kgdb.c: In function 'kgdb_arch_set_breakpoint':
    arch/x86/kernel/kgdb.c:749: warning: unused variable 'opc'
    
    The variable instantiation needs to be inside the #ifdef to
    make the warning go away.
    
    Reported-by: Thiago Rafael Becker <trbecker@trbecker.org>
    Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 3f61904..836f832 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -746,7 +746,9 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip
 int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 {
        int err;
+#ifdef CONFIG_DEBUG_RODATA
        char opc[BREAK_INSTR_SIZE];
+#endif /* CONFIG_DEBUG_RODATA */
 
        bpt->type = BP_BREAKPOINT;
        err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,

