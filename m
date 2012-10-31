Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab2JaKOC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:14:02 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35142 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932992Ab2JaKN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:13:56 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] checkpatch: Emit a warning when decimal values are used
Date: Wed, 31 Oct 2012 03:13:13 -0700
Message-Id: <497a03b1726dda76e0fd49d5ea8d3514da2d0128.1351578285.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351578285.git.joe@perches.com>
References: <cover.1351578285.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux kernel doesn't like decimals, say so.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3e727c5..3339ecf 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2329,6 +2329,13 @@ sub process {
 			     "do not add new typedefs\n" . $herecurr);
 		}
 
+# check for decimal constants
+
+		if ($line =~ /\b$Decimal\b/) {
+			WARN("KERNEL_DECIMAL",
+			     "Decimal values are not supported in linux kernel source\n" . $herecurr);
+		}
+
 # * goes on variable not on type
 		# (char*[ const])
 		while ($line =~ m{(\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\))}g) {
-- 
1.7.8.112.g3fd21

