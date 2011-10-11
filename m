Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab1JKRDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:03:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748Ab1JKRDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:03:10 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:08 2011
Message-Id: <20111011165708.619251000@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:12 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [02/38] PCI: export pcie_bus_configure_settings symbol
In-Reply-To: <20111011165903.GA30976@kroah.com>
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


