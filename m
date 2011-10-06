Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965311Ab1JFVYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 17:24:54 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:13536 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965205Ab1JFVYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 17:24:52 -0400
X-Greylist: delayed 672 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Oct 2011 17:24:52 EDT
Date: Thu, 6 Oct 2011 16:13:38 -0500
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>, tony.camuso@hp.com
Subject: [PATCH 1/1] cciss: 2nd resubmit: add delay into kdump reset 
Message-ID: <20111006211338.GA2640@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PATCH 1 of 1

From: Mike Miller <mike.miller@hp.com>

cciss: add delay back to PCI Power Management reset

When we change states from D0 to D3Hot and back to D0 we need a small delay.
Otherwise we may think the board has failed to reset and we bail. This
change affects the Smart Array P600.

Please ignore the previous patch that did this. I made it against the wrong
code base resulting in an offset. My apologies.

Another submission. I don't see this patch in the mailing list archives. I
only see the first submission which had an offset.

Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8f4ef65..a70c6dd 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4526,13 +4526,13 @@ static int cciss_controller_hard_reset(struct pci_dev *pdev,
 		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
 		pmcsr |= PCI_D3hot;
 		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
-
 		msleep(500);
 
 		/* enter the D0 power management state */
 		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
 		pmcsr |= PCI_D0;
 		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
+		msleep(500);
 	}
 	return 0;
 }
