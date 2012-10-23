Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab2JWUAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:00:45 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:49915 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933470Ab2JWT7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:59:24 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 20/23] dvb-core: Replace memcpy with struct assignment
Date: Tue, 23 Oct 2012 16:57:23 -0300
Message-Id: <1351022246-8201-20-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kind of memcpy() is error-prone. Its replacement with a struct
assignment is prefered because it's type-safe and much easier to read.

Found by coccinelle. Hand patched and reviewed.
Tested by compilation only.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier struct_name;
struct struct_name to;
struct struct_name from;
expression E;
@@
-memcpy(&(to), &(from), E);
+to = from;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 7e92793..c770464 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2256,7 +2256,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 				printk("%s switch command: 0x%04lx\n", __func__, swcmd);
 			do_gettimeofday(&nexttime);
 			if (dvb_frontend_debug)
-				memcpy(&tv[0], &nexttime, sizeof(struct timeval));
+				tv[0] = nexttime;
 			/* before sending a command, initialize by sending
 			 * a 32ms 18V to the switch
 			 */
-- 
1.7.4.4

