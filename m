Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab0ECFb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 01:31:56 -0400
Received: from smtp.nokia.com ([192.100.105.134]:17890 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab0ECFbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 01:31:53 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 1/1] drivers: misc: pass miscdevice pointer via file private data
Date: Mon,  3 May 2010 08:31:33 +0300
Message-Id: <1272864693-27343-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1272864693-27343-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1272864693-27343-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 03 May 2010 05:31:39.0245 (UTC) FILETIME=[E7B351D0:01CAEA81]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For misc devices, inode->i_cdev doesn't point to the device drivers own data.
Link between file operations and device driver internal data is lost.
Pass pointer to misc device struct via file private data for driver open
function use.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/char/misc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 92ab03d..cd650ca 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -144,6 +144,7 @@ static int misc_open(struct inode * inode, struct file * file)
 	old_fops = file->f_op;
 	file->f_op = new_fops;
 	if (file->f_op->open) {
+		file->private_data = c;
 		err=file->f_op->open(inode,file);
 		if (err) {
 			fops_put(file->f_op);
-- 
1.6.0.4

