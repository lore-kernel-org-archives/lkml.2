Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab0IRTCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:39 -0400
Received: from kroah.org ([198.145.64.141]:51281 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab0IRTBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:33 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:56 2010
Message-Id: <20100918185955.993240822@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        594845@bugs.debian.org, Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [037/123] tun: Dont add sysfs attributes to devices without sysfs directories
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=tun-don-t-add-sysfs-attributes-to-devices-without-sysfs-directories.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

This applies to 2.6.32 *only*.  It has not been applied upstream since
the limitation no longer exists.

Prior to Linux 2.6.35, net devices outside the initial net namespace
did not have sysfs directories.  Attempting to add attributes to
them will trigger a BUG().

Reported-and-tested-by: Russell Stuart <russell-debian@stuart.id.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tun.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1006,7 +1006,8 @@ static int tun_set_iff(struct net *net,
 		if (err < 0)
 			goto err_free_sk;
 
-		if (device_create_file(&tun->dev->dev, &dev_attr_tun_flags) ||
+		if (!net_eq(dev_net(tun->dev), &init_net) ||
+		    device_create_file(&tun->dev->dev, &dev_attr_tun_flags) ||
 		    device_create_file(&tun->dev->dev, &dev_attr_owner) ||
 		    device_create_file(&tun->dev->dev, &dev_attr_group))
 			printk(KERN_ERR "Failed to create tun sysfs files\n");


