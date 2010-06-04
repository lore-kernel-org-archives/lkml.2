Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab0FDUsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:48:12 -0400
Received: from kroah.org ([198.145.64.141]:44033 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab0FDUsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:48:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Frank Pan <frankpzh@gmail.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/11] tty: fix a little bug in scrup, vt.c
Date: Fri,  4 Jun 2010 13:47:54 -0700
Message-Id: <1275684477-20172-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100604204445.GB19761@kroah.com>
References: <20100604204445.GB19761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Pan <frankpzh@gmail.com>

The code uses vc->vc_cols instead of vc->vc_size_row by mistake, it
will cause half of the region which is going to clear remain
uncleared.
The issue happens in background consoles, so it's hard to observe.

Frank Pan

Signed-off-by: Frank Pan <frankpzh@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/vt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 7cdb6ee..1296c42 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -304,7 +304,7 @@ static void scrup(struct vc_data *vc, unsigned int t, unsigned int b, int nr)
 	d = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
 	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * (t + nr));
 	scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
-	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_video_erase_char,
+	scr_memsetw(d + (b - t - nr) * vc->vc_size_row, vc->vc_video_erase_char,
 		    vc->vc_size_row * nr);
 }
 
-- 
1.7.1

