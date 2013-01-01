Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3AAW43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 17:56:29 -0500
Received: from nm30-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.86]:20644
	"EHLO nm30-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470Ab3AAWyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 17:54:21 -0500
X-Yahoo-Newman-Id: 436759.18166.bm@smtp107.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: mbqF6.gVM1kQWzEe1g4b4O9dOjn5EDVxx86v_LEZEnzlneh
 IH1aMMuvDT1eKc7hvs_IWVftyT9pXIfCczPqv4BFLGn3cshkDyojM4hr46Dh
 vaayeKESaPPuZd1Gn8hhkik4GHy2sfQsdZ4odu3opPNcf2B3h009kNnLLfC_
 TCwZlEu83_wdBRZfvWGnBl7RZCM3kaeSxoYlSmuyOoH4n1XEhQ9rJFqck.C_
 7.gmZTpyiZCCY8HqbWVYgr6HvQB_IAKMMA7HSwPthX3b9wAvGbsqI5l5UZBZ
 xnvej7i63XUpCtTcaO3ENF7vq2o_YJVQSLn_bbV3BtZMQ_MNz78IQ8EVEVIz
 yC4dL2XMrskiHWzuta51LCOUu0HoAWvTQygtc3yzCD0zHkBNoM0ChXiZBJEo
 hFURKV3XaHFb8OiR3Yeud0MCbzReN5YFf7PXYukT2JAGT5gYRtOOWCOh1xWo
 _XtNxxv_gTuvRwfGFmAxSmKl0bM5S_AvCiYXyzTC3PO466928vCfw0BRamK_
 9SLR_1ZHtZ4NXL6Hzs8_._GIdksoGC2c3QySWPSHMHOm06bLiER1M625S715
 dS1gAlHdj6rLSui6vSrk-
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
Subject: [PATCH v8 2/9] compiler-gcc.h: Add gcc-recommended GCC_VERSION macro
Date: Tue,  1 Jan 2013 16:54:04 -0600
Message-Id: <1357080851-30938-3-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
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
1.7.8.6

