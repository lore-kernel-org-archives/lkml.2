Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935207Ab2JXQeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:34:18 -0400
Received: from nm14-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.15]:43373
	"EHLO nm14-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932242Ab2JXQeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:34:16 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2012 12:34:16 EDT
X-Yahoo-Newman-Id: 428649.45198.bm@smtp105.sbc.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LvZj2u0VM1lvz7NCTQm76CtbGy3XMIx8YiHsFrAweZxhIit
 vVnlS7UL32fveP9f7LoP9UIJIvkPUfwKfIDYp7sJM4CIZGXHrwGrnykMTexg
 Y4suUjHROJqdvdEvIvJR2Ly1y5ldcsbo.7uMwvMGeXNdLG9UgqDnsIFmzuKM
 kmGOcWWfRpCDuG_lL3Cph9wo._7jhudbLtXkj4c7JVrNqO4NZ3UzSWcvBn0N
 x4TdhnMD8NkH5zx_vYBdL8beFn7sdcY3rAlVQhO0d_nlUFX6mbUJRUzTJlaw
 q4kDWAqU3.gp6GKS9DQgbHIzAPtzb7nNsaB4iM6wMf43mBoNUUO6amXO9980
 N210ByDyKBuSvsaILpIGrGFr_WSoknc9mHrB9AhkfronLRX4dpZsv80tDS17
 8EjV9e3SDjbG9XQelerieOwKWQNGY4WhJZx5h3s835t4AKrM6VjMS
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
Subject: [PATCH v3 0/10] Cleanup & new features for compiler*.h and bug.h
Date: Wed, 24 Oct 2012 11:28:42 -0500
Message-Id: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

