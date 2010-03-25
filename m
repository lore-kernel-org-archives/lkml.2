Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab0CYFT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:19:56 -0400
Received: from mail.perches.com ([173.55.12.10]:1078 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab0CYFRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:17:23 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 01/13] drivers/staging/cx25821: Hoist assign from if
Date: Wed, 24 Mar 2010 22:16:55 -0700
Message-Id: <adf4071bd3682e25aa8592b9e1bb88965d62bec1.1269493047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269493047.git.joe@perches.com>
References: <cover.1269493047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/cx25821/cx25821-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index 67f689d..0548864 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -1298,7 +1298,8 @@ int cx25821_risc_databuffer_audio(struct pci_dev *pci,
 	instructions = 1 + (bpl * lines) / PAGE_SIZE + lines;
 	instructions += 1;
 
-	if ((rc = btcx_riscmem_alloc(pci, risc, instructions * 12)) < 0)
+	rc = btcx_riscmem_alloc(pci, risc, instructions * 12);
+	if (rc < 0)
 		return rc;
 
 	/* write risc instructions */
-- 
1.7.0.14.g7e948

