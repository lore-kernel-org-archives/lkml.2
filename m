Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab2FWECQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:02:16 -0400
Received: from nm6-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.158]:29195
	"HELO nm6-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751221Ab2FWEBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:01:32 -0400
X-Yahoo-Newman-Id: 299917.55476.bm@smtp103.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: mYnq_OMVM1nIwrX5jA6tB5aqLg4ITirMZpXVQayA4jM7rc1
 qSVWgXiyGAB2XVu5ZapsWfbUKh4.BDnFlruGURrG_Ge09wdfC187THZrfVRm
 sDQqufyikfc3UfzoVV_4JzF74_rTrqNAoe15lMbbxO8hzXYnEkENvBXbvs5A
 0i2jUMbSHBFZrsSyaXw5fvkwfIk3n8NU37jnGadbTu_ZDOGQDOv2_15vf5n4
 YuCv5cb80sa2AuG2ud9tJkrrqFtR_UpfAChq8WFhMdZzsSyhZo1AxXb4rAyP
 AMaI8.gIpkUeVm0PpNCGuKKPG23Opxjpvjh4ebNdxK5Edxznd1WXP7PIVMjB
 cRdVT0xUpTYOJlPCE6aWFdi.OBn7u9nlqmNiVV2OpfPtFKZmZwxv4.ZRNnmG
 NTvEzNovCNYDDpYbioHj8idNcFN1SW5LGNb7.
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v4 5/13] compiler{,-gcc4}.h: Remove duplicate macros
Date: Fri, 22 Jun 2012 23:00:40 -0500
Message-Id: <1340424048-7759-6-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__linktime_error() does the same thing as __compiletime_error() and is
only used in bug.h.  Since the macro defines a function attribute that
will cause a failure at compile-time (not link-time), it makes more
sense to keep __compiletime_error(), which is also neatly mated with
__compiletime_warning().

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/compiler-gcc4.h |    2 --
 include/linux/compiler.h      |    3 ---
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 7ad60cd..5755e23 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -33,8 +33,6 @@
    the kernel context */
 #define __cold			__attribute__((__cold__))
 
-#define __linktime_error(message) __attribute__((__error__(message)))
-
 #ifndef __CHECKER__
 # define __compiletime_warning(message) __attribute__((warning(message)))
 # define __compiletime_error(message) __attribute__((error(message)))
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 923d093..4d9f353 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -293,9 +293,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #ifndef __compiletime_error
 # define __compiletime_error(message)
 #endif
-#ifndef __linktime_error
-# define __linktime_error(message)
-#endif
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
-- 
1.7.3.4

