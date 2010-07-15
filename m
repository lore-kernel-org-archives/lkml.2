Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab0GOCTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758260Ab0GOCR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:17:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/18] xstat: Make automounter filesystems return
	FS_AUTOMOUNT_FL [ver #6]
To: viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        linux-ext4@vger.kernel.org
Date: Thu, 15 Jul 2010 03:17:22 +0100
Message-ID: <20100715021722.5544.803.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make automounter filesystems return FS_AUTOMOUNT_FL in st_inode_flags to
xstat().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/autofs/init.c  |    1 +
 fs/autofs4/init.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/autofs/init.c b/fs/autofs/init.c
index cea5219..2c06d4b 100644
--- a/fs/autofs/init.c
+++ b/fs/autofs/init.c
@@ -23,6 +23,7 @@ static int autofs_get_sb(struct file_system_type *fs_type,
 static struct file_system_type autofs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "autofs",
+	.inode_flags	= FS_AUTOMOUNT_FL,
 	.get_sb		= autofs_get_sb,
 	.kill_sb	= autofs_kill_sb,
 };
diff --git a/fs/autofs4/init.c b/fs/autofs4/init.c
index 9722e4b..43df431 100644
--- a/fs/autofs4/init.c
+++ b/fs/autofs4/init.c
@@ -23,6 +23,7 @@ static int autofs_get_sb(struct file_system_type *fs_type,
 static struct file_system_type autofs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "autofs",
+	.inode_flags	= FS_AUTOMOUNT_FL,
 	.get_sb		= autofs_get_sb,
 	.kill_sb	= autofs4_kill_sb,
 };

