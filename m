Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777Ab0GUH3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 03:29:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51094 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762749Ab0GUH3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 03:29:35 -0400
Date: Wed, 21 Jul 2010 08:28:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "mel@csn.ul.ie" <mel@csn.ul.ie>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>, Tim HRM <zt.tmzt@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
	memory management
Message-ID: <20100721072837.GB6009@n2100.arm.linux.org.uk>
References: <20100714220536.GE18138@n2100.arm.linux.org.uk> <20100715012958.GB2239@codeaurora.org> <20100715085535.GC26212@n2100.arm.linux.org.uk> <AANLkTinVZeaZxt_lWKhjKa0dqhu3_j3BRNySO-2LvMdw@mail.gmail.com> <20100716075856.GC16124@n2100.arm.linux.org.uk> <4C449183.20000@codeaurora.org> <20100719184002.GA21608@n2100.arm.linux.org.uk> <bb667e285fd8be82ea8cc9cc25cf335b.squirrel@www.codeaurora.org> <20100720222952.GD10553@n2100.arm.linux.org.uk> <EAF47CD23C76F840A9E7FCE10091EFAB02C61C5FCA@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02C61C5FCA@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 11:19:58AM +0530, Shilimkar, Santosh wrote:
> > -----Original Message-----
> > From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-
> > kernel-bounces@lists.infradead.org] On Behalf Of Russell King - ARM Linux
> > Sent: Wednesday, July 21, 2010 4:00 AM
> > To: stepanm@codeaurora.org
> > Cc: linux-arch@vger.kernel.org; dwalker@codeaurora.org; mel@csn.ul.ie;
> > linux-arm-msm@vger.kernel.org; linux-kernel@vger.kernel.org; FUJITA
> > Tomonori; linux-mm@kvack.org; andi@firstfloor.org; Zach Pfeffer; Michael
> > Bohan; Tim HRM; linux-omap@vger.kernel.org; linux-arm-
> > kernel@lists.infradead.org; ebiederm@xmission.com
> > Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
> > memory management

*************************************************************************
> > This is difficult to achieve without remapping kernel memory using L2
> > page tables, so we can unmap pages on 4K page granularity.  That's
> > going to increase TLB overhead and result in lower system performance
> > as there'll be a greater number of MMU misses.
*************************************************************************

> > However, one obvious case would be to use highmem-only pages for
> > remapping - but you then have to ensure that those pages are never
> > kmapped in any way, because those mappings will fall into the same
> > unpredictable category that we're already trying to avoid.  This
> > may be possible, but you'll have to ensure that most of the system
> > RAM is in highmem - which poses other problems (eg, if lowmem gets
> > low.)
>
> Why can't we consider an option of removing the old mappings when 
> we need to create new ones with different attributes as suggested
> by Catalin on similar thread previously. This will avoid the duplicate
> mapping with different attributes issue on newer ARMs.

See the first paragraph which I've highlighted above.
