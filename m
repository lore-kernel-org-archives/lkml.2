Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2BUMIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 07:08:14 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:57446 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754342Ab2BUMIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 07:08:12 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Mark Einon <mark.einon@gmail.com>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Staging: et131x: unify return value of .ndo_set_mac_address if address is invalid
Date: Tue, 21 Feb 2012 13:07:51 +0100
Message-Id: <1329826072-14689-4-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1329826072-14689-1-git-send-email-danny.kukawka@bisect.de>
References: <1329826072-14689-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329826092;f5aaca81;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify return value of .ndo_set_mac_address if the given address
isn't valid. Return -EADDRNOTAVAIL as eth_mac_addr() already does
if is_valid_ether_addr() fails.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/staging/et131x/et131x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 2c4069f..b055731 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -5177,7 +5177,7 @@ static int et131x_set_mac_addr(struct net_device *netdev, void *new_mac)
 
 	/* Make sure the requested MAC is valid */
 	if (!is_valid_ether_addr(address->sa_data))
-		return -EINVAL;
+		return -EADDRNOTAVAIL;
 
 	et131x_disable_txrx(netdev);
 	et131x_handle_send_interrupt(adapter);
-- 
1.7.8.3

