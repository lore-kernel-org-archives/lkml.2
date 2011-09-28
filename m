Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab1I1WoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:44:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54284 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932634Ab1I1WoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:44:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:35 2011
Message-Id: <20110928220135.883241399@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [100/244] PCI: export pcie_bus_configure_settings symbol
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jon Mason <mason@myri.com>

commit debc3b778508f59696ff188f0feca271dcbfa7d9 upstream.

pcie_bus_configure_settings needs to be exported if the PCI hotplug
driver is being compiled as a module.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Jon Mason <mason@myri.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/probe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1471,6 +1471,7 @@ void pcie_bus_configure_settings(struct
 	pcie_bus_configure_set(bus->self, &smpss);
 	pci_walk_bus(bus, pcie_bus_configure_set, &smpss);
 }
+EXPORT_SYMBOL_GPL(pcie_bus_configure_settings);
 
 unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 {


