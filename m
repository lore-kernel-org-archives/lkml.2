Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab1I1WqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:46:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab1I1WqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:46:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:39 2011
Message-Id: <20110928220139.340466719@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ming Lei <ming.lei@canonical.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [133/244] firewire: ohci: add no MSI quirk for O2Micro controller
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit f39aa30d7741f40ad964341e9243dbbd7f8ff057 upstream.

This fixes https://bugs.launchpad.net/ubuntu/+source/linux/+bug/801719 .

An O2Micro PCI Express FireWire controller,
"FireWire (IEEE 1394) [0c00]: O2 Micro, Inc. Device [1217:11f7] (rev 05)"
which is a combination device together with an SDHCI controller and some
sort of storage controller, misses SBP-2 status writes from an attached
FireWire HDD.  This problem goes away if MSI is disabled for this
FireWire controller.

The device reportedly does not require QUIRK_CYCLE_TIMER.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/ohci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -291,6 +291,9 @@ static const struct {
 	{PCI_VENDOR_ID_NEC, PCI_ANY_ID, PCI_ANY_ID,
 		QUIRK_CYCLE_TIMER},
 
+	{PCI_VENDOR_ID_O2, PCI_ANY_ID, PCI_ANY_ID,
+		QUIRK_NO_MSI},
+
 	{PCI_VENDOR_ID_RICOH, PCI_ANY_ID, PCI_ANY_ID,
 		QUIRK_CYCLE_TIMER},
 


