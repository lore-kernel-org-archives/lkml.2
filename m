Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2KAHND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 03:13:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49171 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753562Ab2KAHNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 03:13:01 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 3/3] checkpatch: Emit an warning when floating point values are used
Date: Thu,  1 Nov 2012 00:12:18 -0700
Message-Id: <359a78054bc0dfaedede95222781b4177d3c33ce.1351736873.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351736873.git.joe@perches.com>
References: <cover.1351736873.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux kernel doesn't like floating point, say so.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c3a2162..96685c6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2332,6 +2332,13 @@ sub process {
 			     "do not add new typedefs\n" . $herecurr);
 		}
 
+# check for floating point constants
+
+		if ($line =~ /\b$Float\b/) {
+			WARN("KERNEL_FLOAT",
+			     "Floating point is not supported in linux kernel source\n" . $herecurr);
+		}
+
 # * goes on variable not on type
 		# (char*[ const])
 		while ($line =~ m{(\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\))}g) {
-- 
1.7.8.112.g3fd21

