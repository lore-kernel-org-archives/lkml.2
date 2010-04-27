Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0D0JSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:18:46 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:52542 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab0D0JSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=QSB0ugiS6bl4WhLZKeBZpwl0fzDxVVTqueC5usXXx9vzN2QZB8sbECv7eAA1wmQO7d
         8CZ0rDhlvfOElDi9SN1n3d3/ilf/EjNO+3iMcdNnftGEHScRs2WBQ2/OJmpDSm9+6ygb
         xIiRsziqtNs/PXOdhGqBPxBRbjrvlaBY6zTF4=
From: John Kacur <jkacur@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 04/10] bkl: Fix missing inode tw_chrdev_ioctl due to bkl pushdown
Date: Tue, 27 Apr 2010 11:18:12 +0200
Message-Id: <1272359898-32020-5-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/scsi/3w-xxxx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 45a737c..2957691 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -890,6 +890,7 @@ static long tw_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long a
 	unsigned long data_buffer_length_adjusted = 0;
 	unsigned long *cpu_addr;
 	long timeout;
+	struct inode *inode = file->f_dentry->d_inode;
 	TW_New_Ioctl *tw_ioctl;
 	TW_Passthru *passthru;
 	TW_Device_Extension *tw_dev = tw_device_extension_list[iminor(inode)];
-- 
1.6.6.1

