Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab0F1Qld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 12:41:33 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:44250 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab0F1Qlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 12:41:31 -0400
Subject: [PATCH] fs: make sure do_change_type() gets a valid type.
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Organization: Freebox
Date: Mon, 28 Jun 2010 18:41:22 +0200
Message-ID: <1277743282.31267.112.camel@sakura.staff.proxad.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,


Busybox mount does not support --make-shared, and -o shared is used
instead. This has the side effect that MS_SILENT can be passed too, and
that prevents do_change_type() from working.

This patch fixes this by computing type using only relevant bits.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
---
 fs/namespace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index f20cb57..5360463 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1456,7 +1456,7 @@ static int do_change_type(struct path *path, int flag)
 {
 	struct vfsmount *m, *mnt = path->mnt;
 	int recurse = flag & MS_REC;
-	int type = flag & ~MS_REC;
+	int type = flag & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE);
 	int err = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
-- 
1.7.1



-- 
Maxime


