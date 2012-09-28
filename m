Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2I1XXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:23:17 -0400
Received: from nm23-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.191]:40881 "HELO
	nm23-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758874Ab2I1XU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:20:58 -0400
X-Yahoo-Newman-Id: 277694.39372.bm@omp1020.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9ZJLYgUVM1kFGqKSue4JAXUMH.vEnA0zYkOmEKw_6dmhRr6
 ybKjBz.hTY5IDqV_2raV1r9CRVS5UlQaRqkL_JiEwP6yJacx0dZQiWFVStPy
 GFM82LRRViEzcSedh6R_LdBXk_Ld5SFiGspurVmL7kaqcqg6SRq_7gp1IUo9
 xrhgkhYWL2sdMwr4L6oyunNZYQgW8OJ9piLvvGYMKETTh_rzkrgGypB0tIEI
 F5UvFJMV0KJSho7SFGJvrJy86bSvl1IbUTi2KmlX6G3C0xbikKgHbzopxEgH
 DE2DJr0fg4FZNtakykhL0rF.gwX9ddgYmqY6MLlmnqmvidvXYu8EDc070o8z
 si3x5KQNo8pAh9dMec7awsQoHNz66BQIDvVwoH_R7eliOxGvIYcqBBbLOCPj
 pxKnbnoiRrDXZfdQxOxGhFPKKm55q2wK6v..w7RW6MRAjQoU6UH1f2.dDZmH
 v2Sk2v6lY5v3ZfaFv6oNsd0FqpQRsGzYFsfUjp1bc2PLl.vLnJLDjiOfrKJQ
 b0uOnkiDC8t5c.Lph0YfO8wTUfqbN7INrp5juzpDqcg--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/10] compiler-gcc.h: Add gcc-recommended GCC_VERSION macro
Date: Fri, 28 Sep 2012 18:20:04 -0500
Message-Id: <1348874411-28288-4-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
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

