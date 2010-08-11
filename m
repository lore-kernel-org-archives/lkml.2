Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab0HKX7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:12 -0400
Received: from kroah.org ([198.145.64.141]:43518 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759164Ab0HKX6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:52 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:02 2010
Message-Id: <20100811235502.438275750@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roel Kluin <roel.kluin@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [075/111] Btrfs: make error return negative in btrfs_sync_file()
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit 014e4ac4f7d9c981750491fa40ea35efadc9ed49 upstream.

It appears the error return should be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1133,7 +1133,7 @@ int btrfs_sync_file(struct file *file, s
 	}
 	mutex_lock(&dentry->d_inode->i_mutex);
 out:
-	return ret > 0 ? EIO : ret;
+	return ret > 0 ? -EIO : ret;
 }
 
 static const struct vm_operations_struct btrfs_file_vm_ops = {


