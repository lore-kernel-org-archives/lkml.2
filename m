Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab2BXQEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:04:15 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:39911 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932152Ab2BXQEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:04:12 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] rose: check given MAC address, if invalid return -EADDRNOTAVAIL
Date: Fri, 24 Feb 2012 17:01:22 +0100
Message-Id: <1330099282-4588-13-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
References: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330099452;d1a70a44;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check if given address is valid in .ndo_set_mac_address/
rose_set_mac_address(), if invalid return -EADDRNOTAVAIL as
eth_mac_addr() already does if is_valid_ether_addr() fails.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 net/rose/rose_dev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/rose/rose_dev.c b/net/rose/rose_dev.c
index 178ff4f..1ae8791 100644
--- a/net/rose/rose_dev.c
+++ b/net/rose/rose_dev.c
@@ -96,6 +96,9 @@ static int rose_set_mac_address(struct net_device *dev, void *addr)
 	struct sockaddr *sa = addr;
 	int err;
 
+	if (!is_valid_ether_addr(sa->sa_data))
+		return -EADDRNOTAVAIL;
+
 	if (!memcpy(dev->dev_addr, sa->sa_data, dev->addr_len))
 		return 0;
 
-- 
1.7.8.3

