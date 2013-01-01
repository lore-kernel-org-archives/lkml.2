Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3AAVKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 16:10:21 -0500
Received: from nm5-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.155]:40441
	"EHLO nm5-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab3AAVKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 16:10:16 -0500
X-Yahoo-Newman-Id: 792405.17119.bm@smtp109.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: caCNXOEVM1lRxHiNXacGnMqZukVLG_HO.5wuNludRfE0Dcz
 PZGXVOPfqpxLChkT.iHffcTJHBDxOp5KMBRQ4MTevq41lXFYKp6_jqS_XfMc
 YJnYQRmDqy5eRCGHfNbxi5dgRVFHHr94_9QKivUzjNevYCgXssS9_Htm46EK
 U_s6.oYnBs9RGI.k.RfLLBYdXYa7oDCeMr3t9Skj8YkErP3Ceoc940pFYHhD
 zU05EtCcAgn0m7B875cTRdzkanX1J22mItcgoVW5XPUAukZXynghW91asmPR
 C5.7QHBKJ8Y2718v0DNk73XjOIIXzSx7QIwmqkI54cl.BSkaEfOAewckKhTy
 ZMxIGrOoeXgIXlnpVvAj1tOIjg5eXln2LaWk8pDJKXd6WSR3UgWpY5avf3wn
 SR5xL.auFa9cz8mj0GvFDMCx3xtdePPAXr0Rpryw315u9r.GzjlYTHUU2rdr
 fF7A5mknGDSM8r_1D0.GkBZySmn7_
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
Subject: [PATCH v7 5/9] bug.h: Fix BUILD_BUG_ON macro in __CHECKER__
Date: Tue,  1 Jan 2013 15:09:53 -0600
Message-Id: <1357074597-21722-5-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1357074597-21722-1-git-send-email-daniel.santos@pobox.com>
References: <1357074491-21669-1-git-send-email-daniel.santos@pobox.com>
 <1357074597-21722-1-git-send-email-daniel.santos@pobox.com>
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

