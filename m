Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab0LIUHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:07:49 -0500
Received: from mail.perches.com ([173.55.12.10]:2400 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065Ab0LIUEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:04:14 -0500
From: Joe Perches <joe@perches.com>
To: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>
Cc: Jiri Kosina <trivial@kernel.org>, osd-dev@open-osd.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/15] exofs: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:04:02 -0800
Message-Id: <0bf308cd31a750c6608a0c3c492b1f7e59852c78.1291923889.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
References: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <cover.1291923888.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS_ERR already uses unlikely, remove unlikely from the call sites.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/exofs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 79c3ae6..b2b12a8 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -488,7 +488,7 @@ static int exofs_read_lookup_dev_table(struct exofs_sb_info **psbi,
 		}
 
 		od = osduld_info_lookup(&odi);
-		if (unlikely(IS_ERR(od))) {
+		if (IS_ERR(od)) {
 			ret = PTR_ERR(od);
 			EXOFS_ERR("ERROR: device requested is not found "
 				  "osd_name-%s =>%d\n", odi.osdname, ret);
-- 
1.7.3.3.464.gf80b6

