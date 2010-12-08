Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0LHQcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:32:46 -0500
Received: from smtp.nokia.com ([147.243.1.48]:61675 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab0LHQco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:32:44 -0500
From: Aaro Koskinen <aaro.koskinen@nokia.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ext-phil.2.carmody@nokia.com
Subject: [PATCH] ext4: fix typo in ext4_find_entry()
Date: Wed,  8 Dec 2010 18:33:22 +0200
Message-Id: <1291826002-24989-1-git-send-email-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be a check for NUL character instead of '0'.

Reported-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
---
 fs/ext4/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 92203b8..dc40e75 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -872,7 +872,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 	if (namelen > EXT4_NAME_LEN)
 		return NULL;
 	if ((namelen <= 2) && (name[0] == '.') &&
-	    (name[1] == '.' || name[1] == '0')) {
+	    (name[1] == '.' || name[1] == '\0')) {
 		/*
 		 * "." or ".." will only be in the first block
 		 * NFS may look up ".."; "." should be handled by the VFS
-- 
1.5.6.5

