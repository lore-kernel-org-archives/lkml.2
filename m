Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab0IRTPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:08 -0400
Received: from kroah.org ([198.145.64.141]:43262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab0IRTO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:57 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:59 2010
Message-Id: <20100918191259.488530849@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [026/129] staging: hv: Fix missing functions for net_device_ops
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

commit b681b5886bb5d1f5b6750a0ed7c62846da7ccea4 upstream.

Fix missing functions for net_device_ops.
It's a bug when porting the drivers from 2.6.27 to 2.6.32. In 2.6.27,
the default functions for Ethernet, like eth_change_mtu(), were assigned
by ether_setup(). But in 2.6.32, these function pointers moved to
net_device_ops structure and no longer be assigned in ether_setup(). So
we need to set these functions in our driver code. It will ensure the
MTU won't be set beyond 1500. Otherwise, this can cause an error on the
server side, because the HyperV linux driver doesn't support jumbo frame
yet.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/netvsc_drv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -348,6 +348,9 @@ static const struct net_device_ops devic
 	.ndo_stop =			netvsc_close,
 	.ndo_start_xmit =		netvsc_start_xmit,
 	.ndo_set_multicast_list =	netvsc_set_multicast_list,
+	.ndo_change_mtu =		eth_change_mtu,
+	.ndo_validate_addr =		eth_validate_addr,
+	.ndo_set_mac_address =		eth_mac_addr,
 };
 
 static int netvsc_probe(struct device *device)


