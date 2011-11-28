Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1K1Pn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:43:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54202 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab1K1Pm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:42:59 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 11/11] checkpatch: typeof may have more complex arguments
Date: Mon, 28 Nov 2011 15:42:53 +0000
Message-Id: <1322494973-29225-12-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322494973-29225-1-git-send-email-apw@canonical.com>
References: <1322494973-29225-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

typeof may have various more complex forms as its arguement, not just an
identifier.  For now allow us to leak to the first close perenthesis ')'.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 1c341be..fb20de4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -315,7 +315,7 @@ sub build_types {
 	$NonptrType	= qr{
 			(?:$Modifier\s+|const\s+)*
 			(?:
-				(?:typeof|__typeof__)\s*\(\s*\**\s*$Ident\s*\)|
+				(?:typeof|__typeof__)\s*\([^\)]*\)|
 				(?:$typeTypedefs\b)|
 				(?:${all}\b)
 			)
-- 
1.7.5.4

