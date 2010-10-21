Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab0JUQyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:54:11 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:21070 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0JUQyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 12:54:10 -0400
X-IronPort-AV: E=Sophos;i="4.58,218,1286150400"; 
   d="scan'208";a="2461775"
Date: Thu, 21 Oct 2010 17:53:36 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 21 (xen)
In-Reply-To: <20101021163225.GA2456@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1010211738530.10348@kaball-desktop>
References: <20101021151529.392fecea.sfr@canb.auug.org.au> <20101021091316.0587c1a8.randy.dunlap@oracle.com> <20101021163225.GA2456@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010, Konrad Rzeszutek Wilk wrote:
> On Thu, Oct 21, 2010 at 09:13:16AM -0700, Randy Dunlap wrote:
> > On Thu, 21 Oct 2010 15:15:29 +1100 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Reminder: do not add 2.6.38 destined stuff to linux-next until after
> > > 2.6.37-rc1 is released.
> > > 
> > > Changes since 20101020:
> > 
> > 
> > When CONFIG_SMP is not enabled:
> > 
> > arch/x86/pci/xen.c:401: error: 'nr_ioapics' undeclared (first use in this function)
> 
> Thank you,
> 
> Stefano, this one is yours.
> 

Yep.
It was a missing #include in arch/x86/pci/xen.c, I fixed it adding a
commit to my linux-next branch.

---

commit fa4c2e29e4a30dc3e9d3f83944eeea63f78350a5
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Thu Oct 21 17:40:08 2010 +0100

    xen: add a missing #include to arch/x86/pci/xen.c
    
    Add missing #include <asm/io_apic.h> to arch/x86/pci/xen.c.
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 4f5df3d..4a32df2 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -10,6 +10,7 @@
 #include <linux/acpi.h>
 
 #include <linux/io.h>
+#include <asm/io_apic.h>
 #include <asm/pci_x86.h>
 
 #include <asm/xen/hypervisor.h>
