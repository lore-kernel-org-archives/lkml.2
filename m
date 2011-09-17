Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1IQRkn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 13:40:43 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44645 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab1IQRkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 13:40:42 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 17 Sep 2011 19:40:24 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire fix
Message-ID: <20110917194024.7866123a@stein>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the fixes branch at

    git://git.user.in-berlin.de/s5r6/linux1394.git fixes

to receive a hardware quirks flag.  Thanks.

Ming Lei (1):
      firewire: ohci: add no MSI quirk for O2Micro controller

 drivers/firewire/ohci.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


commit f39aa30d7741f40ad964341e9243dbbd7f8ff057
Author: Ming Lei <ming.lei@canonical.com>
Date:   Wed Aug 31 10:45:46 2011 +0800

    firewire: ohci: add no MSI quirk for O2Micro controller
    
    This fixes https://bugs.launchpad.net/ubuntu/+source/linux/+bug/801719 .
    
    An O2Micro PCI Express FireWire controller,
    "FireWire (IEEE 1394) [0c00]: O2 Micro, Inc. Device [1217:11f7] (rev 05)"
    which is a combination device together with an SDHCI controller and some
    sort of storage controller, misses SBP-2 status writes from an attached
    FireWire HDD.  This problem goes away if MSI is disabled for this
    FireWire controller.
    
    The device reportedly does not require QUIRK_CYCLE_TIMER.
    
    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (amended changelog)
    Cc: <stable@kernel.org>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 57cd3a4..fd7170a 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -290,6 +290,9 @@ static const struct {
 	{PCI_VENDOR_ID_NEC, PCI_ANY_ID, PCI_ANY_ID,
 		QUIRK_CYCLE_TIMER},
 
+	{PCI_VENDOR_ID_O2, PCI_ANY_ID, PCI_ANY_ID,
+		QUIRK_NO_MSI},
+
 	{PCI_VENDOR_ID_RICOH, PCI_ANY_ID, PCI_ANY_ID,
 		QUIRK_CYCLE_TIMER},
 
-- 
Stefan Richter
-=====-==-== =--= =---=
http://arcgraph.de/sr/
