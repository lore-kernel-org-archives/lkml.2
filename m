Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0D0JSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:18:50 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:52542 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab0D0JSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=LCwiSufRGvmvckdnYZEX4a7QidNgEvCDDEdjMtAVfdkrgFzI+qwz3H0vO5QFsVMH9d
         f2DTTUP//igbX2syjrwRLIALsrriMoMP7SI/erzJtvEDxapyJVDi9n2y1qvlZgIwA7dS
         S0WTr/Rgp3ktNAhkZ+l5notUEUGt+cefsce3I=
From: John Kacur <jkacur@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 05/10] bkl: Fix missing inode in twl_chrdev_ioctl resulting from bkl pushdown
Date: Tue, 27 Apr 2010 11:18:13 +0200
Message-Id: <1272359898-32020-6-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix missing inode in twl_chrdev_ioctl resulting from bkl pushdown, because
the ioctl is now an unlocked ioctl.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/scsi/3w-sas.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index ab4ad09..216af13 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -756,6 +756,7 @@ static long twl_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	unsigned long *cpu_addr, data_buffer_length_adjusted = 0, flags = 0;
 	dma_addr_t dma_handle;
 	int request_id = 0;
+	struct inode *inode = file->f_dentry->d_inode;
 	TW_Ioctl_Driver_Command driver_command;
 	TW_Ioctl_Buf_Apache *tw_ioctl;
 	TW_Command_Full *full_command_packet;
-- 
1.6.6.1

