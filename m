Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2GRQrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:47:20 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:44224 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab2GRQrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:47:16 -0400
X-IronPort-AV: E=Sophos;i="4.77,610,1336348800"; 
   d="scan'208";a="13593697"
Date: Wed, 18 Jul 2012 17:46:30 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Tim (Xen.org)" <tim@xen.org>
Subject: Re: [PATCH WIP 1/6] xen/arm: fix the shared_info and vcpu_info
 structs
In-Reply-To: <20120716145729.GC552@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1207181744510.23783@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com> <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120709144156.GC12102@phenom.dumpdata.com> <alpine.DEB.2.02.1207131746380.23783@kaball.uk.xensource.com>
 <1342199338.8586.221.camel@hastur.hellion.org.uk> <20120716145729.GC552@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Konrad Rzeszutek Wilk wrote:
> On Fri, Jul 13, 2012 at 11:08:58AM -0600, Ian Campbell wrote:
> > On Fri, 2012-07-13 at 12:48 -0400, Stefano Stabellini wrote:
> > > On Mon, 9 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > > > On Fri, Jun 22, 2012 at 05:14:40PM +0100, Stefano Stabellini wrote:
> > > > > Fix the shared_info and vcpu_info struct definitions to match the ones
> > > > > in Xen.
> > > > 
> > > > Is there a corresponding c/s in the Xen tree for this?
> > > 
> > > That's the problem: arch_vcpu_info and arch_shared_info haven't been
> > > defined in Xen yet on ARM.
> > 
> > Strictly speaking they are defined (in xen/include/public/arch-arm.h),
> > they are just empty ;-)
> > 
> > > I think the ones below have been copied from xen/x86 by mistake.
> > 
> > Yes, it does look that way.
> 
> Ah, pls mention that in the git commit description.

OK, see below.

I am not sending out a second version of this patch series because I
still consider it a work in progress.
I'll send out a new up-to-date patch series with all the fixes as soon
as I have it.


---

xen/arm: fix the shared_info and vcpu_info structs

Fix the shared_info and vcpu_info struct definitions to match the ones
in Xen: the current arch_vcpu_info and arch_shared_info have been copied
from x86 by mistake (the Xen version of these structs are just empty).

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/arm/include/asm/xen/interface.h b/arch/arm/include/asm/xen/interface.h
index 3ad2d4b..8ab7cebb 100644
--- a/arch/arm/include/asm/xen/interface.h
+++ b/arch/arm/include/asm/xen/interface.h
@@ -40,19 +40,10 @@ DEFINE_GUEST_HANDLE(xen_pfn_t);
 #endif
 
 /* Maximum number of virtual CPUs in multi-processor guests. */
-#define MAX_VIRT_CPUS 32
+#define MAX_VIRT_CPUS 1
 
-struct arch_vcpu_info {
-    unsigned long cr2;
-    unsigned long pad; /* sizeof(vcpu_info_t) == 64 */
-};
-
-struct arch_shared_info {
-    unsigned long max_pfn;                  /* max pfn that appears in table */
-    /* Frame containing list of mfns containing list of mfns containing p2m. */
-    unsigned long pfn_to_mfn_frame_list_list;
-    unsigned long nmi_reason;
-};
+struct arch_vcpu_info { };
+struct arch_shared_info { };
 
 /* XXX: Move pvclock definitions some place arch independent */
 struct pvclock_vcpu_time_info {
