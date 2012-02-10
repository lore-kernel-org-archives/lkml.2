Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab2BJREL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:04:11 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:52993 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754722Ab2BJREJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:04:09 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: drbd-dev@lists.linbit.com
Cc: Danny Kukawka <dkukawka@suse.de>, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org, Philipp Reisner <phil@linbit.com>,
        Lars Ellenberg <lars@linbit.com>
Subject: [PATCH] drbd: fix -Waddress warning
Date: Fri, 10 Feb 2012 18:03:53 +0100
Message-Id: <1328893433-28017-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328893449;6e2b0c78;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for:
drivers/block/drbd/drbd_main.c: In function ‘drbd_buildtag’:
drivers/block/drbd/drbd_main.c:4187:19: warning: the comparison will
 always evaluate as ‘true’ for the address of ‘__this_module’ will
 never be NULL [-Waddress]

Remove "THIS_MODULE != NULL" check since always true and move else 
block to #else.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/block/drbd/drbd_main.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 211fc44..36a51ac 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -4184,11 +4184,10 @@ const char *drbd_buildtag(void)
 
 	if (buildtag[0] == 0) {
 #ifdef CONFIG_MODULES
-		if (THIS_MODULE != NULL)
-			sprintf(buildtag, "srcversion: %-24s", THIS_MODULE->srcversion);
-		else
+		sprintf(buildtag, "srcversion: %-24s", THIS_MODULE->srcversion);
+#else
+		buildtag[0] = 'b';
 #endif
-			buildtag[0] = 'b';
 	}
 
 	return buildtag;
-- 
1.7.7.3

