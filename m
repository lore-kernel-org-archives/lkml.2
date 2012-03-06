Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab2CFCBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 21:01:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:42797 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758200Ab2CFCBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 21:01:22 -0500
Message-ID: <1330999280.10358.3.camel@joe2Laptop>
Subject: [RFC PATCH] checkpatch: Warn on use of yield()
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Miao Xie <miaox@cn.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 05 Mar 2012 18:01:20 -0800
In-Reply-To: <20120305121804.3b4daed4.akpm@linux-foundation.org>
References: <20120302112358.GA3481@suse.de>
	 <1330723262.11248.233.camel@twins>
	 <20120305121804.3b4daed4.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of yield() is deprecated or at least generally undesirable.

Add a checkpatch warning when it's used.
Suggest cpu_relax instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
> Joe, can we please have a checkpatch rule?

Something like this?

 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e32ea7f..80ad474 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3300,6 +3300,11 @@ sub process {
 			     "__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
 		}
 
+# check for use of yield()
+		if ($line =~ /\byield\s*\(\s*\)/ {
+			WARN("YIELD",
+			     "yield() is deprecated, consider cpu_relax()\n"  . $herecurr);
+		}
 # check for semaphores initialized locked
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("CONSIDER_COMPLETION",


