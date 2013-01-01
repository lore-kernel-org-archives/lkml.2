Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3AAWyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 17:54:41 -0500
Received: from nm16-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.19]:38937
	"EHLO nm16-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527Ab3AAWy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 17:54:26 -0500
X-Yahoo-Newman-Id: 175755.18166.bm@smtp107.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: uqmCNE0VM1kxN5pVrPloNe6dBcxF_wpYmqVP3yn4pWybB1j
 wr_8RSoZRQtqC.waxe764W2WXvACJOv5QjWufhFK4rfB8ctn07HnV9xXPf6L
 NYWsEEhAQ3TrTHYWVyxFj.1ibjosUzGoAwYhABd0Dr4N4KIrJFqkV47Zqeq6
 oC5c4V66oUmiNfba0OZn0Ggcct9kWKTIhWweaXQf4lQXRuKcrualESlFGea.
 ewlg7UL9lazDUh.6AEEH76A0Im28D7QAPqAQfzNMA4jIFFNd_tJmO_q45DtT
 zvn5t7X9QPyD_dgXqMdzDAXJeusFm_MgKoMwuspOqVY4i0TrDp6MzE_3iRkl
 .RHaQmJQcAiAZAtVKXWF.eWtD348El1Hh9qNfDc3jlNjdXxSkd5sli_rdRlb
 zNw9Nr6M_GOITubYDnJQgzG2PbjWEURykH8iQgZ8fW_fV.sKWUTFMoA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v8 5/9] bug.h: Fix BUILD_BUG_ON macro in __CHECKER__
Date: Tue,  1 Jan 2013 16:54:07 -0600
Message-Id: <1357080851-30938-6-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When __CHECKER__ is defined, we disable all of the BUILD_BUG.* macros.
However, both BUILD_BUG_ON_NOT_POWER_OF_2 and BUILD_BUG_ON was
evaluating to nothing in this case, and we want (0) since this is a
function-like macro that will be followed by a semicolon.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: Borislav Petkov <bp@alien8.de>
---
 include/linux/bug.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 2a11774..27d404f 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -12,11 +12,11 @@ enum bug_trap_type {
 struct pt_regs;
 
 #ifdef __CHECKER__
-#define BUILD_BUG_ON_NOT_POWER_OF_2(n)
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
 #define BUILD_BUG_ON_INVALID(e) (0)
-#define BUILD_BUG_ON(condition)
+#define BUILD_BUG_ON(condition) (0)
 #define BUILD_BUG() (0)
 #else /* __CHECKER__ */
 
-- 
1.7.8.6

