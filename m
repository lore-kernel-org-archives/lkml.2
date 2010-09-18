Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0IRTP2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:28 -0400
Received: from kroah.org ([198.145.64.141]:43543 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab0IRTP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:26 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:02 2010
Message-Id: <20100918191302.922124155@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>
Subject: [065/129] sysfs: checking for NULL instead of ERR_PTR
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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


