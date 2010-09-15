Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0IOLDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:03:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45066 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab0IOLC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:02:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 15 Sep 2010 13:02:44 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fix nosy build when CONFIG_FIREWIRE=N
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Message-ID: <tkrat.3170e56bd8aeb280@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/firewire/nosy* is a stand-alone driver that does not depend on
CONFIG_FIREWIRE.  Hence let make descend into drivers/firewire/ also
if that option is off.

The stand-alone driver drivers/ieee1394/init_ohci1394_dma*  will soon be
moved into drivers/firewire/ too and will require the same makefile fix.

Side effect:
As mentioned in https://bugzilla.novell.com/show_bug.cgi?id=586172#c24
this influences the order in which either firewire-ohci or ohci1394 are
going to be bound to an OHCI-1394 controller in case of a modular build
of both drivers if no modprobe blacklist entries are configured.
However, a user of such a setup cannot expect deterministic behavior
anyway.  The Kconfig help and the migration guide at
ieee1394.wiki.kernel.org recommend blacklist entries when a dual
IEEE 1394 stack build is being used.  (The coexistence period of the two
stacks is planned to end soon.)

Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/Makefile
===================================================================
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -50,7 +50,7 @@ obj-$(CONFIG_SPI)		+= spi/
 obj-y				+= net/
 obj-$(CONFIG_ATM)		+= atm/
 obj-$(CONFIG_FUSION)		+= message/
-obj-$(CONFIG_FIREWIRE)		+= firewire/
+obj-y				+= firewire/
 obj-y				+= ieee1394/
 obj-$(CONFIG_UIO)		+= uio/
 obj-y				+= cdrom/

-- 
Stefan Richter
-=====-==-=- =--= -====
http://arcgraph.de/sr/

