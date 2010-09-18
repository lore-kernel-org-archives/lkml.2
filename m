Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab0IRTCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:34 -0400
Received: from kroah.org ([198.145.64.141]:51274 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab0IRTBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:32 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:55 2010
Message-Id: <20100918185955.903677173@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>
Subject: [036/123] sysfs: checking for NULL instead of ERR_PTR
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sysfs-checking-for-null-instead-of-err_ptr.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

commit 57f9bdac2510cd7fda58e4a111d250861eb1ebeb upstream.

d_path() returns an ERR_PTR and it doesn't return NULL.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/sysfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -340,7 +340,7 @@ static int sysfs_open_file(struct inode
 	char *p;
 
 	p = d_path(&file->f_path, last_sysfs_file, sizeof(last_sysfs_file));
-	if (p)
+	if (!IS_ERR(p))
 		memmove(last_sysfs_file, p, strlen(p) + 1);
 
 	/* need attr_sd for attr and ops, its parent for kobj */


