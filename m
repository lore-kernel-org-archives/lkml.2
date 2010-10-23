Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab0JWIZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 04:25:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40149 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab0JWIZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 04:25:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IzHNFbn8wqEG1isBzfakRjxv0+ZSpVXBWM3eaZrhq/vfDWevGaB4shP/qJtiHihjgt
         yHy7mHkc5KDLU6Oq0OR4i3MOsicAtfAU+QDH3BDX0ADxAnhMfeFkJcTIl877gOJO+T6z
         OfEHgQIWoHk05Fscqd8WVgM+WPdrMyXsKwfkU=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Chirag Kantharia <chirag.kantharia@hp.com>,
        Jens Axboe <jaxboe@fusionio.com>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] block: cpqarray: fix information leak to userland
Date: Sat, 23 Oct 2010 12:25:15 +0400
Message-Id: <1287822316-14826-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure ida_pci_info_struct is copied to userland with some padding
fields unitialized.  It leads to leaking of stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 drivers/block/cpqarray.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 946dad4..8e0e6b4 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -1198,6 +1198,7 @@ out_passthru:
 		ida_pci_info_struct pciinfo;
 
 		if (!arg) return -EINVAL;
+		memset(&pciinfo, 0, sizeof(pciinfo));
 		pciinfo.bus = host->pci_dev->bus->number;
 		pciinfo.dev_fn = host->pci_dev->devfn;
 		pciinfo.board_id = host->board_id;
-- 
1.7.0.4

