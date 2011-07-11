Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab1GKNnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:43:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49481 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab1GKNnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:43:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 11 Jul 2011 15:42:49 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire update
Message-ID: <20110711154249.7b755dff@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the movieboard branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git movieboard

to receive the following quirks workaround for the IEEE 1394 (FireWire)
subsystem.  This is a hopefully temporary bandaid for a comparably rare
piece of hardware.

Thanks.

Stefan Richter (1):
      firewire: ohci: do not bind to Pinnacle cards, avert panic

 drivers/firewire/ohci.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)


commit 7f7e37115a8b6724f26d0637a04e1d35e3c59717
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Jul 10 00:23:03 2011 +0200

    firewire: ohci: do not bind to Pinnacle cards, avert panic
    
    When firewire-ohci is bound to a Pinnacle MovieBoard, eventually a
    "Register access failure" is logged and an interrupt storm or a kernel
    panic happens.  https://bugzilla.kernel.org/show_bug.cgi?id=36622
    
    Until this is sorted out (if that is going to succeed at all), let's
    just prevent firewire-ohci from touching these devices.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Cc: <stable@kernel.org>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 438e6c8..ebb8973 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -264,6 +264,7 @@ static char ohci_driver_name[] = KBUILD_MODNAME;
 #define PCI_DEVICE_ID_AGERE_FW643      0x5901
 #define PCI_DEVICE_ID_JMICRON_JMB38X_FW        0x2380
 #define PCI_DEVICE_ID_TI_TSB12LV22     0x8009
+#define PCI_VENDOR_ID_PINNACLE_SYSTEMS 0x11bd
 
 #define QUIRK_CYCLE_TIMER              1
 #define QUIRK_RESET_PACKET             2
@@ -3190,6 +3191,11 @@ static int __devinit pci_probe(struct pci_dev *dev,
        int i, err;
        size_t size;
 
+       if (dev->vendor == PCI_VENDOR_ID_PINNACLE_SYSTEMS) {
+               dev_err(&dev->dev, "Pinnacle MovieBoard is not yet supported\n");
+               return -ENOSYS;
+       }
+
        ohci = kzalloc(sizeof(*ohci), GFP_KERNEL);
        if (ohci == NULL) {
                err = -ENOMEM;

-- 
Stefan Richter
-=====-==-== -=== -=-==
http://arcgraph.de/sr/
