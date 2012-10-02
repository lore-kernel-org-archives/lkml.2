Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2JBQh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:37:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53882 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab2JBQhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Lennert Buytenhek <kernel@wantstofly.org>, Dan Williams <djbw@fb.com>
Subject: [PATCH 12/17] ARM: iop13xx: mark iop13xx_scan_bus as __devinit
Date: Tue,  2 Oct 2012 18:36:51 +0200
Message-Id: <1349195816-2225-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ZrFsq+pxJoi8qJ06zh+Akc67nxShe8wc4NanVJUGdj9
 elrNLKbez1AIfgz+hzRNH88yNJvR1qF0QzUprhfOkgRbg2cwt0
 tQKeGcW7Y8GOgJt6D2KVgqK8PjtFb2BnFqp5zMr0oJ3MeA2xw0
 j/+6Vr88KMaQKc9EES75D3g8yFp8+8n/X+2EqtKAxn5wEWwK6/
 wydcISUc49OhyOtxLAoRnjq3Ys8r0bJ9qNDPTHL1zXcocqt2zw
 juXtch+RX/kFREzqCc9G803Q2Owo3t/dlYWh+Dgq7Wl62PgpxQ
 9Gjnn7Q0tcrjbj3BtFRVSr5eJAwGmhX8B4XhUjyaj3cSFCR3L3
 CGot6+2jBtj9eYaDhx4sJCrLDdltCN/x3nRzL9GVfy4OqJC6b/
 JodIULo9TWTBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_scan_root_bus is __devinit, so iop13xx_scan_bus has to be the
same in order to safely call it. This is ok because the function
itself is only called from the hwpci->scan callback.

WARNING: vmlinux.o(.text+0x10138): Section mismatch in reference from the function iop13xx_scan_bus() to the function .devinit.text:pci_scan_root_bus()
The function iop13xx_scan_bus() references
the function __devinit pci_scan_root_bus().
This is often because iop13xx_scan_bus lacks a __devinit
annotation or the annotation of pci_scan_root_bus is wrong.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Dan Williams <djbw@fb.com>
---
 arch/arm/mach-iop13xx/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-iop13xx/pci.c b/arch/arm/mach-iop13xx/pci.c
index 861cb12..9d7f4ca 100644
--- a/arch/arm/mach-iop13xx/pci.c
+++ b/arch/arm/mach-iop13xx/pci.c
@@ -506,7 +506,7 @@ iop13xx_pci_abort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 
 /* Scan an IOP13XX PCI bus.  nr selects which ATU we use.
  */
-struct pci_bus *iop13xx_scan_bus(int nr, struct pci_sys_data *sys)
+struct pci_bus * __devinit iop13xx_scan_bus(int nr, struct pci_sys_data *sys)
 {
 	int which_atu;
 	struct pci_bus *bus = NULL;
-- 
1.7.10

