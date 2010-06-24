Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0FXOQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:16:37 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47457 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab0FXOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RtHaJmunvY/Gs3pENDAxzzyL39X9d8/oi5Q1CgftKBcPmLqWmNPv+cOQ6vnSHEQ93Q
         swUVNpMjJ3m1l3vtriyHvkWgd0zRRQG2hMU3Jhf/gJIKTXK4iigrCtHIrGwxlVcasoAs
         cGbDw7N3sdUnHNrMDISK+FTh4s5f15/s06Qcs=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, James Simmons <jsimmons@infradead.org>,
       linux-fbdev@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH] video: simplify strlen()==0 check in fb_get_options()
Date: Thu, 24 Jun 2010 18:16:26 +0200
Message-Id: <1277396186-11921-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced !strlen(str) check with !str[0]. Removed the variable
which was used solely to store strlen result.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 drivers/video/fbmem.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 731fce6..a8500c6 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1786,7 +1786,7 @@ static int ofonly __read_mostly;
 int fb_get_options(char *name, char **option)
 {
 	char *opt, *options = NULL;
-	int opt_len, retval = 0;
+	int retval = 0;
 	int name_len = strlen(name), i;
 
 	if (name_len && ofonly && strncmp(name, "offb", 4))
@@ -1796,8 +1796,7 @@ int fb_get_options(char *name, char **option)
 		for (i = 0; i < FB_MAX; i++) {
 			if (video_options[i] == NULL)
 				continue;
-			opt_len = strlen(video_options[i]);
-			if (!opt_len)
+			if (!video_options[i][0])
 				continue;
 			opt = video_options[i];
 			if (!strncmp(name, opt, name_len) &&
-- 
1.6.2.5

