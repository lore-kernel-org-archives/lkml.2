Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab1DYUeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:34:17 -0400
Received: from 1wt.eu ([62.212.114.60]:34547 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab1DYUZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:20 -0400
Message-Id: <20110425200238.944820428@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Peter Huewe <huewe.external@infineon.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 137/173] char/tpm: Fix unitialized usage of data buffer
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Huewe <huewe.external.infineon@googlemail.com>

commit 1309d7afbed112f0e8e90be9af975550caa0076b upstream.

This patch fixes information leakage to the userspace by initializing
the data buffer to zero.

Reported-by: Peter Huewe <huewe.external@infineon.com>
Signed-off-by: Peter Huewe <huewe.external@infineon.com>
Signed-off-by: Marcel Selhorst <m.selhorst@sirrix.com>
[ Also removed the silly "* sizeof(u8)".  If that isn't 1, we have way
  deeper problems than a simple multiplication can fix.   - Linus ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -969,7 +969,7 @@ int tpm_open(struct inode *inode, struct
 		return -EBUSY;
 	}
 
-	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
+	chip->data_buffer = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
 	if (chip->data_buffer == NULL) {
 		clear_bit(0, &chip->is_open);
 		put_device(chip->dev);


