Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0KEDOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:14:44 -0400
Received: from mail.perches.com ([173.55.12.10]:4121 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab0KEDIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:53 -0400
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
Subject: [PATCH 24/49] drivers/net/ixgb: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:48 -0700
Message-Id: <b63aacd8d05e27da93e3412a146e98939fba8e2a.1288925424.git.joe@perches.com>
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
 drivers/net/ixgb/ixgb_main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ixgb/ixgb_main.c b/drivers/net/ixgb/ixgb_main.c
index caa8192..211a169 100644
--- a/drivers/net/ixgb/ixgb_main.c
+++ b/drivers/net/ixgb/ixgb_main.c
@@ -669,13 +669,12 @@ ixgb_setup_tx_resources(struct ixgb_adapter *adapter)
 	int size;
 
 	size = sizeof(struct ixgb_buffer) * txdr->count;
-	txdr->buffer_info = vmalloc(size);
+	txdr->buffer_info = vzalloc(size);
 	if (!txdr->buffer_info) {
 		netif_err(adapter, probe, adapter->netdev,
 			  "Unable to allocate transmit descriptor ring memory\n");
 		return -ENOMEM;
 	}
-	memset(txdr->buffer_info, 0, size);
 
 	/* round up to nearest 4K */
 
@@ -759,13 +758,12 @@ ixgb_setup_rx_resources(struct ixgb_adapter *adapter)
 	int size;
 
 	size = sizeof(struct ixgb_buffer) * rxdr->count;
-	rxdr->buffer_info = vmalloc(size);
+	rxdr->buffer_info = vzalloc(size);
 	if (!rxdr->buffer_info) {
 		netif_err(adapter, probe, adapter->netdev,
 			  "Unable to allocate receive descriptor ring\n");
 		return -ENOMEM;
 	}
-	memset(rxdr->buffer_info, 0, size);
 
 	/* Round up to nearest 4K */
 
-- 
1.7.3.1.g432b3.dirty

