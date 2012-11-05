Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638Ab2KEXc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:32:27 -0500
Received: from smtp.outflux.net ([198.145.64.163]:44982 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab2KEXFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:14 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 001/104] checkpatch: warn about using CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:18 -0800
Message-Id: <1352156701-4038-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, it is being removed.  This will discourage future addition of
CONFIG_EXPERIMENTAL while it is being phased out.

Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 21a9f5d..f8b33ed 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1757,6 +1757,13 @@ sub process {
 			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
+# Discourage the addition of CONFIG_EXPERIMENTAL in Kconfig.
+		if ($realfile =~ /Kconfig/ &&
+		    $line =~ /.\s*depends on\s+.*\bEXPERIMENTAL\b/) {
+			WARN("CONFIG_EXPERIMENTAL",
+			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see:\nhttps://lkml.org/lkml/2012/10/23/580\n");
+		}
+
 		if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
 		    ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
 			my $flag = $1;
-- 
1.7.9.5

