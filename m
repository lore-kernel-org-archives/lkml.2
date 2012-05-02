Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2EBPrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:47:23 -0400
Received: from flusers.ccur.com ([173.221.59.2]:37888 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754831Ab2EBPrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:47:21 -0400
X-Greylist: delayed 2191 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2012 11:47:20 EDT
Date: Wed, 2 May 2012 11:10:46 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: joe.korty@ccur.com, linux-kernel@vger.kernel.org
Subject: checkpatch: kstrtol fix
Message-ID: <20120502151046.GA25594@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kstrtol is a substitute for simple_strtol() only when when second
arg of simple_strtol() is NULL. For any other value the functionality
of simple_strtol() cannot be implemented in terms of kstrtol.

So modify checkpatch.pl so that it prints out the following warning only
if the second argument is null:

   WARNING: simple_strtol is obsolete, use kstrtol instead

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: linux/scripts/checkpatch.pl
===================================================================
--- linux.orig/scripts/checkpatch.pl	2012-05-02 10:38:45.000000000 -0400
+++ linux/scripts/checkpatch.pl	2012-05-02 10:47:58.000000000 -0400
@@ -3359,8 +3359,8 @@
 			     "consider using a completion\n" . $herecurr);
 		}
 
-# recommend kstrto* over simple_strto* and strict_strto*
-		if ($line =~ /\b((simple|strict)_(strto(l|ll|ul|ull)))\s*\(/) {
+# recommend kstrto* over simple_strto* and strict_strto* where appropriate
+		if ($line =~ /\b((simple|strict)_(strto(l|ll|ul|ull)))\s*\([^,]+,\s*NULL\s*,/) {
 			WARN("CONSIDER_KSTRTO",
 			     "$1 is obsolete, use k$3 instead\n" . $herecurr);
 		}
