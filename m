Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935329Ab1KJDbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:31:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935307Ab1KJDb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:31:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:21 2011
Message-Id: <20111109212721.603387901@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jens Axboe <axboe@kernel.dk>
Subject: [209/262] cciss: add small delay when using PCI Power Management to reset for kump
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Miller <mike.miller@hp.com>

commit ab5dbebe33e0c353e8545f09c34553ac3351dad6 upstream.

The P600 requires a small delay when changing states. Otherwise we may think
the board did not reset and we bail. This for kdump only and is particular
to the P600.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/cciss.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4533,6 +4533,13 @@ static int cciss_controller_hard_reset(s
 		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
 		pmcsr |= PCI_D0;
 		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
+
+		/*
+		 * The P600 requires a small delay when changing states.
+		 * Otherwise we may think the board did not reset and we bail.
+		 * This for kdump only and is particular to the P600.
+		 */
+		msleep(500);
 	}
 	return 0;
 }


