Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761078Ab0J2KID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 06:08:03 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36019 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756616Ab0J2KIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 06:08:01 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18TFkMlKmwT5tItRWiYkP6IZCSae+OMgrKtTqvKaX
	VZkm8ZVuuetZ/S
Date: Fri, 29 Oct 2010 12:06:42 +0200
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] make fanotify_read() restartable across signals
Message-ID: <20101029100642.GD26242@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


    In fanotify_read() return -ERESTARTSYS instead of -EINTR to
    make read() restartable across signals (BSD semantic).
---
This patch applies against commit 3970d817558a426cc2f53eaa01182eb9452e0cb1
of branch 'origin/for-next' from git.infradead.org/users/eparis/notify.git

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 8c9fd35..99a8e60 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -330,7 +330,7 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
 		ret = -EAGAIN;
 		if (file->f_flags & O_NONBLOCK)
 			break;
-		ret = -EINTR;
+		ret = -ERESTARTSYS;
 		if (signal_pending(current))
 			break;
 
