Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2KMWJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:09:35 -0500
Received: from nm2-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.66]:36644
	"EHLO nm2-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014Ab2KMWJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:09:34 -0500
X-Yahoo-Newman-Id: 989503.5693.bm@smtp112.sbc.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: vj.4sigVM1ndufycAmX8H8WJmjOvJXmETH8ABoR5aq4aEQ9
 4RvqFUQ05V7nozoHFD38xwZCdfUAGyNIoFu5U.L7fosrIi4vos7VzlN9uMLi
 TNHQkrnVFoxTWg84LSoL0OeOnBgNP9jtLHQDpDWTk.mfjvvqxVey5apDyOea
 29lrNJn0I9e0zHzujZAD4Iug7jM27DwiZPR08VB5K4FVlbl25k7QtdOkk_sj
 eeZbC8ooq.9BV7OusR03uwq24Y2BDXyFVXlnMXlkL5PxNUvNKrJu9BT5bLRi
 33H0eGxcNw4YTuE507yULrtGFsatuB3TqCXEkadbZrGXIRCvRZO.8l.ruPKV
 D.TJGqghTKI0IQksAW4ffTgE44qBNH5Oz5sOZv0wF0QXQldZbFmKtBQ9nvlY
 a.9cGzhIG7QtTyRSKZVTTp8OMapBPjuYyMvSkWjwql9LmNZfdmOuNvuNGGE9
 9rhxkQv9afpOgCmqm5L8RjmQAyhXMbQ--
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
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v5 0/9] Cleanup & new features for compiler*.h and bug.h
Date: Tue, 13 Nov 2012 16:09:19 -0600
Message-Id: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
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
