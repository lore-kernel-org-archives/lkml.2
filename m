Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0JUO3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:29:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62693 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab0JUO3U (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 21 Oct 2010 10:29:20 -0400
Date: Thu, 21 Oct 2010 10:28:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-10-20-15-01 uploaded
Message-ID: <20101021142827.GA31420@dumpdata.com>
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>
 <4CBFAB7B.7080306@cn.fujitsu.com>
 <4CBFB06B.3020305@cn.fujitsu.com>
 <20101021033815.GA696@dumpdata.com>
 <4CBFB70C.1030009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBFB70C.1030009@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> Got this:
> >>>
> >>> arch/x86/pci/xen.c: In function 'pci_xen_init':
> >>> arch/x86/pci/xen.c:138: error: 'isapnp_disable' undeclared (first use in this function)
> >>> arch/x86/pci/xen.c:138: error: (Each undeclared identifier is reported only once
> >>> arch/x86/pci/xen.c:138: error: for each function it appears in.)
> > 
> > Ok. Will fix this.
> >>> # quilt patches arch/x86/pci/xen.c
> >>> linux-next.patch
> >> I just commented out isapnp_disable, and after boot I saw this warning:

I got this patch queued up. You mentioned that commenting it out did fix
the problem, so I stuck a Tested-by tag from you on it.

>From 5bba6c56dc99ff88f79a79572e29ecf445710878 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 21 Oct 2010 09:36:07 -0400
Subject: [PATCH 27/27] X86/PCI: Remove the dependency on isapnp_disable.

This looks to be vestigial dependency that had never been used even
in the original code base (2.6.18) from which this driver
was up-ported. Without this fix, with the CONFIG_ISAPNP, we get this
compile failure:

arch/x86/pci/xen.c: In function 'pci_xen_init':
arch/x86/pci/xen.c:138: error: 'isapnp_disable' undeclared (first use in this function)
arch/x86/pci/xen.c:138: error: (Each undeclared identifier is reported only once
arch/x86/pci/xen.c:138: error: for each function it appears in.)

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index b19c873..4e37106 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -133,11 +133,6 @@ int __init pci_xen_init(void)
 	acpi_noirq = 1;
 #endif
 
-#ifdef CONFIG_ISAPNP
-	/* Stop isapnp from probing */
-	isapnp_disable = 1;
-#endif
-
 #ifdef CONFIG_PCI_MSI
 	x86_msi.setup_msi_irqs = xen_setup_msi_irqs;
 	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
-- 
1.7.1

