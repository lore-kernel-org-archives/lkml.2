Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab1GKKge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 06:36:34 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:54307 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab1GKKgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 06:36:32 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jul 2011 06:36:32 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0EAG7OGk5bdWOb/2dsb2JhbABThESjbIh8rSaQMoErhACBDwSSVJBJ
X-IronPort-AV: E=Sophos;i="4.65,515,1304287200"; 
   d="scan'208";a="858983187"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        "Jianbin Kang" <kjbmail@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>
Subject: [PATCH] kbuild: incremental tags updating with GNU GLOBAL
Date: Mon, 11 Jul 2011 12:26:30 +0200
Message-Id: <1310379990-4367-1-git-send-email-vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of generating the tag database each time the target is ran, is better
just update incrementally the database. It will expend less time.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 scripts/tags.sh |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 75c5d24..6a2fedc 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -116,7 +116,11 @@ docscope()
 
 dogtags()
 {
-	all_sources | gtags -f -
+	if global -p; then
+		global -u
+	else
+		all_sources | gtags -f -
+	fi
 }
 
 exuberant()
-- 
1.7.5.4

