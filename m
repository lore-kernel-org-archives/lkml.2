Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab2BHOjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:39:06 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48569 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab2BHOjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:39:02 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] commit 203b4da511d52cc98c720cab67745f23e42232e4
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 08 Feb 2012 14:52:47 +0000
Message-ID: <20120208145246.10900.2594.stgit@bob.linux.org.uk>
In-Reply-To: <20120208145226.10900.49460.stgit@bob.linux.org.uk>
References: <20120208145226.10900.49460.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

v4l/atomisp: treat atomisp as real pci device

    ATOMISP on Medfield is a real PCI device which should be handled differently
    than the fake PCI devices on south complex. PCI type 1 access is used for
    accessing config space this also has other impact such as PM D3 delay. There
    shouldn't be any need for reading base address from IUNIT via msg bus.

    Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

 arch/x86/pci/mrst.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 89e5548..c5e81a4 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -148,7 +148,9 @@ static bool type1_access_ok(unsigned int bus, unsigned int devfn, int reg)
 	 */
 	if (reg >= 0x100 || reg == PCI_STATUS || reg == PCI_HEADER_TYPE)
 		return 0;
-	if (bus == 0 && (devfn == PCI_DEVFN(2, 0) || devfn == PCI_DEVFN(0, 0)))
+	if (bus == 0 && (devfn == PCI_DEVFN(2, 0)
+				|| devfn == PCI_DEVFN(0, 0)
+				|| devfn == PCI_DEVFN(3, 0)))
 		return 1;
 	return 0; /* langwell on others */
 }

