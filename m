Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab2J1UyD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:54:03 -0400
Received: from nm16.access.bullet.mail.mud.yahoo.com ([66.94.237.217]:42902
	"EHLO nm16.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755416Ab2J1UyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:54:00 -0400
X-Yahoo-Newman-Id: 502270.41597.bm@smtp101.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: IaoTQqoVM1ni4pfK9kxn.r6p0m6QSFoT_QdAdxWmOhRs0gm
 63g0lz_xA2HmfBGzJBM7ay32dLzfqsbRAM1DnKZUh4AQYOjBfX4Ut8ctUmCA
 dWPnxjTPxO1oVrcR1aiRcYMNDtbJF2_9SXAG717Qrldok6HaCLylai_6fQHb
 UPsKvOKCLaBekDne4y5IH9QCzw8reQS.vf6szDwMxK_7ygKtHesFn7sJ7Zo9
 7QVreaPrnkjir91Cu8c84CdG71WRCB6xfFcd4hVKeXv8pq97zXYNAH.Qo9PP
 vw7LIL4OheKwrfGIqVD4VPbK4CZdrVPUrKr4K.hm0yzg.0Aek2qIUZqgykiW
 _7UD9eRVWYumExDbFmH2BFpUrUyBeMOTavdJaYBw51_TzC0LS00eRUvJ9Iii
 FYePc0fZ0zeDw96HUqApdt52z7gM6F1yuWI8_ydAt2w_Ql.n06GIXKroKBTT
 DGliyM8Sr0Blwz7lXqzgN0z5ViSuM8Q--
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
Subject: [PATCH v4 0/10] Cleanup & new features for compiler*.h and bug.h
Date: Sun, 28 Oct 2012 15:53:59 -0500
Message-Id: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 include/linux/bug.h           |   59 ++++++++++++++++++++++++++--------------
 include/linux/compiler-gcc.h  |    3 ++
 include/linux/compiler-gcc3.h |    8 +++---
 include/linux/compiler-gcc4.h |   28 +++++++++---------
 include/linux/compiler.h      |    8 ++++-
 5 files changed, 65 insertions(+), 41 deletions(-)

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
o Introduce GCC_VERSION - (e.g., gcc 4.7.1 becomes 40701)
o Reorder all features based upon the version introduced (readability)
o Change all version checks to use GCC_VERSION
o Remove redundant __linktime_error

bug.h
o Improve BUILD_BUG_ON(expr) - now generates compile-time error post-gcc-4.4
o Remove duplicate error messages in some cases.
o Introduce BUILD_BUG_ON_MSG and clean up the implementations of the
  BUILD_BUG* macros.

