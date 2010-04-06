Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0DFKpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 06:45:54 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:45355 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab0DFKps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:45:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=YnBVxVMvIAFNQ+1Gd8eOJetwFEw2frH3+jnQ79HzUn5YcAnH69u+TFM0YXwEXo4Uvs
         YkBhfyrPmAQhUffOfvlT5IirwYBFfmNMl8W0R0xS7FzR7P1DfIexpdY2DuXfS3Yoiqtz
         oeo8DetzYU63PuBIQfcYoF05PhQ6prToq+Cuc=
Date: Tue, 6 Apr 2010 13:45:39 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, Matt Mackall <mpm@selenic.com>,
       David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] proc: copy_to_user() returns unsigned
Message-ID: <20100406104539.GC21229@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Minchan Kim <minchan.kim@gmail.com>, Matt Mackall <mpm@selenic.com>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() returns the number of bytes left to be copied.

This was a typo from: d82ef020cf31504c816803b1def94eb5ff173363
"proc: pagemap: Hold mmap_sem during page walk".

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 0962739..bfb2773 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -799,7 +799,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 		start_vaddr = end;
 
 		len = min(count, PM_ENTRY_BYTES * pm.pos);
-		if (copy_to_user(buf, pm.buffer, len) < 0) {
+		if (copy_to_user(buf, pm.buffer, len)) {
 			ret = -EFAULT;
 			goto out_free;
 		}
