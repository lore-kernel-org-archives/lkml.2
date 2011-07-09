Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1GIQVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 12:21:15 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49887 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1GIQVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 12:21:14 -0400
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: viro@zeniv.linux.org.uk, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: move bdi_setup_and_register outside of CONFIG_CIFS_DFS_UPCALL
Date: Sat,  9 Jul 2011 12:21:07 -0400
Message-Id: <1310228467-27466-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This needs to be done regardless of whether that KConfig option is set
or not.

Reported-by: Sven-Haegar Koch <haegar@sdinet.de>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index fea9ecf..dd695c5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3011,6 +3011,7 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 	struct tcon_link *tlink;
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	int referral_walks_count = 0;
+#endif
 
 	rc = bdi_setup_and_register(&cifs_sb->bdi, "cifs", BDI_CAP_MAP_COPY);
 	if (rc)
@@ -3018,6 +3019,7 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 
 	cifs_sb->bdi.ra_pages = default_backing_dev_info.ra_pages;
 
+#ifdef CONFIG_CIFS_DFS_UPCALL
 try_mount_again:
 	/* cleanup activities if we're chasing a referral */
 	if (referral_walks_count) {
-- 
1.7.6

