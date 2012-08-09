Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab2HJAnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 20:43:09 -0400
Received: from sous-sol.org ([216.99.217.87]:58966 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab2HJAnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 20:43:05 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Aug 2012 20:43:05 EDT
Date: Thu, 9 Aug 2012 15:40:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] debugfs: make __create_file static
Message-ID: <20120809224039.GD17203@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's only used locally, no need to pollute global namespace.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/debugfs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 4733eab..2c9fafb 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -291,9 +291,9 @@ static struct file_system_type debug_fs_type = {
 	.kill_sb =	kill_litter_super,
 };
 
-struct dentry *__create_file(const char *name, umode_t mode,
-				   struct dentry *parent, void *data,
-				   const struct file_operations *fops)
+static struct dentry *__create_file(const char *name, umode_t mode,
+				    struct dentry *parent, void *data,
+				    const struct file_operations *fops)
 {
 	struct dentry *dentry = NULL;
 	int error;

