Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab0EJWwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:52:42 -0400
Received: from kroah.org ([198.145.64.141]:33054 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390Ab0EJWwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:07 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:20 2010
Message-Id: <20100510223320.802556259@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@vyatta.com>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: [040/117] Staging: hv: name network device ethX rather than sethX
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen Hemminger <shemminger@vyatta.com>

commit 546d9e101e7a71e6202f47a13ddcd9b8fb05a52e upstream.

This patch makes the HyperV network device use the same naming scheme as
other virtual drivers (Xen, KVM). In an ideal world, userspace tools
would not care what the name is, but some users and applications do
care. Vyatta CLI is one of the tools that does depend on what the name
is.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/netvsc_drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -413,8 +413,7 @@ static int netvsc_probe(struct device *d
 	if (!net_drv_obj->Base.OnDeviceAdd)
 		return -1;
 
-	net = alloc_netdev(sizeof(struct net_device_context), "seth%d",
-			   ether_setup);
+	net = alloc_etherdev(sizeof(struct net_device_context));
 	if (!net)
 		return -1;
 


