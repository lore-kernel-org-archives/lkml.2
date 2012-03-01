Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030717Ab2CALmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 06:42:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966111Ab2CALl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 06:41:56 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        dchinner@redhat.com, Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 8/9] sysfs: Push file_update_time() into bin_page_mkwrite()
Date: Thu,  1 Mar 2012 12:41:42 +0100
Message-Id: <1330602103-8851-9-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330602103-8851-1-git-send-email-jack@suse.cz>
References: <1330602103-8851-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/sysfs/bin.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index a475983..614b2b5 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -228,6 +228,8 @@ static int bin_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	ret = 0;
 	if (bb->vm_ops->page_mkwrite)
 		ret = bb->vm_ops->page_mkwrite(vma, vmf);
+	else
+		file_update_time(file);
 
 	sysfs_put_active(attr_sd);
 	return ret;
-- 
1.7.1

