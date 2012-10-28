Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2J1U57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:57:59 -0400
Received: from nm11.access.bullet.mail.sp2.yahoo.com ([98.139.44.138]:24688
	"EHLO nm11.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755779Ab2J1U5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:57:16 -0400
X-Yahoo-Newman-Id: 897975.16106.bm@smtp105.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Z7xYwlgVM1nhv7pF3JGcthvFBoEx.D83mP1lmDIy5Twa.LN
 i2LNe5fPWbfkQCf76EOJD51vJTFRxXl9IRRCuuBp4rtbE14TD8oqjq_vazzQ
 H6Xk6SFjqvNJGKfMZYKg14axOBHc8_R5WDA_H9cu5e_ztgNxTSf0fYfmrr.o
 rFUXwiaL.rJwf2t3tpECgBak.cZ8VAXrtbSCgjP3z7s0nEAdahBHw1Gm8OHc
 PPUWo0eHw0begxfUoOxXIhmbGGNJAJ20rdy0mp_nOIuGSHmHZfaxXPvbn0hL
 GGL7Zjp5zzkUDJ0BIeDr7YaBiij1IPn7A0QHu_oMV14Vb9r7LjpEEUWtOfYA
 2OsNPiGPs2aFQFeHETCQeLlzmNPNyZMEwpEoO.i9ggIYg_gr_wfhDPxBnZ9l
 wqBIwOhAajdrY2RD14b03plqA.4qCezRECc3Y6ylRv8nKr3tO96iePvHLTe5
 vvutpTRwVkM6FPVYA0T1_ZvheAYNMmNFCfyB0.7A-
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
Subject: [PATCH v4 7/9] bug.h: Fix BUILD_BUG_ON macro in __CHECKER__
Date: Sun, 28 Oct 2012 15:57:13 -0500
Message-Id: <1351457835-7553-7-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
References: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
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
index da03dc1..6c38988 100644
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

