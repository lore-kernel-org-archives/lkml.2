Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab2BJWm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:42:27 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab2BJWmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:22 -0500
MIME-Version: 1.0
Message-Id: <20120210222949.660791768@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Hutchings <ben@decadent.org.uk>,
        Nick Bowler <nbowler@elliptictech.com>, Dave Jones <davej@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [patch 52/86] lockdep, bug: Exclude TAINT_OOT_MODULE from disabling lock debugging
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 9ec84acee1e221d99dc33237bff5e82839d10cc0 upstream.

We do want to allow lock debugging for GPL-compatible modules
that are not (yet) built in-tree.  This was disabled as a
side-effect of commit 2449b8ba0745327c5fa49a8d9acffe03b2eded69
('module,bug: Add TAINT_OOT_MODULE flag for modules not built
in-tree').  Lock debug warnings now include taint flags, so
kernel developers should still be able to deflect warnings
caused by out-of-tree modules.

The TAINT_PROPRIETARY_MODULE flag for non-GPL-compatible modules
will still disable lock debugging.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Nick Bowler <nbowler@elliptictech.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Debian kernel maintainers <debian-kernel@lists.debian.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/1323268258.18450.11.camel@deadeye
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/panic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -237,11 +237,12 @@ void add_taint(unsigned flag)
 	 * Can't trust the integrity of the kernel anymore.
 	 * We don't call directly debug_locks_off() because the issue
 	 * is not necessarily serious enough to set oops_in_progress to 1
-	 * Also we want to keep up lockdep for staging development and
-	 * post-warning case.
+	 * Also we want to keep up lockdep for staging/out-of-tree
+	 * development and post-warning case.
 	 */
 	switch (flag) {
 	case TAINT_CRAP:
+	case TAINT_OOT_MODULE:
 	case TAINT_WARN:
 	case TAINT_FIRMWARE_WORKAROUND:
 		break;


