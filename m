Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab2B2Ttg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:49:36 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab2B2Ttf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:49:35 -0500
From: Richard Weinberger <richard@nod.at>
To: joe@perches.com
Cc: akpm@linux-foundation.org, Ian.Campbell@citrix.com, florian@mickler.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] get_maintainer.pl: Add support for moderated lists
Date: Wed, 29 Feb 2012 20:49:22 +0100
Message-Id: <1330544962-995-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently get_maintainer.pl reports moderated lists as open,
which is just wrong.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 scripts/get_maintainer.pl |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index f32a04c..b9bcfb6 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -1027,8 +1027,13 @@ sub add_categories {
 		    if ($email_list) {
 			if (!$hash_list_to{lc($list_address)}) {
 			    $hash_list_to{lc($list_address)} = 1;
-			    push(@list_to, [$list_address,
-					    "open list${list_role}"]);
+			    if ($list_additional =~ m/moderated/) {
+				push(@list_to, [$list_address,
+						"moderated list${list_role}"]);
+			    } else {
+				push(@list_to, [$list_address,
+						"open list${list_role}"]);
+			    }
 			}
 		    }
 		}
-- 
1.7.7.3

