Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab2KMWPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:15:14 -0500
Received: from nm9-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.249]:26446
	"EHLO nm9-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716Ab2KMWN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:13:57 -0500
X-Yahoo-Newman-Id: 515685.28409.bm@smtp115.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: aNIKCD4VM1kFt8k1jA7x8mUTSnSUmwOoePwHDTjhbIkN16P
 7mJuJ0GJbgs0G0k.QVaAoJdPj_RmNe210p7AaPQugCwYnHaGV13l0Fy.3Omr
 jvUr2WN4NjbiQCBwCJ2wE2AHlhh9i5N8artViQIV0eYFu0c5JS03hby_Oc21
 zVY4263ccPg.J1QM2TOrKQS7_6YL.FqZzEYYg2hFmODdRub_caiommgmSsMq
 03tEDpsAWY5laDOc6l0zfpRO7D4pxsx4CL57sTgh_Uuo5JefvfZ7012.w6Up
 TZO_fpFwAW3s3KJDu_lc5sfzcPrkaUU5kau.tmA5BpSZbXhudeZhIOR86rh2
 bAxSFEQZLRkg0UG_LR7Hyd23qFnHfXL1I9Tng1vYauwnkhhnY0tYLKkf9T7b
 .42sZFvthPW2c2SCN_9T4N.kGIVhlEYyuzHOQsy5YY0ZhEQtndOhl
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v5 5/9] bug.h: Fix BUILD_BUG_ON macro in __CHECKER__
Date: Tue, 13 Nov 2012 16:13:37 -0600
Message-Id: <1352844821-18952-5-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When __CHECKER__ is defined, we disable all of the BUILD_BUG.* macros.
However, both BUILD_BUG_ON_NOT_POWER_OF_2 and BUILD_BUG_ON was
evaluating to nothing in this case, and we want (0) since this is a
function-like macro that will be followed by a semicolon.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 298a916..1b2465d 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -12,10 +12,10 @@ enum bug_trap_type {
 struct pt_regs;
 
 #ifdef __CHECKER__
-#define BUILD_BUG_ON_NOT_POWER_OF_2(n)
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
-#define BUILD_BUG_ON(condition)
+#define BUILD_BUG_ON(condition) (0)
 #define BUILD_BUG() (0)
 #else /* __CHECKER__ */
 
-- 
1.7.3.4

