Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab2CAMof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:44:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50822 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759204Ab2CAMoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:44:32 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 5/5] checkpatch: add [] to type extensions
Date: Thu,  1 Mar 2012 12:44:10 +0000
Message-Id: <1330605850-7873-6-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330605850-7873-1-git-send-email-apw@canonical.com>
References: <1330605850-7873-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add [] to a type extensions.  Fixes false positives on:

    .attrs = (struct attribute *[]) {

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 610036e..2bfe013 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -323,7 +323,7 @@ sub build_types {
 		  }x;
 	$Type	= qr{
 			$NonptrType
-			(?:[\s\*]+\s*const|[\s\*]+|(?:\s*\[\s*\])+)?
+			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*|\[\])+|(?:\s*\[\s*\])+)?
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
 	$Declare	= qr{(?:$Storage\s+)?$Type};
-- 
1.7.9

