Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab1AFBCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 20:02:07 -0500
Received: from kroah.org ([198.145.64.141]:35422 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab1AFA26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:28:58 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:58 2011
Message-Id: <20110106002258.125322625@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:21:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [015/152] firewire: ohci: fix regression with VIA VT6315, disable MSI
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit af0cdf4947818becfe209610b209315578645ab4 upstream.

"VIA Technologies, Inc. VT6315 Series Firewire Controller [1106:3403]"
does not generate any interrupts if Message Signaled Interrupts were
enabled.  This is a regression since kernel 2.6.36 in which MSI support
was added to firewire-ohci.  Hence blacklist MSI on all VIA controllers.

Reported-by: Robin Cook <rcook@wyrms.net>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/ohci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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


