Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2CXKK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 06:10:27 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47940 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2CXKK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 06:10:26 -0400
MIME-Version: 1.0
Date: Sat, 24 Mar 2012 15:40:25 +0530
Message-ID: <CAB4K4y5S-X8rCWZaB5ZJeAZupoKajMsKyVw7eMFnAP1v7V5dVw@mail.gmail.com>
Subject: [PATCH] vfs: fix uninitialised iattr in do_truncate
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] vfs: fix uninitialised iattr in do_truncate

struct newattrs is uninitialised.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
---
 fs/open.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 77becc0..2676efa 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -37,7 +37,7 @@ int do_truncate(struct dentry *dentry, loff_t
length, unsigned int time_attrs,
 	struct file *filp)
 {
 	int ret;
-	struct iattr newattrs;
+	struct iattr newattrs = {0};

 	/* Not pretty: "inode->i_size" shouldn't really be signed. But it is. */
 	if (length < 0)
-- 
1.7.8.4
