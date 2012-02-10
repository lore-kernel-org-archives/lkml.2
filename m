Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979Ab2BJWoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:44:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736Ab2BJWol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:44:41 -0500
MIME-Version: 1.0
Message-Id: <20120210223441.219445978@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>
Subject: [patch 10/55] proc: mem_release() should check mm != NULL
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 71879d3cb3dd8f2dfdefb252775c1b3ea04a3dd4 upstream.

mem_release() can hit mm == NULL, add the necessary check.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -886,8 +886,8 @@ loff_t mem_lseek(struct file *file, loff
 static int mem_release(struct inode *inode, struct file *file)
 {
 	struct mm_struct *mm = file->private_data;
-
-	mmput(mm);
+	if (mm)
+		mmput(mm);
 	return 0;
 }
 


