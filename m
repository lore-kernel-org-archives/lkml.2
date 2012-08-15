Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab2HOUW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:22:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:36832 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab2HOTum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Johannes Stezenbach <js@sig21.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 071/165] usbmon vs. tcpdump: fix dropped packet count
Date: Wed, 15 Aug 2012 15:46:55 -0400
Message-ID: <1345060109-9187-72-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Stezenbach <js@sig21.net>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 236c448cb6e7f82096101e1ace4b77f8b38f82c8 upstream.

Report the number of dropped packets instead of zero
when using the binary usbmon interface with tcpdump.

# tcpdump -i usbmon1 -w dump
tcpdump: listening on usbmon1, link-type USB_LINUX_MMAPPED (USB with padded Linux header), capture size 65535 bytes
^C2155 packets captured
2155 packets received by filter
1019 packets dropped by kernel

Signed-off-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/mon/mon_bin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 6ee9d76..45f9705 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1080,7 +1080,7 @@ static int mon_bin_ioctl(struct inode *inode, struct file *file,
 		nevents = mon_bin_queued(rp);
 
 		sp = (struct mon_bin_stats __user *)arg;
-		if (put_user(rp->cnt_lost, &sp->dropped))
+		if (put_user(ndropped, &sp->dropped))
 			return -EFAULT;
 		if (put_user(nevents, &sp->queued))
 			return -EFAULT;
-- 
1.7.12.rc2

