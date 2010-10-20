Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab0JTDJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:09:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51207 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab0JTDJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:09:38 -0400
Date: Wed, 20 Oct 2010 14:09:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        matt mooney <mfm@muteddisk.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ryan Wilson <hap9@epoch.ncsc.mil>
Subject: linux-next: manual merge of the swiotlb-xen tree with the pci tree
Message-Id: <20101020140928.1c919103.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

Today's linux-next merge of the swiotlb-xen tree got a conflict in
drivers/pci/Makefile between commit
350a55e9ff6005032407d3234af800f413b03af5 ("PCI: use new ccflags variable
in Makefile") from the pci tree and commit
956a9202cd1220397933a07beda9f96b3df1fa24 ("xen-pcifront: Xen PCI frontend
driver") from the swiotlb-xen tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

As I said in my other email, Konrad, you can ignore this report - it is
just for information.  The conflict resolution is simple.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pci/Makefile
index dcd7ace,d5e2705..0000000
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@@ -65,4 -65,8 +65,6 @@@ obj-$(CONFIG_PCI_SYSCALL) += syscall.
  
  obj-$(CONFIG_PCI_STUB) += pci-stub.o
  
+ obj-$(CONFIG_XEN_PCIDEV_FRONTEND) += xen-pcifront.o
+ 
 -ifeq ($(CONFIG_PCI_DEBUG),y)
 -EXTRA_CFLAGS += -DDEBUG
 -endif
 +ccflags-$(CONFIG_PCI_DEBUG) := -DDEBUG
