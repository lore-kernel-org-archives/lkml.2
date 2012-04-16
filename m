Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2DPQO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:14:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab2DPQOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:14:21 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dchinner@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jaya Kumar <jayalk@intworks.biz>
Subject: [PATCH 01/27] fb_defio: Push file_update_time() into fb_deferred_io_mkwrite()
Date: Mon, 16 Apr 2012 18:13:39 +0200
Message-Id: <1334592845-22862-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1334592845-22862-1-git-send-email-jack@suse.cz>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Jaya Kumar <jayalk@intworks.biz>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/video/fb_defio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
index c27e153..7a09c06 100644
--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -104,6 +104,8 @@ static int fb_deferred_io_mkwrite(struct vm_area_struct *vma,
 	deferred framebuffer IO. then if userspace touches a page
 	again, we repeat the same scheme */
 
+	file_update_time(vma->vm_file);
+
 	/* protect against the workqueue changing the page list */
 	mutex_lock(&fbdefio->lock);
 
-- 
1.7.1

