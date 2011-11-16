Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab1KPWQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 17:16:44 -0500
Received: from mail-wy0-f202.google.com ([74.125.82.202]:59210 "EHLO
	mail-wy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab1KPWPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 17:15:38 -0500
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
Subject: [PATCH net-next v6 9/9] forcedeth: stats updated with a deferrable timer
Date: Wed, 16 Nov 2011 14:15:15 -0800
Message-Id: <984005229c6d3b1c6d40246b9f166cd6f30026a0.1321481064.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1321481064.git.david.decotigny@google.com>
References: <cover.1321481064.git.david.decotigny@google.com>
In-Reply-To: <cover.1321481064.git.david.decotigny@google.com>
References: <cover.1321481064.git.david.decotigny@google.com>
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
index 9bf993d..630174b 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -5531,7 +5531,7 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 	init_timer(&np->nic_poll);
 	np->nic_poll.data = (unsigned long) dev;
 	np->nic_poll.function = nv_do_nic_poll;	/* timer handler */
-	init_timer(&np->stats_poll);
+	init_timer_deferrable(&np->stats_poll);
 	np->stats_poll.data = (unsigned long) dev;
 	np->stats_poll.function = nv_do_stats_poll;	/* timer handler */
 
-- 
1.7.3.1

