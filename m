Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab1GRQ4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:56:03 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:46931 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753216Ab1GRQ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:56:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=eA3wcEiar2/GWVaDdu8pPNYXsd+Vn4q0urlHho8nlTQLiyV3LHULHcpDamjufgC8seT2RO4C3qd9BhmFeY6R1Juw7wkjhdI1L5oHcItI3QtMO2YHnzFj52r+CKVYhH5F;
Date: Mon, 18 Jul 2011 09:55:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        davem@davemloft.net, Jonas Bonn <jonas@southpole.se>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH -next] asm-generic/iomap.h: add stubs for pci iomap/iounmap
Message-Id: <20110718095557.cd70fa01.rdunlap@xenotime.net>
In-Reply-To: <20110718203501.232bd176e83ff65f056366e6@canb.auug.org.au>
References: <20110718203501.232bd176e83ff65f056366e6@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

When CONFIG_PCI is not enabled, CONFIG_EISA=y, and CONFIG_GENERIC_IOMAP=y,
drivers/net/3c59x.c build fails due to a recent small change to
<asm-generic/iomap.h> that surrounds pci_iomap() and pci_iounmap()
with #ifdef CONFIG_PCI/#endif.  Since that patch to iomap.h looks
correct, add stubs for pci_iomap() and pci_iounmap() with CONFIG_PCI
is not enabled to fix the build errors.

drivers/net/3c59x.c:1026: error: implicit declaration of function 'pci_iomap'
drivers/net/3c59x.c:1038: error: implicit declaration of function 'pci_iounmap'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/iomap.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-next-20110718.orig/include/asm-generic/iomap.h
+++ linux-next-20110718/include/asm-generic/iomap.h
@@ -71,6 +71,14 @@ extern void ioport_unmap(void __iomem *)
 struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
+#else
+struct pci_dev;
+static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
+{
+	return NULL;
+}
+static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
+{ }
 #endif
 
 #endif
