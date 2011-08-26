Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab1H0O7K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:59:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab1H0O7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:59:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:53 2011
Message-Id: <20110826215053.502040997@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Len Brown <len.brown@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [06/35] x86, intel, power: Correct the MSR_IA32_ENERGY_PERF_BIAS message
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Len Brown <len.brown@intel.com>

commit 17edf2d79f1ea6dfdb4c444801d928953b9f98d6 upstream.

Fix the printk_once() so that it actually prints (didn't print before
due to a stray comma.)

[ hpa: changed to an incremental patch and adjusted the description
  accordingly. ]

Signed-off-by: Len Brown <len.brown@intel.com>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1107151732480.18606@x980
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/intel.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -465,11 +465,11 @@ static void __cpuinit init_intel(struct
 		u64 epb;
 
 		rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
-		if ((epb & 0xF) == 0) {
-			printk_once(KERN_WARNING, "x86: updated energy_perf_bias"
-				" to 'normal' from 'performance'\n"
-				"You can view and update epb via utility,"
-				" such as x86_energy_perf_policy(8)\n");
+		if ((epb & 0xF) == ENERGY_PERF_BIAS_PERFORMANCE) {
+			printk_once(KERN_WARNING "ENERGY_PERF_BIAS:"
+				" Set to 'normal', was 'performance'\n"
+				"ENERGY_PERF_BIAS: View and update with"
+				" x86_energy_perf_policy(8)\n");
 			epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
 			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
 		}


