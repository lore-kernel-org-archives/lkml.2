Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0LGSQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 13:16:19 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50399 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0LGSQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 13:16:18 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 7 Dec 2010 19:16:02 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Robin Cook <rcook@wyrms.net>,
        Jonathan Isom <jeisom@gmail.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH 1/2] firewire: ohci: fix regression with VIA VT6315, disable
 MSI
Message-ID: <20101207191602.50419f9e@stein>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"VIA Technologies, Inc. VT6315 Series Firewire Controller [1106:3403]"
does not generate any interrupts if Message Signaled Interrupts were
enabled.  This is a regression since kernel 2.6.36 in which MSI support
was added to firewire-ohci.  Hence blacklist MSI on all VIA controllers.

Reported-by: Robin Cook <rcook@wyrms.net>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: <stable@kernel.org> # 2.6.36.y
---
 drivers/firewire/ohci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -262,7 +262,8 @@ static const struct {
 	{PCI_VENDOR_ID_AL,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
 	{PCI_VENDOR_ID_JMICRON,	PCI_DEVICE_ID_JMICRON_JMB38X_FW, QUIRK_NO_MSI},
 	{PCI_VENDOR_ID_NEC,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
-	{PCI_VENDOR_ID_VIA,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
+	{PCI_VENDOR_ID_VIA,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER |
+						QUIRK_NO_MSI},
 	{PCI_VENDOR_ID_RICOH,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
 	{PCI_VENDOR_ID_APPLE,	PCI_DEVICE_ID_APPLE_UNI_N_FW, QUIRK_BE_HEADERS},
 };


-- 
Stefan Richter
-=====-==-=- ==-- --===
http://arcgraph.de/sr/
