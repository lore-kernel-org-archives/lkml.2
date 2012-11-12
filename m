Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab2KLXQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:16:31 -0500
Received: from smtp.outflux.net ([198.145.64.163]:43416 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab2KLXQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:16:29 -0500
Date: Mon, 12 Nov 2012 15:16:24 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Subject: [PATCH v4] checkpatch: warn about using CONFIG_EXPERIMENTAL
Message-ID: <20121112231624.GA28460@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, it is being removed.  This will discourage future addition of
CONFIG_EXPERIMENTAL while it is being phased out.

Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Kees Cook <keescook@chromium.org>

---
v4:
 - unfix long lines, requested by Joe Perches.
v3:
 - add #if(def) checking, suggested by Joe Perches.
 - fix long lines.
v2:
 - improve warning string with URL to alternatives.
---
 scripts/checkpatch.pl |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f18750e..01c4e26 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1757,6 +1757,13 @@ sub process {
 			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
+# discourage the addition of CONFIG_EXPERIMENTAL in Kconfig.
+		if ($realfile =~ /Kconfig/ &&
+		    $line =~ /.\s*depends on\s+.*\bEXPERIMENTAL\b/) {
+			WARN("CONFIG_EXPERIMENTAL",
+			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
+		}
+
 		if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
 		    ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
 			my $flag = $1;
@@ -1912,6 +1919,12 @@ sub process {
 # check we are in a valid C source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c)$/);
 
+# discourage the addition of CONFIG_EXPERIMENTAL in #if(def).
+		if ($line =~ /^\+\s*\#\s*if.*\bCONFIG_EXPERIMENTAL\b/) {
+			WARN("CONFIG_EXPERIMENTAL",
+			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
+		}
+
 # check for RCS/CVS revision markers
 		if ($rawline =~ /^\+.*\$(Revision|Log|Id)(?:\$|)/) {
 			WARN("CVS_KEYWORD",
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
