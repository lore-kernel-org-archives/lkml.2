Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1AOA7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 19:59:30 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:41147 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410Ab1AOA7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 19:59:24 -0500
Subject: [PATCH net-next 1/8] vmxnet3: fix ring size update
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: Shreyas N Bhatewara <sbhatewara@vmware.com>
Cc: pv-drivers@vmware.com, Dmitry Torokhov <dtor@vmware.com>
Date: Fri, 14 Jan 2011 16:59:25 -0800
Message-ID: <20110115005925.1064.62053.stgit@sbhatewara-dev1.eng.vmware.com>
In-Reply-To: <20110115005701.1064.67435.stgit@sbhatewara-dev1.eng.vmware.com>
References: <20110115005701.1064.67435.stgit@sbhatewara-dev1.eng.vmware.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug while changing ring size when MTU is changed.

Signed-off-by: Shreyas N Bhatewara <sbhatewara@vmware.com>
Acked-by: Dmitry Torokhov <dtor@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index d143e8b..562bdbb 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2426,7 +2426,7 @@ vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
 	sz = adapter->rx_buf_per_pkt * VMXNET3_RING_SIZE_ALIGN;
 	ring0_size = adapter->rx_queue[0].rx_ring[0].size;
 	ring0_size = (ring0_size + sz - 1) / sz * sz;
-	ring0_size = min_t(u32, rq->rx_ring[0].size, VMXNET3_RX_RING_MAX_SIZE /
+	ring0_size = min_t(u32, ring0_size, VMXNET3_RX_RING_MAX_SIZE /
 			   sz * sz);
 	ring1_size = adapter->rx_queue[0].rx_ring[1].size;
 	comp_size = ring0_size + ring1_size;

