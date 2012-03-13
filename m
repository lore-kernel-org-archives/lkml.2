Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab2CMATZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:19:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:46886 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab2CMASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:18:23 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Peter Huewe <huewe.external.infineon@googlemail.com>,
        Peter Huewe <huewe.external@infineon.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 039/196] char/tpm: Fix unitialized usage of data buffer
Date: Mon, 12 Mar 2012 20:12:47 -0400
Message-Id: <1331597724-31358-40-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <huewe.external.infineon@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1309d7afbed112f0e8e90be9af975550caa0076b upstream.

This patch fixes information leakage to the userspace by initializing
the data buffer to zero.

Reported-by: Peter Huewe <huewe.external@infineon.com>
Signed-off-by: Peter Huewe <huewe.external@infineon.com>
Signed-off-by: Marcel Selhorst <m.selhorst@sirrix.com>
[ Also removed the silly "* sizeof(u8)".  If that isn't 1, we have way
  deeper problems than a simple multiplication can fix.   - Linus ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/tpm/tpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 6ab5381..7f95fec 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -956,7 +956,7 @@ int tpm_open(struct inode *inode, struct file *file)
 		return -EBUSY;
 	}
 
-	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
+	chip->data_buffer = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
 	if (chip->data_buffer == NULL) {
 		clear_bit(0, &chip->is_open);
 		put_device(chip->dev);
-- 
1.7.9.3

