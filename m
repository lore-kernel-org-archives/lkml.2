Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab1DZVe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:34:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:58780 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698Ab1DZVN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738831670"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: huewe.external.infineon@googlemail.com, huewe.external@infineon.com,
        m.selhorst@sirrix.com, ak@linux.intel.com,
        torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [29/106] char/tpm: Fix unitialized usage of data buffer
Message-Id: <20110426211308.462513E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Peter Huewe <huewe.external.infineon@googlemail.com>

commit 1309d7afbed112f0e8e90be9af975550caa0076b upstream.

This patch fixes information leakage to the userspace by initializing
the data buffer to zero.

Reported-by: Peter Huewe <huewe.external@infineon.com>
Signed-off-by: Peter Huewe <huewe.external@infineon.com>
Signed-off-by: Marcel Selhorst <m.selhorst@sirrix.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[ Also removed the silly "* sizeof(u8)".  If that isn't 1, we have way
  deeper problems than a simple multiplication can fix.   - Linus ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.35.y.orig/drivers/char/tpm/tpm.c
+++ linux-2.6.35.y/drivers/char/tpm/tpm.c
@@ -970,7 +970,7 @@ int tpm_open(struct inode *inode, struct
 		return -EBUSY;
 	}
 
-	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
+	chip->data_buffer = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
 	if (chip->data_buffer == NULL) {
 		clear_bit(0, &chip->is_open);
 		put_device(chip->dev);
