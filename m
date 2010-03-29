Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab0C2UWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:22:23 -0400
Received: from havoc.gtf.org ([69.61.125.42]:51796 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab0C2UWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:22:22 -0400
Date: Mon, 29 Mar 2010 16:22:20 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] libata fix
Message-ID: <20100329202220.GA14437@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/pata_via.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

JosephChan@via.com.tw (1):
      pata_via: fix VT6410/6415/6330 detection issue

diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 95d39c3..c59b407 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -576,6 +576,10 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			u8 rev = isa->revision;
 			pci_dev_put(isa);
 
+			if ((id->device == 0x0415 || id->device == 0x3164) &&
+			    (config->id != id->device))
+				continue;
+
 			if (rev >= config->rev_min && rev <= config->rev_max)
 				break;
 		}
