Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab2JSEP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 00:15:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47727 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932126Ab2JSEPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 00:15:23 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net-next 12/21] uwb: Convert is_<foo>_ether_addr uses to eth_addr_<foo>
Date: Thu, 18 Oct 2012 21:14:56 -0700
Message-Id: <2b17c8139285b5da29d7a70b6d08318272e2d168.1350618011.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350618006.git.joe@perches.com>
References: <cover.1350618006.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the old ether_addr tests to eth_addr_<foo>.
Adds api consistency.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/uwb/address.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uwb/address.c b/drivers/uwb/address.c
index 8739c4f..ba4e4cf 100644
--- a/drivers/uwb/address.c
+++ b/drivers/uwb/address.c
@@ -343,7 +343,7 @@ static ssize_t uwb_rc_mac_addr_store(struct device *dev,
 		result = -EINVAL;
 		goto out;
 	}
-	if (is_multicast_ether_addr(addr.data)) {
+	if (eth_addr_multicast(addr.data)) {
 		dev_err(&rc->uwb_dev.dev, "refusing to set multicast "
 			"MAC address %s\n", buf);
 		result = -EINVAL;
-- 
1.7.8.111.gad25c.dirty

