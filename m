Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab2JBTu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 15:50:58 -0400
Received: from smtp.outflux.net ([198.145.64.163]:35336 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab2JBTu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 15:50:57 -0400
Date: Tue, 2 Oct 2012 12:50:42 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121002195042.GA16087@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, it should be removed. As a first step, remove it from being
listed, and default it to on. Once it has been removed from all
subsystem Kconfigs, it will be dropped entirely.

CC: Greg KH <gregkh@linuxfoundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Serge Hallyn <serge.hallyn@canonical.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---

This is the first of a series of 202 patches removing EXPERIMENTAL from
all the Kconfigs in the tree. Should I send them all to lkml (with all
the associated CCs), or do people want to cherry-pick changes from my
tree? I don't want to needlessly flood the list.

http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/experimental

I figure this patch can stand alone to at least make EXPERIMENTAL go
away from the menus, and give us a taste of what the removal would do
to builds.

Thanks,

-Kees

---
 init/Kconfig |   31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index cb003a3..f6f8146 100644
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


-- 
Kees Cook
Chrome OS Security
