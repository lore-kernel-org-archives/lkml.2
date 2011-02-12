Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab1BLGfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 01:35:30 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33705 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab1BLGfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 01:35:25 -0500
Date: Fri, 11 Feb 2011 22:33:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, netdev <netdev@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        Kurt Van Dijck <kurt.van.dijck@eia.be>
Subject: [PATCH -next/mmotm] net/can: fix softing build errors
Message-Id: <20110211223312.be571303.randy.dunlap@oracle.com>
In-Reply-To: <201102110100.p1B10sDx029244@imap1.linux-foundation.org>
References: <201102110100.p1B10sDx029244@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D562A24.003B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix can/softing build errors due to kconfig error.

kconfig tells us about a problem...

warning: (CAN_SOFTING_CS) selects CAN_SOFTING which has unmet direct dependencies (NET && CAN && CAN_DEV && HAS_IOMEM)

and then this is what happens due to that kconfig problem:

ERROR: "register_candev" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "alloc_candev" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "can_bus_off" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "close_candev" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "free_candev" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "unregister_candev" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "alloc_can_skb" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "open_candev" [drivers/net/can/softing/softing.ko] undefined!

with this partial config:

CONFIG_CAN=m
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
# CAN Device Drivers
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=m
# CONFIG_CAN_DEV is not set
CONFIG_CAN_SOFTING=m
CONFIG_CAN_SOFTING_CS=m
# CONFIG_CAN_DEBUG_DEVICES is not set

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>
---
 drivers/net/can/softing/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2011-0210-1626.orig/drivers/net/can/softing/Kconfig
+++ mmotm-2011-0210-1626/drivers/net/can/softing/Kconfig
@@ -18,6 +18,7 @@ config CAN_SOFTING
 config CAN_SOFTING_CS
 	tristate "Softing Gmbh CAN pcmcia cards"
 	depends on PCMCIA
+	depends on CAN_DEV && HAS_IOMEM
 	select CAN_SOFTING
 	---help---
 	  Support for PCMCIA cards from Softing Gmbh & some cards
