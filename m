Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab0KEDIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:08:55 -0400
Received: from mail.perches.com ([173.55.12.10]:4106 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab0KEDIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:50 -0400
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
Subject: [PATCH 20/49] drivers/net/e1000e: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:44 -0700
Message-Id: <f2fa68e9dc6ba623ed7d54ae49fd20e07bccc780.1288925424.git.joe@perches.com>
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
 drivers/net/e1000e/netdev.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index c4ca162..9922edb 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -2059,10 +2059,9 @@ int e1000e_setup_tx_resources(struct e1000_adapter *adapter)
 	int err = -ENOMEM, size;
 
 	size = sizeof(struct e1000_buffer) * tx_ring->count;
-	tx_ring->buffer_info = vmalloc(size);
+	tx_ring->buffer_info = vzalloc(size);
 	if (!tx_ring->buffer_info)
 		goto err;
-	memset(tx_ring->buffer_info, 0, size);
 
 	/* round up to nearest 4K */
 	tx_ring->size = tx_ring->count * sizeof(struct e1000_tx_desc);
@@ -2095,10 +2094,9 @@ int e1000e_setup_rx_resources(struct e1000_adapter *adapter)
 	int i, size, desc_len, err = -ENOMEM;
 
 	size = sizeof(struct e1000_buffer) * rx_ring->count;
-	rx_ring->buffer_info = vmalloc(size);
+	rx_ring->buffer_info = vzalloc(size);
 	if (!rx_ring->buffer_info)
 		goto err;
-	memset(rx_ring->buffer_info, 0, size);
 
 	for (i = 0; i < rx_ring->count; i++) {
 		buffer_info = &rx_ring->buffer_info[i];
-- 
1.7.3.1.g432b3.dirty

