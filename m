Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab0CTCcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 22:32:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52751 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab0CTCcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 22:32:20 -0400
Date: Sat, 20 Mar 2010 03:32:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, apw@canonical.com
Subject: [PATCH] checkpatch: Add check for too short Kconfig descriptions
Message-ID: <20100320023216.GA917@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Andi Kleen <ak@linux.intel.com>
Date:   Sat Mar 20 00:26:42 2010 +0100

    checkpatch: Add check for too short Kconfig descriptions
    
    I've seen various new Kconfigs with rather unhelpful one liner
    descriptions. Add a Kconfig warning for a minimum length of the
    Kconfig help section.

    Right now I arbitarily chose 4. The exact value can be debated.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a4d7434..d1d36e9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1382,6 +1382,21 @@ sub process {
 			ERROR("trailing whitespace\n" . $herevet);
 		}
 
+# check for Kconfig help text having a real description
+		if ($realfile =~ /Kconfig/ && 
+		    $line =~ /\+?\s*(---)?help(---)?$/) {
+			my $length = 0;
+			for (my $l = $linenr; defined($lines[$l]); $l++) { 
+				my $f = $lines[$l];
+				$f =~ s/#.*//; 
+				$f =~ s/^\s+//;
+				next if ($f =~ /^$/);
+				last if ($f =~ /^\s*config\s/); 
+				$length++;
+			}
+			WARN("please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($length < 4);
+		}
+
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
