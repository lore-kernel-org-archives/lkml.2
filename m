Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab1DZV3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:29:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:48614 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab1DZVO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483608"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: JBeulich@novell.com, jbeulich@novell.com, ak@linux.intel.com,
        mingo@elte.hu, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [57/106] x86: Fix a bogus unwind annotation in lib/semaphore_32.S
Message-Id: <20110426211337.B630D3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jan Beulich <JBeulich@novell.com>

commit e938c287ea8d977e079f07464ac69923412663ce upstream.

'simple' would have required specifying current frame address
and return address location manually, but that's obviously not
the case (and not necessary) here.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <4D6D1082020000780003454C@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/lib/semaphore_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/x86/lib/semaphore_32.S
===================================================================
--- linux-2.6.35.y.orig/arch/x86/lib/semaphore_32.S
+++ linux-2.6.35.y/arch/x86/lib/semaphore_32.S
@@ -36,7 +36,7 @@
  */
 #ifdef CONFIG_SMP
 ENTRY(__write_lock_failed)
-	CFI_STARTPROC simple
+	CFI_STARTPROC
 	FRAME
 2: 	LOCK_PREFIX
 	addl	$ RW_LOCK_BIAS,(%eax)
