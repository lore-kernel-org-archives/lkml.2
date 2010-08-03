Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab0HCSZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:25:59 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:18138 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab0HCSZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:25:57 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "'gregkh@suse.de'" <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/1] staging: hv: Fix missing functions for net_device_ops
 (submit again)
Thread-Topic: [PATCH 1/1] staging: hv: Fix missing functions for
 net_device_ops (submit again)
Thread-Index: AQHLMzlQWsjA8B1QnEq3K3jKXwO8xg==
Date: Tue, 3 Aug 2010 18:25:53 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF728380C30F@TK5EX14MBXC126.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Fix missing functions for net_device_ops.
Unlike in older kernels, ether_setup() no longer sets default
functions. We need to put them into net_device_ops. For example,
eth_change_mtu prevents setting MTU beyond 1500. This is necessary
because we don't support jumbo frame at this time.
It affects kernel 2.6.32 and later, which are all versions
containing Hyper-V drivers.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/netvsc_drv.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 56e1157..64a0114 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -327,6 +327,9 @@ static const struct net_device_ops device_ops = {
 	.ndo_stop =			netvsc_close,
 	.ndo_start_xmit =		netvsc_start_xmit,
 	.ndo_set_multicast_list =	netvsc_set_multicast_list,
+	.ndo_change_mtu =		eth_change_mtu,
+	.ndo_validate_addr =		eth_validate_addr,
+	.ndo_set_mac_address =		eth_mac_addr,
 };
 
 static int netvsc_probe(struct device *device)
-- 
1.6.3.2

