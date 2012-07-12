Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353Ab2GLXne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:43:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759510Ab2GLWhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:37:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        George Shuklin <george.shuklin@gmail.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        William Dauchy <wdauchy@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, stable@kernel.org,
        675190@bugs.debian.org
Subject: [ 041/187] xen/netfront: teardown the device before unregistering it.
Date: Thu, 12 Jul 2012 15:33:17 -0700
Message-Id: <20120712191526.143177530@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ian Campbell <Ian.Campbell@citrix.com>

[ Upstream commit 6bc96d047fe32d76ef79f3195c52a542edf7c705 ]

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
Cc: stable@kernel.org
Cc: 675190@bugs.debian.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1935,14 +1935,14 @@ static int __devexit xennet_remove(struc
 
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


