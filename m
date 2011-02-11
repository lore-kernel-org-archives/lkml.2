Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab1BKOjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:39:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115Ab1BKOjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:39:40 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tty,vt: fix VT_SETACTIVATE console switch 
Date: Fri, 11 Feb 2011 15:39:28 +0100
Message-Id: <1297435168-4498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

using VT_SETACTIVATE ioctl for console switch did not work,
since it put wrong param to the set_console function.

Also ioctl returned misleading error, because of the missing
break statement. I wonder anyone has ever used this one :).

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 drivers/tty/vt/vt_ioctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 1235ebd..6f05dc4 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -1007,8 +1007,9 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 			if (ret)
 				break;
 			/* Commence switch and lock */
-			set_console(arg);
+			set_console(vsa.console);
 		}
+		break;
 	}
 
 	/*
-- 
1.7.1
