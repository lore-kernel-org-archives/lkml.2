Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab1CQEwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 00:52:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1CQEwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 00:52:16 -0400
Date: Thu, 17 Mar 2011 00:52:09 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: make checkpatch warn about memset with swapped arguments.
Message-ID: <20110317045209.GA18656@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the second and third arguments of memset have the same type,
it turns out to be really easy to mix them up.

This bug comes up time after time, so checkpatch should really
be checking for it at patch submission time.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 58848e3..421b3e69 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2902,6 +2902,11 @@ sub process {
 		    $line =~ /DEVICE_ATTR.*S_IWUGO/ ) {
 			WARN("Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
+
+		# Check for memset with swapped arguments
+		if ($line =~ /memset.*\,(\ |)(0x|)0(\ |0|)\);/) {
+			ERROR("memset size is 3rd argument, not the second.\n" . $herecurr);
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
