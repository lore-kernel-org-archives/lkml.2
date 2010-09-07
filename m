Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab0IGTJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:09:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45322 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab0IGTJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 7 Sep 2010 15:09:29 -0400
Date: Tue, 7 Sep 2010 15:07:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tony Luck <tony.luck@intel.com>
Cc: hpa@zytor.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Len Brown <len.brown@intel.com>, Chris Wright <chrisw@sous-sol.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 09/10] x86/VT-d: Make Intel VT-d IOMMU use IOMMU_INIT_*
 macros.
Message-ID: <20100907190729.GA6668@dumpdata.com>
References: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
 <1282845485-8991-10-git-send-email-konrad.wilk@oracle.com>
 <AANLkTikcdyNP8x28u3-m0oNcOqSek=xwUn3wW-=3sqnY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTikcdyNP8x28u3-m0oNcOqSek=xwUn3wW-=3sqnY@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 11:10:30AM -0700, Tony Luck wrote:
> On Thu, Aug 26, 2010 at 10:58 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > We utilize the IOMMU_INIT macros to create this dependency:
> ...
> >  drivers/pci/dmar.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
> > index 5fa64ea..4ef56a0 100644
> > --- a/drivers/pci/dmar.c
> > +++ b/drivers/pci/dmar.c
> > @@ -36,6 +36,7 @@
> >  #include <linux/tboot.h>
> >  #include <linux/dmi.h>
> >  #include <linux/slab.h>
> > +#include <asm/iommu_table.h>
> 
> This breaks ia64 - since you didn't make an asm/iommu_table.h for it :-(

Oh no! Well, perhaps moving it to a wider audience is the right thing..
But for right now let me be a bit conservative.
> 
> Just copying the x86 one led to complaints about pci_swiotlb_detect_4gb()
> not being declared ... so I think I need a bit more of the same infrastructure
> you made of x86.

Under ia64 you only have to IOMMUs right? DMAR and SWIOTLB?

If you do this patch it should compile fine, let me think a bit about
how to make the iommu_* pieces platform-agnostic.

>From 863a8f5f2ef36f0ceafbee046766b0e484f64a13 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad@dumpdata.com>
Date: Tue, 7 Sep 2010 15:01:45 -0400
Subject: [PATCH] ia64/iommu: Add a dummy iommu_table.h file in IA64.

We don't need a comlex IOMMU dependency list on IA64 so
we just define the IOMMU_* macro as a dummy.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/ia64/include/asm/iommu_table.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)
 create mode 100644 arch/ia64/include/asm/iommu_table.h

diff --git a/arch/ia64/include/asm/iommu_table.h b/arch/ia64/include/asm/iommu_table.h
new file mode 100644
index 0000000..6793601
--- /dev/null
+++ b/arch/ia64/include/asm/iommu_table.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_X86_IOMMU_TABLE_H
+#define _ASM_X86_IOMMU_TABLE_H
+
+#define IOMMU_INIT_POST(_detect)
+
+#endif /* _ASM_X86_IOMMU_TABLE_H */
-- 
1.7.0.4

