Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab1DMQNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:13:17 -0400
Received: from kroah.org ([198.145.64.141]:52901 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867Ab1DMQNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:46 2011
Message-Id: <20110413161046.716993870@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:10:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Huewe <huewe.external@infineon.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>
Subject: [40/71] char/tpm: Fix unitialized usage of data buffer
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -955,7 +955,7 @@ int tpm_open(struct inode *inode, struct
 		return -EBUSY;
 	}
 
-	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
+	chip->data_buffer = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
 	if (chip->data_buffer == NULL) {
 		clear_bit(0, &chip->is_open);
 		put_device(chip->dev);


