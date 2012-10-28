Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab2J1U7A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:59:00 -0400
Received: from nm19-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.172]:38163
	"EHLO nm19-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755566Ab2J1U5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:57:08 -0400
X-Yahoo-Newman-Id: 936128.16106.bm@smtp105.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: C_0IDDsVM1mLw9NWW6jl1fH9nIrL2TYpTfiBtW2d6JTm7yv
 D5ShFnxlZ_TpFoObZ2.5WSpdAYhSNUD0PZibLQG8Cvdp.dJlg_uLG4Sc7swF
 phk7luOqKh7VCWjrzwIMEw5opoFy.3dstqS2ydOMbu048jvtN1_WxGTJ.hNU
 cloc_bSn4q37Ui56.KYZeJM.mE2i_NJvtxNw4imQFDXiEzHEl6Lt3VSdO1iU
 jgkvNsevH.QbhvzI5MT9vEQRa.MDGbzwobiszdvH7NWB.yNCQjnt_weFxX82
 DQDZAGLvp_Oon8XIbFg3j8pCZvNyB8RP7ikMbmf8QiC58CJAzvvADzQpcYKP
 .7Gg4_QuiJFMrXJTrYvIag39OEr7YfwTetOz4yqMBufn.ZiH83Z3lK6L9Q4U
 l3Mes4m5O_eLWDxudvUwy_5gMfC53yMLGmdbkfRLCfkDNi9zvUIgpOWz882L
 85MjEWZrPVlCVwRYsUrAiL1aUrtNfaAULY2dbDf.IXwiDQEYuPxPGB99sKVq
 lDXCezDaYb42CFj_hnnTsO3u_NwbOzYdRZMVFNa3jhlQ-
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
Subject: [PATCH v4 2/9] compiler-gcc.h: Add gcc-recommended GCC_VERSION macro
Date: Sun, 28 Oct 2012 15:57:08 -0500
Message-Id: <1351457835-7553-2-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
References: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
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

