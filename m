Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab2EAQmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:42:24 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:45725 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab2EAQmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:42:20 -0400
Subject: [PATCH 03/17] hpsa: enable bus master bit after pci_enable_device
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Date: Tue, 01 May 2012 11:42:20 -0500
Message-ID: <20120501164220.11705.95002.stgit@beardog.cce.hp.com>
In-Reply-To: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

pci_disable_device() disables the bus master bit and pci_enable_device does
not re-enable it.  It needs to be enabled.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5119ce6..de9c8f3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3933,6 +3933,9 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 		return err;
 	}
 
+	/* Enable bus mastering (pci_disable_device may disable this) */
+	pci_set_master(h->pdev);
+
 	err = pci_request_regions(h->pdev, HPSA);
 	if (err) {
 		dev_err(&h->pdev->dev,

