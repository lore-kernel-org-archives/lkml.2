Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab2CHP4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:56:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:44804 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757854Ab2CHP4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:56:07 -0500
Message-ID: <1331222161.30848.1.camel@joe2Laptop>
Subject: [PATCH 1/2 V2] checkpatch: Warn on use of yield()
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 08 Mar 2012 07:56:01 -0800
In-Reply-To: <1331057839.2140.12.camel@joe2Laptop>
References: <1331057839.2140.12.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using yield() is generally wrong.  Warn on its use.

Signed-off-by: Joe Perches <joe@perches.com>
---

V2: Test checkpatches first next time...
    Add missing close parenthesis

 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 04eb9eb..135cb8f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3344,6 +3344,12 @@ sub process {
 			     "__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
 		}
 
+# check for use of yield()
+		if ($line =~ /\byield\s*\(\s*\)/) {
+			WARN("YIELD",
+			     "Using yield() is generally wrong. See yield() kernel-doc (sched/core.c)\n"  . $herecurr);
+		}
+
 # check for semaphores initialized locked
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("CONSIDER_COMPLETION",


