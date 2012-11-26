Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab2KZREL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:04:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47350 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab2KZREG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:04:06 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, NeilBrown <neilb@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 069/270] md/raid10: use correct limit variable
Date: Mon, 26 Nov 2012 14:55:59 -0200
Message-Id: <1353949160-26803-70-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 91502f099dfc5a1e8812898e26ee280713e1d002 upstream.

Clang complains that we are assigning a variable to itself.  This should
be using bad_sectors like the similar earlier check does.

Bug has been present since 3.1-rc1.  It is minor but could
conceivably cause corruption or other bad behaviour.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e987da4..17fae37 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3139,7 +3139,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				else {
 					bad_sectors -= (sector - first_bad);
 					if (max_sync > bad_sectors)
-						max_sync = max_sync;
+						max_sync = bad_sectors;
 					continue;
 				}
 			}
-- 
1.7.9.5

