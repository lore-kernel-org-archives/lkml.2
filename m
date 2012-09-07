Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab2IGGp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:45:57 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:46313 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab2IGGp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:45:56 -0400
MIME-Version: 1.0
Date: Fri, 7 Sep 2012 14:45:55 +0800
Message-ID: <CAPgLHd_w9B8sHg9i9msFLx8FVBypqTtDEVOt1-VBNTW4zwHTMQ@mail.gmail.com>
Subject: [PATCH] powerpc/powernv: move the dereference below the NULL test
From: Wei Yongjun <weiyj.lk@gmail.com>
To: benh@kernel.crashing.org, paulus@samba.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/powerpc/platforms/powernv/pci.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index be3cfc5..4ba89c1 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -287,13 +287,15 @@ static int pnv_pci_read_config(struct pci_bus *bus,
 			       int where, int size, u32 *val)
 {
 	struct pci_controller *hose = pci_bus_to_host(bus);
-	struct pnv_phb *phb = hose->private_data;
+	struct pnv_phb *phb;
 	u32 bdfn = (((uint64_t)bus->number) << 8) | devfn;
 	s64 rc;
 
 	if (hose == NULL)
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
+	phb = hose->private_data;
+
 	switch (size) {
 	case 1: {
 		u8 v8;
@@ -331,12 +333,14 @@ static int pnv_pci_write_config(struct pci_bus *bus,
 				int where, int size, u32 val)
 {
 	struct pci_controller *hose = pci_bus_to_host(bus);
-	struct pnv_phb *phb = hose->private_data;
+	struct pnv_phb *phb;
 	u32 bdfn = (((uint64_t)bus->number) << 8) | devfn;
 
 	if (hose == NULL)
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
+	phb = hose->private_data;
+
 	cfg_dbg("pnv_pci_write_config bus: %x devfn: %x +%x/%x -> %08x\n",
 		bus->number, devfn, where, size, val);
 	switch (size) {

