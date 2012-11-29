Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2K2VEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:04:04 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:42477 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755191Ab2K2VEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:04:02 -0500
Message-ID: <1354223042.1700.3.camel@joe-AO722>
Subject: [PATCH] checkpatch: Warn when declaring "struct spinlock foo;"
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2012 13:04:02 -0800
In-Reply-To: <1354221910-22493-2-git-send-email-mcgrof@do-not-panic.com>
References: <1354221910-22493-1-git-send-email-mcgrof@do-not-panic.com>
	 <1354221910-22493-2-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spinlock_t should always be used.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e0a674f..f27b0b5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3336,6 +3336,12 @@ sub process {
 			     "Avoid line continuations in quoted strings\n" . $herecurr);
 		}
 
+# check for struct spinlock declarations
+		if ($line =~ /^.\s*\bstruct\s+spinlock\s+\w+\s*;/) {
+			WARN("USE_SPINLOCK_T",
+			     "struct spinlock should be spinlock_t\n" . $herecurr);
+		}
+
 # Check for misused memsets
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&


