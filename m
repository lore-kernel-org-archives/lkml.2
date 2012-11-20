Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2KTVFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:05:18 -0500
Received: from nm3-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.136]:28515
	"EHLO nm3-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752977Ab2KTVFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:05:15 -0500
X-Yahoo-Newman-Id: 334806.4524.bm@smtp108.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: y8SaVBkVM1mYQjSCb1E.92PBCG8su2B7Omt7GBYuIveNOW9
 DZZP1pkJXD9Gze2pxjt7ryCMH9ZV6wLC.Xe_n0QglUVY0l.R79.MdeD56Sqz
 vx2ssBwlx4cxs5mENXnCYo_AMh3WBPliRQzUjL9wQocmZTiVbTK4Oum_EyFF
 GkJOpdCLQOVZEJxShHzbZktLYKQ9aKJphi16c2P8A.3JfuG0VGYNpwgwF1tD
 3z0JmfyqC6LWcR4aTGyLTLpHCQDmGx_WjA4fNdoJmTIOhMRO7QKVZOufOEM5
 Vtyq_wr852.IjYdGapOIgtAVQ2XC3o8yy9scytCVpWfnxc9DKfe.vykXORRJ
 bKz2GDvnWvgWIvRCe.q5P0ELBZBR0pPA1dqyKiyQwjeusQTCU.IPOsBApUNX
 z8Od2D_GMW7e0KBHKVGKY3NTNBWCdqV_M6s_FTsNMIVmL_Q9Gwv2RWta0TiG
 Iiajhin0B2EMiwC2JQZ5Sc7pw8q0NXrIHdkk3kSWENaJ27PWxxpeBsFydylC
 JfFHxOa29xLm1awefPpmPHLMsUCCm9Wf_Mw3RP3yKsmsSRT7xF2_EC5gWxev
 17ylTgyZca6smeU8XS5A-
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
Subject: [PATCH v6 2/9] compiler-gcc.h: Add gcc-recommended GCC_VERSION macro
Date: Tue, 20 Nov 2012 15:05:00 -0600
Message-Id: <1353445507-7233-2-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
References: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
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

