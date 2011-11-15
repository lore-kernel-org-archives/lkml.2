Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab1KOT16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:27:58 -0500
Received: from mail-ww0-f74.google.com ([74.125.82.74]:49653 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab1KOT0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:26:07 -0500
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net-next v4 8/8] forcedeth: stats updated with a deferrable timer
Date: Tue, 15 Nov 2011 11:25:41 -0800
Message-Id: <ba205b5e371d4bb8a8f765ee663597238679c650.1321384662.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1321384662.git.david.decotigny@google.com>
References: <cover.1321384662.git.david.decotigny@google.com>
In-Reply-To: <cover.1321384662.git.david.decotigny@google.com>
References: <cover.1321384662.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark stats timer as deferrable: punctuality in waking the stats timer
callback doesn't matter much, as it is responsible only to avoid
integer wraparound.

We need at least 1 other timer to fire within 17s (fully loaded 1Gbps)
to avoid wrap-arounds. Desired period is still 10s.



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 7284f40..b5c85de 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -5538,7 +5538,7 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 	init_timer(&np->nic_poll);
 	np->nic_poll.data = (unsigned long) dev;
 	np->nic_poll.function = nv_do_nic_poll;	/* timer handler */
-	init_timer(&np->stats_poll);
+	init_timer_deferrable(&np->stats_poll);
 	np->stats_poll.data = (unsigned long) dev;
 	np->stats_poll.function = nv_do_stats_poll;	/* timer handler */
 
-- 
1.7.3.1

