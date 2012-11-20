Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2KTVF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:05:28 -0500
Received: from nm26.access.bullet.mail.mud.yahoo.com ([66.94.237.91]:30256
	"EHLO nm26.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444Ab2KTVFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:05:19 -0500
X-Yahoo-Newman-Id: 578358.4524.bm@smtp108.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: yM6zNKsVM1m2PxQNI_d7KQbiyvHw33xp7bbXEK9BMmjdqvN
 nQEf1aHLPD1Qagh7NkbRlVIYFKNT8kSXRm2RtqjpMTqmCMGq_C3tfTQbHOeA
 K9mcGq5oPJ6_JE5kcvhuMyX7TEgN7hjLin_OD2lNKTkh6cl27g8L6eaXmNRz
 UKu7VFVab3Oy5jY468u3tA8eIN310KhUHZ_cpPvR2fXcbV_4tZymK0oLGBDO
 big3283pUEv9wA2jS7MtPPZNhRdppHKHQg2otxKkRHjFHev6ckph2FlgNa5Q
 cyrSefPUpQGlAIVr8ZWo9FXSf4FURfB2qfjif6ER.PUs3fB3fHuvsuOQ0Qbs
 eG4LUdFqe1xgDHEe6Gjc3AQKoims.7s2b0SKhAnLr44xiVgalTQpTWnaF8FX
 xjaLVQyBpO2HFPY0QxBxT0e7XUSX1IvG32VDlEGeuHbtGa8u_5iV.
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
Subject: [PATCH v6 5/9] bug.h: Fix BUILD_BUG_ON macro in __CHECKER__
Date: Tue, 20 Nov 2012 15:05:03 -0600
Message-Id: <1353445507-7233-5-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
References: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
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

