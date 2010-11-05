Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0KEDQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:16:09 -0400
Received: from mail.perches.com ([173.55.12.10]:4101 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab0KEDIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:49 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/49] drivers/net/e1000: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:43 -0700
Message-Id: <1627ebbe3c1f4efc0da3be979896f50c38a032b9.1288925424.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/e1000/e1000_main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index 4686c39..dcb7f82 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -1425,13 +1425,12 @@ static int e1000_setup_tx_resources(struct e1000_adapter *adapter,
 	int size;
 
 	size = sizeof(struct e1000_buffer) * txdr->count;
-	txdr->buffer_info = vmalloc(size);
+	txdr->buffer_info = vzalloc(size);
 	if (!txdr->buffer_info) {
 		e_err(probe, "Unable to allocate memory for the Tx descriptor "
 		      "ring\n");
 		return -ENOMEM;
 	}
-	memset(txdr->buffer_info, 0, size);
 
 	/* round up to nearest 4K */
 
@@ -1621,13 +1620,12 @@ static int e1000_setup_rx_resources(struct e1000_adapter *adapter,
 	int size, desc_len;
 
 	size = sizeof(struct e1000_buffer) * rxdr->count;
-	rxdr->buffer_info = vmalloc(size);
+	rxdr->buffer_info = vzalloc(size);
 	if (!rxdr->buffer_info) {
 		e_err(probe, "Unable to allocate memory for the Rx descriptor "
 		      "ring\n");
 		return -ENOMEM;
 	}
-	memset(rxdr->buffer_info, 0, size);
 
 	desc_len = sizeof(struct e1000_rx_desc);
 
-- 
1.7.3.1.g432b3.dirty

