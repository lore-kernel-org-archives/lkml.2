Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2GASWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:22:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47013 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755973Ab2GASQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:40 -0400
Message-Id: <20120701172013.057646773@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ian Campbell <Ian.Campbell@citrix.com>,
        George Shuklin <george.shuklin@gmail.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        William Dauchy <wdauchy@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 45/48] xen/netfront: teardown the device before unregistering it.
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Campbell <Ian.Campbell@citrix.com>

commit 6bc96d047fe32d76ef79f3195c52a542edf7c705 upstream.

Fixes:
[   15.470311] WARNING: at /local/scratch/ianc/devel/kernels/linux/fs/sysfs/file.c:498 sysfs_attr_ns+0x95/0xa0()
[   15.470326] sysfs: kobject eth0 without dirent
[   15.470333] Modules linked in:
[   15.470342] Pid: 12, comm: xenwatch Not tainted 3.4.0-x86_32p-xenU #93
and
[    9.150554] BUG: unable to handle kernel paging request at 2b359000
[    9.150577] IP: [<c1279561>] linkwatch_do_dev+0x81/0xc0
[    9.150592] *pdpt = 000000002c3c9027 *pde = 0000000000000000
[    9.150604] Oops: 0002 [#1] SMP
[    9.150613] Modules linked in:

This is http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=675190

Reported-by: George Shuklin <george.shuklin@gmail.com>
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Tested-by: William Dauchy <wdauchy@gmail.com>
Cc: 675190@bugs.debian.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/xen-netfront.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 2027afe..3089990 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1935,14 +1935,14 @@ static int __devexit xennet_remove(struct xenbus_device *dev)
 
 	dev_dbg(&dev->dev, "%s\n", dev->nodename);
 
-	unregister_netdev(info->netdev);
-
 	xennet_disconnect_backend(info);
 
-	del_timer_sync(&info->rx_refill_timer);
-
 	xennet_sysfs_delif(info->netdev);
 
+	unregister_netdev(info->netdev);
+
+	del_timer_sync(&info->rx_refill_timer);
+
 	free_percpu(info->stats);
 
 	free_netdev(info->netdev);


