Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab2EBPrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:47:43 -0400
Received: from flusers.ccur.com ([173.221.59.2]:37888 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753595Ab2EBPrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:47:21 -0400
X-Greylist: delayed 2191 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2012 11:47:20 EDT
Date: Wed, 2 May 2012 11:10:46 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: joe.korty@ccur.com, linux-kernel@vger.kernel.org
Subject: checkpatch: forward declarations fix
Message-ID: <20120502151046.GA25583@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow forward declarations of the form:

	struct file_operations;

to exist without requiring the preceeding 'const'. In
any case C does not allow 'const' on forward declarations.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: linux/scripts/checkpatch.pl
===================================================================
--- linux.orig/scripts/checkpatch.pl	2012-05-02 10:29:03.000000000 -0400
+++ linux/scripts/checkpatch.pl	2012-05-02 10:38:45.000000000 -0400
@@ -3411,9 +3411,11 @@
 				wd_ops}x;
 		if ($line !~ /\bconst\b/ &&
 		    $line =~ /\bstruct\s+($struct_ops)\b/) {
-			WARN("CONST_STRUCT",
-			     "struct $1 should normally be const\n" .
-				$herecurr);
+			if ($line !~ /struct\s+($struct_ops);/) {
+				WARN("CONST_STRUCT",
+				     "struct $1 should normally be const\n" .
+					$herecurr);
+			}
 		}
 
 # use of NR_CPUS is usually wrong
