Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1FCOyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:54:20 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:46516 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab1FCOyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:54:18 -0400
Subject: [PATCH 1/2] cciss: Use the correct size when mapping in the config
	table
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Fri, 03 Jun 2011 09:54:16 -0500
Message-ID: <20110603145416.17174.60549.stgit@beardog.cce.hp.com>
In-Reply-To: <20110603145313.17174.78662.stgit@beardog.cce.hp.com>
References: <20110603145313.17174.78662.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8f4ef65..f7154a8 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4185,7 +4185,7 @@ static int __devinit cciss_find_cfgtables(ctlr_info_t *h)
 	if (rc)
 		return rc;
 	h->cfgtable = remap_pci_mem(pci_resource_start(h->pdev,
-		cfg_base_addr_index) + cfg_offset, sizeof(h->cfgtable));
+		cfg_base_addr_index) + cfg_offset, sizeof(*h->cfgtable));
 	if (!h->cfgtable)
 		return -ENOMEM;
 	rc = write_driver_ver_to_cfgtable(h->cfgtable);

