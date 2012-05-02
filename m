Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab2EBPrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:47:21 -0400
Received: from flusers.ccur.com ([173.221.59.2]:37888 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752806Ab2EBPrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:47:20 -0400
X-Greylist: delayed 2191 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2012 11:47:20 EDT
Date: Wed, 2 May 2012 11:10:46 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: joe.korty@ccur.com, linux-kernel@vger.kernel.org
Subject: checkpatch: brackets around single statements fix
Message-ID: <20120502151046.GA25573@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch thinks '#else' is the same as 'else' in its check for
this error:

   WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: linux/scripts/checkpatch.pl
===================================================================
--- linux.orig/scripts/checkpatch.pl	2012-04-17 05:00:37.000000000 -0400
+++ linux/scripts/checkpatch.pl	2012-05-02 10:29:03.000000000 -0400
@@ -3038,7 +3038,7 @@
 			}
 		}
 		if (!defined $suppress_ifbraces{$linenr - 1} &&
-					$line =~ /\b(if|while|for|else)\b/) {
+					$line =~ /[^#]\b(if|while|for|else)\b/) {
 			my $allowed = 0;
 
 			# Check the pre-context.
