Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab0IXMs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:48:58 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:35750 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab0IXMsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:48:55 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de, adilger@sun.com,
        sandeen@redhat.com, tytso@mit.edu, bfields@citi.umich.edu,
        jlayton@redhat.com
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
        nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -V4 07/11] vfs: Make acl_permission_check() work for richacls
Date: Fri, 24 Sep 2010 18:18:10 +0530
Message-Id: <1285332494-12756-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 855b360..b0b8a71 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -174,6 +174,12 @@ static int acl_permission_check(struct inode *inode, int mask,
 {
 	umode_t			mode = inode->i_mode;
 
+	if (IS_RICHACL(inode)) {
+		int error = check_acl(inode, mask);
+		if (error != -EAGAIN)
+			return error;
+	}
+
 	if (current_fsuid() == inode->i_uid)
 		mode >>= 6;
 	else {
-- 
1.7.0.4

