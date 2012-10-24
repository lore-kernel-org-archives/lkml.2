Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab2JXQlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:41:39 -0400
Received: from nm9.access.bullet.mail.sp2.yahoo.com ([98.139.44.136]:30450
	"EHLO nm9.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935221Ab2JXQkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:40:08 -0400
X-Yahoo-Newman-Id: 845324.79197.bm@smtp105.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: b55g8SQVM1nSdYyiVv_jNIKF7019afaQKHUIYsA2_6jpIuo
 vor1pKFHmRbrwbGi6jbZEYI3CTN3RoWWAiOi0ZEvNInAlE.4_1C9ww8vFG6a
 M7itMhBhmT_AMj1nksBMr6xXCMCqhNHQD5.xZ3bWirSXB2cKunkNWGpAxjDk
 dXK8mwSugYQlExyXcQiDj6bMpgNPlyLhPurunxKHte5NYSWpqQUzXGrKxq6T
 44IjhSJ1GKmPHwyC14Ss7.IV8QUz6v.zOB4LLCdjWDu9vlWsESo7x5sHH.b7
 .s4fR_qGKgFRsjxxeq3D2D9v.5.IwKUfwJRPYiIYoE73dzQ7S17XFl45F5pV
 Ad.6KlGn5TFevGCOg_R.1E2SUJ1_3_p2WlVN3oqEIco.MdKBKGmYM.km2VIn
 _OgHa_Ahj7HAI_QwU_yz6WsZJkBFK96qQNTBu9D7_5plUsXlsR8lNqOBD6f4
 Y2aUbfVSskWrNiuYWwZBnec.ERuZQJrtWMejW8gtQALXcw0X1Getl5P6990V
 tYfId8GrVKmn_kOxC1uls15KGOZn4Fintv510bLKNQQKRn9iIBz1lxzedSSw
 cRD0hZsswE3yq9NEgOTg-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v3 02/10] compiler-gcc.h: Add gcc-recommended GCC_VERSION macro
Date: Wed, 24 Oct 2012 11:33:53 -0500
Message-Id: <1351096441-12388-2-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
References: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Throughout compiler*.h, many version checks are made.  These can be
simplified by using the macro that gcc's documentation recommends.
However, my primary reason for adding this is that I need bug-check
macros that are enabled at certain gcc versions and it's cleaner to use
this macro than the tradition method:

if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ => 2)

If you add patch level, it gets this ugly:

if __GNUC__ > 4 || (__GNUC__ == 4 && (__GNUC_MINOR__ > 2 || \
   __GNUC_MINOR__ == 2 __GNUC_PATCHLEVEL__ >= 1))

As opposed to:

if GCC_VERSION >= 40201

While having separate headers for gcc 3 & 4 eliminates some of this
verbosity, they can still be cleaned up by this.

See also:
http://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Acked-by: David Rientjes <rientjes@google.com>
---
 include/linux/compiler-gcc.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 6a6d7ae..24545cd 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -5,6 +5,9 @@
 /*
  * Common definitions for all gcc versions go here.
  */
+#define GCC_VERSION (__GNUC__ * 10000 \
+		   + __GNUC_MINOR__ * 100 \
+		   + __GNUC_PATCHLEVEL__)
 
 
 /* Optimization barrier */
-- 
1.7.3.4

