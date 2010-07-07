Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab0GGVkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:40:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab0GGVko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
       Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net
Subject: [PATCH 11/18] oprofile: make event buffer nonseekable
Date: Wed,  7 Jul 2010 23:40:13 +0200
Message-Id: <1278538820-1392-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:uxEAk+Z06marheXvBjIjdg8oDOrgMoMl1NNvjhVrS5a
 wTdP0htAZU2UWGrrP7Ku15bSy1sQGBP33szgnfHKkkQtwFZgOz
 9DpgWokQ4Xmuo9pV8a7xOrvmN+mt33oiMO0AjsVPLJdofw5AZc
 rEnDLSIYNSJxOnwuzL10cAsziDqlIl+mEGuAo7x87l6HOqFRwW
 7PDu3bpZmQu6nqTCK0JGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The event buffer cannot deal with seeks, so
we should forbid that outright.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Robert Richter <robert.richter@amd.com>
Cc: oprofile-list@lists.sf.net
---
 drivers/oprofile/event_buffer.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/oprofile/event_buffer.c b/drivers/oprofile/event_buffer.c
index 5df60a6..dd87e86 100644
--- a/drivers/oprofile/event_buffer.c
+++ b/drivers/oprofile/event_buffer.c
@@ -135,7 +135,7 @@ static int event_buffer_open(struct inode *inode, struct file *file)
 	 * echo 1 >/dev/oprofile/enable
 	 */
 
-	return 0;
+	return nonseekable_open(inode, file);
 
 fail:
 	dcookie_unregister(file->private_data);
@@ -205,4 +205,5 @@ const struct file_operations event_buffer_fops = {
 	.open		= event_buffer_open,
 	.release	= event_buffer_release,
 	.read		= event_buffer_read,
+	.llseek		= no_llseek,
 };
-- 
1.7.1

