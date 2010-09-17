Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0IQMsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 08:48:33 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39006 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0IQMsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 08:48:32 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 17 Sep 2010 14:47:27 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.b186ea3830d71c45@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive a hardware quirk entry and a small makefile correction.
Thanks.

Heikki Lindholm (1):
      firewire: ohci: activate cycle timer register quirk on Ricoh chips

Stefan Richter (1):
      firewire: nosy: fix build when CONFIG_FIREWIRE=N

 drivers/Makefile        |    2 +-
 drivers/firewire/ohci.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)


Full log and diff:

commit 8702d33aa6e6d753ef99163afe48aba1323374ef
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Wed Sep 15 13:02:44 2010 +0200

    firewire: nosy: fix build when CONFIG_FIREWIRE=N
    
    drivers/firewire/nosy* is a stand-alone driver that does not depend on
    CONFIG_FIREWIRE.  Hence let make descend into drivers/firewire/ also
    if that option is off.
    
    The stand-alone driver drivers/ieee1394/init_ohci1394_dma*  will soon be
    moved into drivers/firewire/ too and will require the same makefile fix.
    
    Side effect:
    As mentioned in https://bugzilla.novell.com/show_bug.cgi?id=586172#c24
    this influences the order in which either firewire-ohci or ohci1394 is
    going to be bound to an OHCI-1394 controller in case of a modular build
    of both drivers if no modprobe blacklist entries are configured.
    However, a user of such a setup cannot expect deterministic behavior
    anyway.  The Kconfig help and the migration guide at
    ieee1394.wiki.kernel.org recommend blacklist entries when a dual
    IEEE 1394 stack build is being used.  (The coexistence period of the two
    stacks is planned to end soon.)
    
    Cc: Michal Marek <mmarek@suse.cz>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/Makefile b/drivers/Makefile
index 91874e0..0bbb456 100644
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

commit 970f4be85ae6ecf97b711a3a2a1d5cecd3ea0534
Author: Heikki Lindholm <holin@iki.fi>
Date:   Mon Sep 6 22:30:45 2010 +0300

    firewire: ohci: activate cycle timer register quirk on Ricoh chips
    
    The Ricoh FireWire controllers appear to have the non-atomic cycle
    timer register access bug, so, activate the driver workaround by
    default.
    
    The behaviour was observed on:
    Ricoh Co Ltd R5C552 IEEE 1394 Controller [1180:0552] and
    Ricoh Co Ltd R5C832 IEEE 1394 Controller [1180:0832] (rev 04).
    
    Signed-off-by: Heikki Lindholm <holin@iki.fi>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index be29b0b..1b05896 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -263,6 +263,7 @@ static const struct {
 	{PCI_VENDOR_ID_JMICRON,	PCI_DEVICE_ID_JMICRON_JMB38X_FW, QUIRK_NO_MSI},
 	{PCI_VENDOR_ID_NEC,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
 	{PCI_VENDOR_ID_VIA,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
+	{PCI_VENDOR_ID_RICOH,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
 	{PCI_VENDOR_ID_APPLE,	PCI_DEVICE_ID_APPLE_UNI_N_FW, QUIRK_BE_HEADERS},
 };
 

-- 
Stefan Richter
-=====-==-=- =--= =---=
http://arcgraph.de/sr/

