Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab1I3TmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 15:42:10 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42628 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab1I3TmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 15:42:09 -0400
Date: Fri, 30 Sep 2011 14:42:03 -0500
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>, thenzl@redhat.com
Subject: [Patch 1/1] cciss: add half second delay to PCI PM reset code
Message-ID: <20110930194203.GB6898@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cciss: need to delay after a PCI Power Management reset

After using PCI Power Management to reset the Smart Array in kdump kernels
we need some delay. Otherwise we may think the board failed to reset and
bail out.
This affects all users with a Smart Array P600. 

From: Mike Miller <mike.miller@hp.com>
Signed-off-by: Mike Miller <mike.miller@hp.com>

---
 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 664c669..1c656db 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4441,13 +4441,13 @@ static int cciss_controller_hard_reset(struct pci_dev *pdev,
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
