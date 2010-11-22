Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab0KVRyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 12:54:24 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:51834 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754645Ab0KVRyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 12:54:21 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+Ps5kg5naP++l+G7uVPuNr79WrNM70HYSgZGMvoQ
	Q65qAcI6VnZYtV
Date: Mon, 22 Nov 2010 18:52:29 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fanotify: dont destroy mark when ignore mask is cleared
Message-ID: <20101122175229.GC5512@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In mark_remove_from_mask() the mark is destroyed regardless of whether the
event mask or ignore mask is cleared. We should only destroy the mark if the
event mask is cleared.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Please apply this after patch "Dont allow a mask of 0 if setting or removing a
mark" which i sent today.

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 207cdeb..c9143a0 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -518,7 +518,7 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 	}
 	spin_unlock(&fsn_mark->lock);
 
-	if (!(oldmask & ~mask))
+	if (!(flags & FAN_MARK_IGNORED_MASK) && !(oldmask & ~mask))
 		fsnotify_destroy_mark(fsn_mark);
 
 	return mask & oldmask;
-- 
1.5.6.5

