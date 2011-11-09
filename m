Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965939Ab1KJDrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:47:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965910Ab1KJDrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:47:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:05 2011
Message-Id: <20111109213205.457905551@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mike Miller <mike.miller@hp.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [228/264] hpsa: add small delay when using PCI Power Management to reset for kump
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Miller <mike.miller@hp.com>

commit c4853efec665134b2e6fc9c13447323240980351 upstream.

The P600 requires a small delay when changing states. Otherwise we may think
the board did not reset and we bail. This for kdump only and is particular
to the P600.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/hpsa.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3300,6 +3300,13 @@ static int hpsa_controller_hard_reset(st
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


