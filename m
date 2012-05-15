Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965705Ab2EOCbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:31:47 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53543 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964896Ab2EOCSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 157/179] USB: assign instead of equal in usbtmc.c
Date: Mon, 14 May 2012 22:14:13 -0400
Message-ID: <1337048075-6132-158-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Nikulin <m.a.nikulin@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4f1a7a3e78037721496283ea3e87cfefc64d99c7 upstream.

Assign operator instead of equality test in the usbtmc_ioctl_abort_bulk_in() function.

Signed-off-by: Maxim A. Nikulin <M.A.Nikulin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/class/usbtmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 3e7c1b8..cdce915 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -268,7 +268,7 @@ usbtmc_abort_bulk_in_status:
 				dev_err(dev, "usb_bulk_msg returned %d\n", rv);
 				goto exit;
 			}
-		} while ((actual = max_size) &&
+		} while ((actual == max_size) &&
 			 (n < USBTMC_MAX_READS_TO_CLEAR_BULK_IN));
 
 	if (actual == max_size) {
-- 
1.7.9.6

