Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1K1Pom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:44:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54195 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1K1Pm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:42:59 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 08/11] checkpatch: fix 'return is not a function' square bracket handling
Date: Mon, 28 Nov 2011 15:42:50 +0000
Message-Id: <1322494973-29225-9-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322494973-29225-1-git-send-email-apw@canonical.com>
References: <1322494973-29225-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are incorrectly matching square brackets '[' and ']' leading to false
positives on more complex functions as below:

    return (dt3155_fbuffer[m]->ready_head -
	dt3155_fbuffer[m]->ready_len +
	dt3155_fbuffer[m]->nbuffers)%
	(dt3155_fbuffer[m]->nbuffers);

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4d1069a..52507f6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2605,7 +2605,7 @@ sub process {
 			# Flatten any parentheses
 			$value =~ s/\(/ \(/g;
 			$value =~ s/\)/\) /g;
-			while ($value =~ s/\[[^\{\}]*\]/1/ ||
+			while ($value =~ s/\[[^\[\]]*\]/1/ ||
 			       $value !~ /(?:$Ident|-?$Constant)\s*
 					     $Compare\s*
 					     (?:$Ident|-?$Constant)/x &&
-- 
1.7.5.4

