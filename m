Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809Ab2JWUFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:05:44 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46251 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964793Ab2JWUFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:41 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 001/193] make CONFIG_EXPERIMENTAL invisible and default
Date: Tue, 23 Oct 2012 13:01:14 -0700
Message-Id: <1351022666-6960-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default (especially in distro builds). As agreed
during the Linux kernel summit, it should be removed. As a first step,
remove it from being listed, and default it to on. Once it has been
removed from all subsystem Kconfigs, it will be dropped entirely.

For items that really are experimental, maintainers should use "default
n", optionally include "(EXPERIMENTAL)" in the title, and add language to
the help text indicating why the item should be considered experimental.

For items that are dangerously experimental, the maintainer is encouraged
to follow the above title recommendation, add stronger language to the
help text, and optionally use (depending on the extent of the danger,
from least to most dangerous): printk(), add_taint(TAINT_WARN),
add_taint(TAINT_CRAP), WARN_ON(1), and CONFIG_BROKEN.

CC: Greg KH <gregkh@linuxfoundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Serge Hallyn <serge.hallyn@canonical.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 init/Kconfig |   31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 6fdd6e3..2bf7b83 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -33,35 +33,8 @@ config BUILDTIME_EXTABLE_SORT
 menu "General setup"
 
 config EXPERIMENTAL
-	bool "Prompt for development and/or incomplete code/drivers"
-	---help---
-	  Some of the various things that Linux supports (such as network
-	  drivers, file systems, network protocols, etc.) can be in a state
-	  of development where the functionality, stability, or the level of
-	  testing is not yet high enough for general use. This is usually
-	  known as the "alpha-test" phase among developers. If a feature is
-	  currently in alpha-test, then the developers usually discourage
-	  uninformed widespread use of this feature by the general public to
-	  avoid "Why doesn't this work?" type mail messages. However, active
-	  testing and use of these systems is welcomed. Just be aware that it
-	  may not meet the normal level of reliability or it may fail to work
-	  in some special cases. Detailed bug reports from people familiar
-	  with the kernel internals are usually welcomed by the developers
-	  (before submitting bug reports, please read the documents
-	  <file:README>, <file:MAINTAINERS>, <file:REPORTING-BUGS>,
-	  <file:Documentation/BUG-HUNTING>, and
-	  <file:Documentation/oops-tracing.txt> in the kernel source).
-
-	  This option will also make obsoleted drivers available. These are
-	  drivers that have been replaced by something else, and/or are
-	  scheduled to be removed in a future kernel release.
-
-	  Unless you intend to help test and develop a feature or driver that
-	  falls into this category, or you have a situation that requires
-	  using these features, you should probably say N here, which will
-	  cause the configurator to present you with fewer choices. If
-	  you say Y here, you will be offered the choice of using features or
-	  drivers that are currently considered to be in the alpha-test phase.
+	bool
+	default y
 
 config BROKEN
 	bool
-- 
1.7.9.5

