Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab1A2TJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 14:09:40 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46792 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab1A2TJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 14:09:37 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V26 16/16] vfs: enable "" pathname in openat syscall
Date: Sun, 30 Jan 2011 00:38:19 +0530
Message-Id: <1296328099-23263-17-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enable the below usage

fd = openat(dir_fd, "", O_RDONLY);

dir_fd can be O_PATH descriptor. It does all access check as per the
open flags.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/open.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 328a76e..bccb12d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -893,7 +893,7 @@ EXPORT_SYMBOL(fd_install);
 
 long do_sys_open(int dfd, const char __user *filename, int flags, int mode)
 {
-	char *tmp = getname(filename);
+	char *tmp = getname_null(filename);
 	int fd = PTR_ERR(tmp);
 
 	if (!IS_ERR(tmp)) {
-- 
1.7.1

