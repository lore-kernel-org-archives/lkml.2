Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1K1PoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:44:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54196 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab1K1Pm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:42:59 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 10/11] checkpatch: ensure cast type is unique in the context parser
Date: Mon, 28 Nov 2011 15:42:52 +0000
Message-Id: <1322494973-29225-11-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322494973-29225-1-git-send-email-apw@canonical.com>
References: <1322494973-29225-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure the cast type is unique in the context parser, we do not want
them to detect as a comma ','.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 71655dc..1c341be 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1031,7 +1031,7 @@ sub annotate_values {
 		} elsif ($cur =~ /^(\(\s*$Type\s*)\)/ && $av_pending eq '_') {
 			print "CAST($1)\n" if ($dbg_values > 1);
 			push(@av_paren_type, $type);
-			$type = 'C';
+			$type = 'c';
 
 		} elsif ($cur =~ /^($Type)\s*(?:$Ident|,|\)|\(|\s*$)/) {
 			print "DECLARE($1)\n" if ($dbg_values > 1);
-- 
1.7.5.4

