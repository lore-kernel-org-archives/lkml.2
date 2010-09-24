Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab0IXKOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 06:14:22 -0400
Received: from proxy.DResearch.DE ([87.193.137.100]:49504 "EHLO
	mail.dresearch.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751781Ab0IXKOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 06:14:21 -0400
X-Greylist: delayed 1160 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Sep 2010 06:14:21 EDT
From: Steffen Sledz <sledz@dresearch.de>
To: linux-kernel@vger.kernel.org
Cc: Steffen Sledz <sledz@dresearch.de>
Subject: [PATCH] ubifs: avoid kernel error if ubifs superblock read fails
Date: Fri, 24 Sep 2010 11:54:41 +0200
Message-Id: <1285322081-17144-1-git-send-email-sledz@dresearch.de>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 24 Sep 2010 09:54:58.0033 (UTC) FILETIME=[8BFF0E10:01CB5BCE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* .get_sb is called on mounts with automatic fs detection too, so this
  function should not print an error if it cannot read the superblock
  (new behaviour conforms the other fs types)

Signed-off-by: Steffen Sledz <sledz@dresearch.de>
---
 fs/ubifs/super.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index cd5900b..e62bb75 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2049,8 +2049,6 @@ static int ubifs_get_sb(struct file_system_type *fs_type, int flags,
 	 */
 	ubi = open_ubi(name, UBI_READONLY);
 	if (IS_ERR(ubi)) {
-		ubifs_err("cannot open \"%s\", error %d",
-			  name, (int)PTR_ERR(ubi));
 		return PTR_ERR(ubi);
 	}
 	ubi_get_volume_info(ubi, &vi);
-- 
1.7.1

