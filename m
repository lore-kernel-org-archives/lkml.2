Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab2DJNGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:06:42 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39980 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab2DJNGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:06:42 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH RESEND] sep: Fix sign of error return
To: greg@kroah.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Tue, 10 Apr 2012 14:21:24 +0100
Message-ID: <20120410132054.28262.82704.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

One of our errors wasn't negative as intended. Fix this.
(Found by Hillf Danton)

While we are at it turn user causable messages down to dev_dbg level in the
ioctl paths.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable@kernel.org
---

 drivers/staging/sep/sep_main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index ad54c2e..f1701bc 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -3114,7 +3114,7 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			current->pid);
 		if (1 == test_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
 				  &call_status->status)) {
-			dev_warn(&sep->pdev->dev,
+			dev_dbg(&sep->pdev->dev,
 				"[PID%d] dcb prep needed before send msg\n",
 				current->pid);
 			error = -EPROTO;
@@ -3122,9 +3122,9 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		}
 
 		if (!arg) {
-			dev_warn(&sep->pdev->dev,
+			dev_dbg(&sep->pdev->dev,
 				"[PID%d] dcb null arg\n", current->pid);
-			error = EINVAL;
+			error = -EINVAL;
 			goto end_function;
 		}
 

