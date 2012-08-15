Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab2HOUJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:09:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:37067 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab2HOTwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Peter Wippich <pewi@gw-instruments.de>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 124/165] mtd: mtdchar: add missing initializer on raw write
Date: Wed, 15 Aug 2012 15:47:48 -0400
Message-ID: <1345060109-9187-125-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Wippich <pewi@gw-instruments.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit bf5140817b2d65faac9b32fc9057a097044ac35b upstream.

On writes in MODE_RAW the mtd_oob_ops struct is not sufficiently
initialized which may cause nandwrite to fail. With this patch
it is possible to write raw nand/oob data without additional ECC
(either for testing or when some sectors need different oob layout
e.g. bootloader) like
nandwrite  -n -r -o  /dev/mtd0 <myfile>

Signed-off-by: Peter Wippich <pewi@gw-instruments.de>
Tested-by: Ricard Wanderlof <ricardw@axis.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/mtd/mtdchar.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 5b081cb..726a1b8 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -290,6 +290,7 @@ static ssize_t mtd_write(struct file *file, const char __user *buf, size_t count
 			ops.mode = MTD_OOB_RAW;
 			ops.datbuf = kbuf;
 			ops.oobbuf = NULL;
+			ops.ooboffs = 0;
 			ops.len = len;
 
 			ret = mtd->write_oob(mtd, *ppos, &ops);
-- 
1.7.12.rc2

