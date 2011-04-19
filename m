Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1DSUiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:38:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15783 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab1DSUiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:38:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=L1zYSWtqV55UVAabCK/kPi4DYF4gVu7jDmiFSpTw8hjm9EKDuJELthjjPCCHjUwxJ
	/Evs9zDpLnRYklyR1KP4g==
From: Mike Waychison <mikew@google.com>
To: Peter Jones <pjones@redhat.com>, Paul Mundt <lethal@linux-sh.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Waychison <mikew@google.com>
Subject: [PATCH] efifb: Fix "cast to pointer from integer of different size"
Date: Tue, 19 Apr 2011 13:38:03 -0700
Message-Id: <1303245483-2799-1-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix set_system() to not cause a cast warning when printing a u32 as a
pointer:

drivers/video/efifb.c: In function 'set_system':
drivers/video/efifb.c:247: error: cast to pointer from integer of
different size

Allow the integer to print as a pointer by first casting to unsigned
long which we know will be the width of a pointer and at least as wide
as u32.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/video/efifb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 4eb38db..59e9f06 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -244,8 +244,9 @@ static int set_system(const struct dmi_system_id *id)
 
 	printk(KERN_INFO "efifb: dmi detected %s - framebuffer at %p "
 			 "(%dx%d, stride %d)\n", id->ident,
-			 (void *)screen_info.lfb_base, screen_info.lfb_width,
-			 screen_info.lfb_height, screen_info.lfb_linelength);
+			 (void *)(unsigned long)screen_info.lfb_base,
+			 screen_info.lfb_width, screen_info.lfb_height,
+			 screen_info.lfb_linelength);
 
 
 	return 1;
-- 
1.7.3.1

