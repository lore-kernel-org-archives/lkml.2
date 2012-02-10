Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523Ab2BJWlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:41:05 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760446Ab2BJWlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:41:03 -0500
MIME-Version: 1.0
Message-Id: <20120210222946.816152843@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Stefan Thomas <kontrapunktstefan@googlemail.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 20/86] firewire: ohci: disable MSI on Ricoh controllers
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 320cfa6ce0b3dc794fedfa4bae54c0f65077234d upstream.

The PCIe device

    FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd FireWire Host Controller
    [1180:e832] (prog-if 10 [OHCI])

is unable to access attached FireWire devices when MSI is enabled but
works if MSI is disabled.
http://www.mail-archive.com/alsa-user@lists.sourceforge.net/msg28251.html

Hence add the "disable MSI" quirks flag for this device, or in fact for
safety and simplicity for all current (R5U230, R5U231, R5U240) and
future Ricoh PCIe 1394 controllers.

Reported-by: Stefan Thomas <kontrapunktstefan@googlemail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firewire/ohci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -303,7 +303,7 @@ static const struct {
 		QUIRK_NO_MSI},
 
 	{PCI_VENDOR_ID_RICOH, PCI_ANY_ID, PCI_ANY_ID,
-		QUIRK_CYCLE_TIMER},
+		QUIRK_CYCLE_TIMER | QUIRK_NO_MSI},
 
 	{PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_TSB12LV22, PCI_ANY_ID,
 		QUIRK_CYCLE_TIMER | QUIRK_RESET_PACKET | QUIRK_NO_1394A},


