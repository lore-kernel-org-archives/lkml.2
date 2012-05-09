Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab2EIGYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:24:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38880 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756116Ab2EIFxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:14 -0400
Message-Id: <20120509055039.400449756@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Phil Sutter <phil.sutter@viprinet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 069/167] [PATCH 09/26] wimax: i2400m - prevent a possible kernel bug due to
 missing fw_name string
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil.sutter@viprinet.com>

[ Upstream commit 4eee6a3a04e8bb53fbe7de0f64d0524d3fbe3f80 ]

This happened on a machine with a custom hotplug script calling nameif,
probably due to slow firmware loading. At the time nameif uses ethtool
to gather interface information, i2400m->fw_name is zero and so a null
pointer dereference occurs from within i2400m_get_drvinfo().

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wimax/i2400m/netdev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wimax/i2400m/netdev.c b/drivers/net/wimax/i2400m/netdev.c
index 64a1106..4697cf3 100644
--- a/drivers/net/wimax/i2400m/netdev.c
+++ b/drivers/net/wimax/i2400m/netdev.c
@@ -607,7 +607,8 @@ static void i2400m_get_drvinfo(struct net_device *net_dev,
 	struct i2400m *i2400m = net_dev_to_i2400m(net_dev);
 
 	strncpy(info->driver, KBUILD_MODNAME, sizeof(info->driver) - 1);
-	strncpy(info->fw_version, i2400m->fw_name, sizeof(info->fw_version) - 1);
+	strncpy(info->fw_version,
+	        i2400m->fw_name ? : "", sizeof(info->fw_version) - 1);
 	if (net_dev->dev.parent)
 		strncpy(info->bus_info, dev_name(net_dev->dev.parent),
 			sizeof(info->bus_info) - 1);
-- 
1.7.10



