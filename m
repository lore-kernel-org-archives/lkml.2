Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2DNJs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:48:57 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59024 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab2DNJs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:48:56 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Ian Kent <raven@themaw.net>
Cc: kernel-janitors@vger.kernel.org, autofs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs/autofs4/dev-ioctl.c: add missing free_dev_ioctl
Date: Sat, 14 Apr 2012 11:48:48 +0200
Message-Id: <1334396928-17537-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Free param as done in the other error-handling code.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/autofs4/dev-ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 9dacb85..f99c2ce 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -651,7 +651,8 @@ static int _autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __use
 	fn = lookup_dev_ioctl(cmd);
 	if (!fn) {
 		AUTOFS_WARN("unknown command 0x%08x", command);
-		return -ENOTTY;
+		err = -ENOTTY;
+		goto out;
 	}
 
 	fp = NULL;

