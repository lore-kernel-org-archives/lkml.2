Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2KTUmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:42:17 -0500
Received: from nm3-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.108]:44868
	"EHLO nm3-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751933Ab2KTUmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:42:15 -0500
X-Yahoo-Newman-Id: 964531.40375.bm@smtp115.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: FmlQtYoVM1mai4iwJSpXEUQSoU6Z9RbkH9aQKY4CS4U36WS
 w4_qFxe030FBCUy4sn0s7LNQe6hVYZQrb660ND9jsQfMIvcLRR_NI4ZrwliF
 5S3MN_RIetbsSxNhKf3tTHrdrrm17OPubgLtG1vzOMMf7u.qayJejftxbNR9
 ztVxjAkQ2ZlpMAiAWBhG6rTbtmMVts2NTJ_BxIGPIiSABKfpG64hMIhY_f4d
 NEN3nDuO6DiykQ3dASAfpN6mUm3yw5gPAr1yNadLfps.9olZzx6d6qUpZXP_
 Q2ih4Z7BP5PY8x5KjkrAb8BdC6VPYHkS8355eFIT2JMVuOXlzAqQjfflezYG
 5NkGoelQhliAUtljgd6wb6UcC2z9Hnd5C_8OYBUcqVwugJDf7yVPyOXY1x3a
 cFKJdspymj9R9ttBRebSeaB5hthE38F8AY8ETrcPKGOJgZKwSt6RLEBLovkp
 frH9MYw8eFxS6Cz.vbwCFpuOoBlXc
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
Subject: [PATCH v6 0/9] Cleanup & new features for compiler*.h and bug.h
Date: Tue, 20 Nov 2012 14:42:03 -0600
Message-Id: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 include/linux/bug.h           |   47 ++++++++++++++++++++++------------------
 include/linux/compiler-gcc.h  |    3 ++
 include/linux/compiler-gcc3.h |    8 +++---
 include/linux/compiler-gcc4.h |   28 ++++++++++++------------
 include/linux/compiler.h      |   32 +++++++++++++++++++++++++--
 5 files changed, 76 insertions(+), 42 deletions(-)

Changes in v6:
o Remove extraneous double negation
o Fixed faulty macro expansion in last patch

Changes in v5:
o Move BUILD_BUG* guts to a new compiletime_assert() macro in compiler.h.
o Fix a double-evaluation problem.
o Fix another bad macro definition when __CHECKER__ defined.

Changes in v4:
o Squash a minor commit (per Borislav Petkov)
o Change some comment text (per Borislav Petkov)
o Add some acks

This patch set is a dependency of the generic red-black tree patch set, which
I have now split up into three smaller sets and is based off of linux-next.

The major aim of this patch set is to cleanup compiler-gcc*.h and improve
the manageability of of compiler features at various versions (when they
are broken, etc.), add some needed features to bug.h and clean that up as
well.

compiler-gcc*.h
o Introduce GCC_VERSION - (e.g., gcc 4.7.1 becomes 40701).
o Reorder all features based upon the version introduced (readability).
o Change all version checks to use GCC_VERSION.
o Remove redundant __linktime_error macro.
o Introduce compiletime_assert() macro.

bug.h
o Improve BUILD_BUG_ON(expr) - now generates compile-time error post-gcc-4.4
o Remove duplicate error messages in some cases.
o Fix double-evaluation problem in BUILD_BUG_ON.
o Fix bad macro definitions when using __CHECKER__.
o Introduce BUILD_BUG_ON_MSG and clean up the implementations of the
  BUILD_BUG* macros.
