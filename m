Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab0FFPPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 11:15:45 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51349 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757995Ab0FFPP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 11:15:26 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       =?UTF-8?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>,
       Andy Isaacson <adi@hexapodia.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, walter harms <wharms@bfs.de>,
       Joerg Roedel <joro@8bytes.org>, Jan Engelhardt <jengelh@medozas.de>
Cc: Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 2/7] Add Documentation/coccinelle.txt
Date: Sun,  6 Jun 2010 17:15:02 +0200
Message-Id: <1275837307-4283-3-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275837307-4283-1-git-send-email-npalix@diku.dk>
References: <1275837307-4283-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this file is to document how to use Coccinelle and its
spatch tool to check the Linux kernel.

It gives information on where and how to retrieve Coccinelle, and how
to use it with the Coccinelle scripts integrated in the Linux kernel.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 Documentation/coccinelle.txt |  258 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 258 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/coccinelle.txt

diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
new file mode 100644
index 0000000..ba3315d
--- /dev/null
+++ b/Documentation/coccinelle.txt
@@ -0,0 +1,258 @@
+Copyright 2010 Nicolas Palix <npalix@diku.dk>
+Copyright 2010 Julia Lawall <julia@diku.dk>
+Copyright 2010 Gilles Muller <Gilles.Muller@lip6.fr>
+
+
+ Getting Coccinelle
+~~~~~~~~~~~~~~~~~~~~
+
+The semantic patches included in the kernel use the 'virtual rule'
+feature which was introduced in Coccinelle version 0.1.11.
+
+Coccinelle (>=0.2.0) is available through the package manager
+of many distributions, e.g. :
+
+ - Debian (>=squeeze)
+ - Fedora (>=13)
+ - Ubuntu (>=10.04 Karmic Koala)
+ - OpenSUSE
+ - Arch Linux
+ - NetBSD
+ - FreeBSD
+
+
+You can get the latest version released from the Coccinelle homepage at
+http://coccinelle.lip6.fr/
+
+Once you have it, run the following command:
+
+     	./configure
+        make
+
+as a regular user, and install it with
+
+        sudo make install
+
+
+ Using Coccinelle on the Linux kernel
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+A Coccinelle-specific target is defined in the top level
+Makefile. This target is named 'coccicheck' and calls the 'coccicheck'
+front-end in the 'scripts' directory.
+
+Four modes are defined: report, patch, context, and org. The mode to
+use is specified by setting the MODE variable with 'MODE=<mode>'.
+
+'report' generates a list in the following format:
+  file:line:column-column: message
+
+'patch' proposes a fix, when possible.
+
+'context' highlights lines of interest and their context in a
+diff-like style.Lines of interest are indicated with '-'.
+
+'org' generates a report in the Org mode format of Emacs.
+
+Note that not all semantic patches implement all modes.
+
+To make a report for every semantic patch, run the following command:
+
+	make coccicheck MODE=report
+
+NB: The 'report' mode is the default one.
+
+To produce patches, run:
+
+	make coccicheck MODE=patch
+
+
+The coccicheck target applies every semantic patch available in the
+subdirectories of 'scripts/coccinelle' to the entire Linux kernel.
+
+For each semantic patch, a changelog message is proposed.  It gives a
+description of the problem being checked by the semantic patch, and
+includes a reference to Coccinelle.
+
+As any static code analyzer, Coccinelle produces false
+positives. Thus, reports must be carefully checked, and patches
+reviewed.
+
+
+ Using Coccinelle with a single semantic patch
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The optional make variable COCCI can be used to check a single
+semantic patch. In that case, the variable must be initialized with
+the name of the semantic patch to apply.
+
+For instance:
+
+	make coccicheck COCCI=<my_SP.cocci> MODE=patch
+or
+	make coccicheck COCCI=<my_SP.cocci> MODE=report
+
+
+ Proposing new semantic patches
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+New semantic patches can be proposed and submitted by kernel
+developers. For sake of clarity, they should be organized in the
+subdirectories of 'scripts/coccinelle/'.
+
+
+ Detailed description of the 'report' mode
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+'report' generates a list in the following format:
+  file:line:column-column: message
+
+Example:
+
+Running
+
+	make coccicheck MODE=report COCCI=scripts/coccinelle/err_cast.cocci
+
+will execute the following part of the SmPL script.
+
+<smpl>
+@r depends on !context && !patch && (org || report)@
+expression x;
+position p;
+@@
+
+ ERR_PTR@p(PTR_ERR(x))
+
+@script:python depends on report@
+p << r.p;
+x << r.x;
+@@
+
+msg="ERR_CAST can be used with %s" % (x)
+coccilib.report.print_report(p[0], msg)
+</smpl>
+
+This SmPL excerpt generates entries on the standard output, as
+illustrated below:
+
+/home/user/linux/crypto/ctr.c:188:9-16: ERR_CAST can be used with alg
+/home/user/linux/crypto/authenc.c:619:9-16: ERR_CAST can be used with auth
+/home/user/linux/crypto/xts.c:227:9-16: ERR_CAST can be used with alg
+
+
+ Detailed description of the 'patch' mode
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+When the 'patch' mode is available, it proposes a fix for each problem
+identified.
+
+Example:
+
+Running
+	make coccicheck MODE=patch COCCI=scripts/coccinelle/err_cast.cocci
+
+will execute the following part of the SmPL script.
+
+<smpl>
+@ depends on !context && patch && !org && !report @
+expression x;
+@@
+
+- ERR_PTR(PTR_ERR(x))
++ ERR_CAST(x)
+</smpl>
+
+This SmPL excerpt generates patch hunks on the standard output, as
+illustrated below:
+
+diff -u -p a/crypto/ctr.c b/crypto/ctr.c
+--- a/crypto/ctr.c 2010-05-26 10:49:38.000000000 +0200
++++ b/crypto/ctr.c 2010-06-03 23:44:49.000000000 +0200
+@@ -185,7 +185,7 @@ static struct crypto_instance *crypto_ct
+ 	alg = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_CIPHER,
+ 				  CRYPTO_ALG_TYPE_MASK);
+ 	if (IS_ERR(alg))
+-		return ERR_PTR(PTR_ERR(alg));
++		return ERR_CAST(alg);
+ 
+ 	/* Block size must be >= 4 bytes. */
+ 	err = -EINVAL;
+
+ Detailed description of the 'context' mode
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+'context' highlights lines of interest and their context
+in a diff-like style.
+
+NOTE: The diff-like output generated is NOT an applicable patch. The
+      intent of the 'context' mode is to highlight the important lines
+      (annotated with minus, '-') and gives some surrounding context
+      lines around. This output can be used with the diff mode of
+      Emacs to review the code.
+
+Example:
+
+Running
+	make coccicheck MODE=context COCCI=scripts/coccinelle/err_cast.cocci
+
+will execute the following part of the SmPL script.
+
+<smpl>
+@ depends on context && !patch && !org && !report@
+expression x;
+@@
+
+* ERR_PTR(PTR_ERR(x))
+</smpl>
+
+This SmPL excerpt generates diff hunks on the standard output, as
+illustrated below:
+
+diff -u -p /home/user/linux/crypto/ctr.c /tmp/nothing
+--- /home/user/linux/crypto/ctr.c	2010-05-26 10:49:38.000000000 +0200
++++ /tmp/nothing
+@@ -185,7 +185,6 @@ static struct crypto_instance *crypto_ct
+ 	alg = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_CIPHER,
+ 				  CRYPTO_ALG_TYPE_MASK);
+ 	if (IS_ERR(alg))
+-		return ERR_PTR(PTR_ERR(alg));
+ 
+ 	/* Block size must be >= 4 bytes. */
+ 	err = -EINVAL;
+
+ Detailed description of the 'org' mode
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+'org' generates a report in the Org mode format of Emacs.
+
+Example:
+
+Running
+	make coccicheck MODE=org COCCI=scripts/coccinelle/err_cast.cocci
+
+will execute the following part of the SmPL script.
+
+<smpl>
+@r depends on !context && !patch && (org || report)@
+expression x;
+position p;
+@@
+
+ ERR_PTR@p(PTR_ERR(x))
+
+@script:python depends on org@
+p << r.p;
+x << r.x;
+@@
+
+msg="ERR_CAST can be used with %s" % (x)
+msg_safe=msg.replace("[","@(").replace("]",")")
+coccilib.org.print_todo(p[0], msg_safe)
+</smpl>
+
+This SmPL excerpt generates Org entries on the standard output, as
+illustrated below:
+
+* TODO [[view:/home/user/linux/crypto/ctr.c::face=ovl-face1::linb=188::colb=9::cole=16][ERR_CAST can be used with alg]]
+* TODO [[view:/home/user/linux/crypto/authenc.c::face=ovl-face1::linb=619::colb=9::cole=16][ERR_CAST can be used with auth]]
+* TODO [[view:/home/user/linux/crypto/xts.c::face=ovl-face1::linb=227::colb=9::cole=16][ERR_CAST can be used with alg]]
-- 
1.7.0.4

