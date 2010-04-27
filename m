Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0D0JUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:20:12 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:52542 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab0D0JSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:18:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=uWnxFZ1dnaWFuIfhJiO2/ylYwKXAK2NhyUimmG76n4HcsaO3Oc4Yq5egc6SqlIb4TW
         gqbqtJpOkV1BLSW8a+BlJ6Yy7YYNEFGIU/5gY5simsHaNVw+j5cL+OpxeCXzjzjBMHg/
         WvUEjL2KjcZ9opEzftqmuYSM2cW/rtP1lsugw=
From: John Kacur <jkacur@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 03/10] bkl: Fix up compile problems in megaraid from bkl push-down
Date: Tue, 27 Apr 2010 11:18:11 +0200
Message-Id: <1272359898-32020-4-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Forward declaration missing ';'
- Conflicting declaraction in megaraid.h changed

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/scsi/megaraid.c |    2 +-
 drivers/scsi/megaraid.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index c20b621..0b6e322 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -92,7 +92,7 @@ static struct proc_dir_entry *mega_proc_dir_entry;
 static struct mega_hbas mega_hbas[MAX_CONTROLLERS];
 
 static long
-megadev_unlocked_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+megadev_unlocked_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
 /*
  * The File Operations structure for the serial/ioctl interface of the driver
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index d310f49..b3d2949 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -1013,8 +1013,8 @@ static void mega_8_to_40ld (mraid_inquiry *inquiry,
 		mega_inquiry3 *enquiry3, mega_product_info *);
 
 static int megadev_open (struct inode *, struct file *);
-static int megadev_ioctl (struct inode *, struct file *, unsigned int,
-		unsigned long);
+static int
+megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 static int mega_m_to_n(void __user *, nitioctl_t *);
 static int mega_n_to_m(void __user *, megacmd_t *);
 
-- 
1.6.6.1

