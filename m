Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab0I0MUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:20:55 -0400
Received: from proxy.dresearch.de ([87.193.137.100]:54387 "EHLO
	mail.dresearch.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756702Ab0I0MUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:20:54 -0400
From: Steffen Sledz <sledz@dresearch.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, Artem Bityutskiy <dedekind1@gmail.com>,
        Steffen Sledz <sledz@dresearch.de>
Subject: [PATCH v2] ubifs: avoid kernel error if ubifs superblock read fails
Date: Mon, 27 Sep 2010 14:20:26 +0200
Message-Id: <1285590026-11629-1-git-send-email-sledz@dresearch.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285577837.16181.14.camel@localhost>
References: <1285577837.16181.14.camel@localhost>
X-OriginalArrivalTime: 27 Sep 2010 12:20:53.0425 (UTC) FILETIME=[6DDB1A10:01CB5E3E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* .get_sb is called on mounts with automatic fs detection too, so this
  function should print an error if it cannot read the superblock in
  debug mode only
  (new behaviour conforms the other fs types)

Signed-off-by: Steffen Sledz <sledz@dresearch.de>
---
 fs/ubifs/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 4e5bf3f..bb6ed5d 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2054,8 +2054,8 @@ static int ubifs_get_sb(struct file_system_type *fs_type, int flags,
 	 */
 	ubi = open_ubi(name, UBI_READONLY);
 	if (IS_ERR(ubi)) {
-		ubifs_err("cannot open \"%s\", error %d",
-			  name, (int)PTR_ERR(ubi));
+		dbg_err("cannot open \"%s\", error %d",
+			name, (int)PTR_ERR(ubi));
 		return PTR_ERR(ubi);
 	}
 	ubi_get_volume_info(ubi, &vi);
-- 
1.7.1

