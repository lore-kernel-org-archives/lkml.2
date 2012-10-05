Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825Ab2JETns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:43:48 -0400
Received: from nm28-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.128]:32589 "HELO
	nm28-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964810Ab2JETnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:43:43 -0400
X-Yahoo-Newman-Id: 627147.89531.bm@omp1023.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Z45RXKsVM1lzuMbZW8IE6TnB6D7_QcpP.H1bpiL2Ict6Lbv
 ny0GG5n0jxm39oCOO5BK_EjbG2_Q5HxWHZDcFCBL2xz93bBRZhWgoovp1fiD
 QDjtGRwJrp80S0VhclVnECTK1t6p2yabFHepkE4YmcK.ygOpCrpdQq1kl1iK
 h4BxV.ryAeuLJrHOTVNTpPJHY5pRlQcsaHFi5sC0FB1d8L.y9sOCMXEavrgp
 AdI1IDNRdFl8Uc9Z5baDsYLW0mmWxHWo_Uk6LEbXfYgY_St68hiPl9.NycQh
 iV2fsFAE3pJV3g7SWP_mCGZNMg3fDWtyhgZQHgQkDqoykAmcrVIDPKCxmjff
 wqkgtigTLgyJuJFaLfuq9iwHgEqrOkgwSrqDFkK6i6I_Gaq8bRwUKQFGntWT
 aUxjqsGwtxI0RadiTwbllWOVmBX_Q_jY_GvhR2u7C9HLCOsRkWZSF
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v2 08/10] bug.h: Fix BUILD_BUG_ON macro in __CHECKER__
Date: Fri,  5 Oct 2012 14:42:47 -0500
Message-Id: <1349466169-20637-8-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When __CHECKER__ is defined, we disable all of the BUILD_BUG.* macros.
However, BUILD_BUG_ON was evaluating to nothing in this case, and we
want (0) since this is a function-like macro that will be followed by a
semicolon.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index f8eae31..1b43ea2 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -16,7 +16,7 @@ struct pt_regs;
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
-#define BUILD_BUG_ON(condition)
+#define BUILD_BUG_ON(condition) (0)
 #define BUILD_BUG() (0)
 #else /* __CHECKER__ */
 
-- 
1.7.3.4

