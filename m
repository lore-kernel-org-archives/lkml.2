Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab1E3N7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:59:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:55623 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1E3N67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:58:59 -0400
From: Michal Marek <mmarek@suse.cz>
To: Jon Masters <jcm@redhat.com>
Cc: linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] depmod: Handle X.Y kernel versions
Date: Mon, 30 May 2011 15:58:43 +0200
Message-Id: <1306763923-11892-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What a stupid check.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---

Jon, could you please apply this patch and release a new
module-init-tools?  Depmod otherwise fails when building a kernel with
version 3.0 (without the third number).

Linus, I'm affraid this ruins the plan for Linux 3.0. Except if you want
to force users to upgrade module-init-tools, with the excuse that 3.0
is a huge step forward and breakage has to be expected ;-).

Michal
---
 depmod.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/depmod.c b/depmod.c
index abfb11e..98a5efa 100644
--- a/depmod.c
+++ b/depmod.c
@@ -247,7 +247,7 @@ static int is_version_number(const char *version)
 {
 	unsigned int dummy;
 
-	return (sscanf(version, "%u.%u.%u", &dummy, &dummy, &dummy) == 3);
+	return (sscanf(version, "%u.%u", &dummy, &dummy) == 2);
 }
 
 static int old_module_version(const char *version)
-- 
1.7.4.1

