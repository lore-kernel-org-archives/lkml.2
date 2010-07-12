Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab0GLGjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 02:39:07 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57850 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab0GLGf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 02:35:58 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V16 10/12] vfs: Export file system uuid via /proc/<pid>mountinfo
Date: Mon, 12 Jul 2010 12:05:43 +0530
Message-Id: <1278916545-19751-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.rc1
In-Reply-To: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We add a per superblock uuid field. File systems should
update the uuid in the fill_super callback

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namespace.c     |    3 +++
 include/linux/fs.h |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 88058de..5dbdbd6 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -871,6 +871,9 @@ static int show_mountinfo(struct seq_file *m, void *v)
 	if (IS_MNT_UNBINDABLE(mnt))
 		seq_puts(m, " unbindable");
 
+	/* print the uuid */
+	seq_printf(m, " uuid:%pU", mnt->mnt_sb->s_uuid);
+
 	/* Filesystem specific data */
 	seq_puts(m, " - ");
 	show_type(m, sb);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3103c39..5f43472 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1367,6 +1367,7 @@ struct super_block {
 	wait_queue_head_t	s_wait_unfrozen;
 
 	char s_id[32];				/* Informational name */
+	u8 s_uuid[16];				/* UUID */
 
 	void 			*s_fs_info;	/* Filesystem private info */
 	fmode_t			s_mode;
-- 
1.7.2.rc1

