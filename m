Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab0JYFyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 01:54:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:59870 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab0JYFyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 01:54:44 -0400
Subject: [PATCH v2] apic, x86: Need to set offset before using it
From: Jaswinder Singh <jaswinder@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1287985605.2940.4.camel@netbook.satnam>
References: <1287985605.2940.4.camel@netbook.satnam>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 11:28:08 +0530
Message-ID: <1287986288.2940.6.camel@netbook.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the issue pointed by Stephen.
 
Stephen Rothwell wrote :
In building Linus' tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

arch/x86/oprofile/op_model_amd.c: In function 'ibs_eilvt_valid':
arch/x86/oprofile/op_model_amd.c:289: warning: 'offset' may be used uninitialized in this function

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/oprofile/op_model_amd.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 42fb46f..c65a924 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -285,6 +285,7 @@ static inline int ibs_eilvt_valid(void)
 	int offset;
 
 	rdmsrl(MSR_AMD64_IBSCTL, val);
+	offset = val & IBSCTL_LVT_OFFSET_MASK;
 	if (!(val & IBSCTL_LVT_OFFSET_VALID)) {
 		pr_err(FW_BUG "cpu %d, invalid IBS "
 		       "interrupt offset %d (MSR%08X=0x%016llx)",
@@ -293,8 +294,6 @@ static inline int ibs_eilvt_valid(void)
 		return 0;
 	}
 
-	offset = val & IBSCTL_LVT_OFFSET_MASK;
-
 	if (eilvt_is_available(offset))
 		return !0;
 
-- 
1.7.2.3


