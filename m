Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab0D3SiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:38:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125Ab0D3RVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:45 -0400
Date: Thu, 29 Apr 2010 22:40:56 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: =?ISO-8859-15?Q?=22Fr=E9d=E9ric_Weisbecker=22?= 
	<fweisbec@gmail.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: build failure after merge of the bkl-ioctl tree
In-Reply-To: <20100429154947.fbacee1f.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.1004292239320.8472@localhost.localdomain>
References: <20100429154947.fbacee1f.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-318342147-1272573660=:8472"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-318342147-1272573660=:8472
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Thu, 29 Apr 2010, Stephen Rothwell wrote:

> Hi Frédéric,
> 
> After merging the bkl-ioctl tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/scsi/3w-xxxx.c: In function 'tw_chrdev_ioctl':
> drivers/scsi/3w-xxxx.c:896: error: 'inode' undeclared (first use in this function)
> 
> Caused by commit 5c9af160f830a68734f600fc0f90cba35e26727b ("scsi: Push
> down BKL into ioctl functions").
> 
> I have used the version of the blk-ioctl tree from next-20100428 for
> today.

Frederic: did you miss one of my patches to fix the scsi compile problems?

The following should have fixed the above:

>From 3605ca2d1b29511fe1c95b47c4c596f392797585 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Tue, 27 Apr 2010 10:47:43 +0200
Subject: [PATCH 04/10] bkl: Fix missing inode tw_chrdev_ioctl due to bkl pushdown
Cc: Arnd Bergmann <arnd@arndb.de>,
    Linus Torvalds <torvalds@linux-foundation.org>,
    Frederic Weisbecker <fweisbec@gmail.com>,
    Jan Blunck <jblunck@gmail.com>,
    Thomas Gleixner <tglx@linutronix.de>

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

--8323328-318342147-1272573660=:8472--
