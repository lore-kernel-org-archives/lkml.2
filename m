Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab1KVTYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:24:11 -0500
Received: from mail-vw0-f74.google.com ([209.85.212.74]:46584 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab1KVTYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:24:01 -0500
From: David Decotigny <david.decotigny@google.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: David Decotigny <david.decotigny@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH net-next v2 4/4] net-e1000e: Report carrier in loopback mode
Date: Tue, 22 Nov 2011 11:23:38 -0800
Message-Id: <9f22e42c3077643fe66221eb180be6e66a0ef32a.1321989502.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1321989502.git.david.decotigny@google.com>
References: <cover.1321989502.git.david.decotigny@google.com>
In-Reply-To: <cover.1321989502.git.david.decotigny@google.com>
References: <cover.1321989502.git.david.decotigny@google.com>
Organization: Google, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Żenczykowski <zenczykowski@gmail.com>

When interface is configured in loopback mode, force carrier check
positive.  This is useful when interface does not have carrier and
test puts the interface in loopback mode.

Tested: pktgen loopback on 80003ES2LAN


Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/intel/e1000e/phy.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index f487a7f..9476c8f 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -1781,6 +1781,11 @@ s32 e1000e_phy_has_link_generic(struct e1000_hw *hw, u32 iterations,
 	u16 phy_reg;
 	int good_reads_phy_status = 0;
 
+	/* If loopback is enabled, we claim the link is up */
+	if ((0 == e1e_rphy(hw, PHY_CONTROL, &phy_reg))
+	    && (phy_reg & MII_CR_LOOPBACK)) {
+		*success = true;
+		return 0;
 	}
 
 	/*
-- 
1.7.3.1

