Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab1K1PnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:43:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54181 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab1K1Pm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:42:58 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 03/11] checkpatch: ## is not a valid modifier
Date: Mon, 28 Nov 2011 15:42:45 +0000
Message-Id: <1322494973-29225-4-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322494973-29225-1-git-send-email-apw@canonical.com>
References: <1322494973-29225-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inserting a # into the modifiers list will incorrectly add the null string
to the modifiers list, leading to an infinite loop.  As neither of these
is a valid modifier form simply ignore them.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e07c36a..6dad5dd 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1223,7 +1223,9 @@ sub possible {
 			case|
 			else|
 			asm|__asm__|
-			do
+			do|
+			\#|
+			\#\#|
 		)(?:\s|$)|
 		^(?:typedef|struct|enum)\b
 	    )}x;
-- 
1.7.5.4

