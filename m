Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab2BRVCH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 16:02:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52750 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab2BRVCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 16:02:05 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Feb 2012 22:01:54 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] firewire: net: identify to driver core as
 "firewire_net", not "net"
Message-ID: <20120218220154.44a39bf2@stein>
In-Reply-To: <20120218215824.5b2359bf@stein>
References: <20120218215824.5b2359bf@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On second thought, there is little reason to have driver name differ
from module name.  Therefore, change
    /sys/bus/firewire/drivers/net
    /sys/bus/firewire/devices/fw0.0/driver -> [...]/net
    /sys/module/firewire_net/drivers/firewire:net
to
    /sys/bus/firewire/drivers/firewire_net
    /sys/bus/firewire/devices/fw0.0/driver -> [...]/firewire_net
    /sys/module/firewire_net/drivers/firewire:firewire_net
It is redundant but consistent with firewire-sbp2's recently changed
driver name.

I don't see this anywhere used, so it should not matter either way.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -1648,7 +1648,7 @@ static const struct ieee1394_device_id f
 static struct fw_driver fwnet_driver = {
 	.driver = {
 		.owner  = THIS_MODULE,
-		.name   = "net",
+		.name   = KBUILD_MODNAME,
 		.bus    = &fw_bus_type,
 		.probe  = fwnet_probe,
 		.remove = fwnet_remove,


-- 
Stefan Richter
-=====-===-- --=- =--=-
http://arcgraph.de/sr/
