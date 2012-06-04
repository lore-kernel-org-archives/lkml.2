Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761151Ab2FDXJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 19:09:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab2FDXJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 19:09:30 -0400
Message-ID: <4FCD401D.9000304@redhat.com>
Date: Mon, 04 Jun 2012 19:09:17 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: iommu@lists.linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, chrisw@redhat.com,
        suresh.b.siddha@intel.com
Subject: Re: [PATCH 2/2] iommu: dmar -- reserve mmio space used by IOMMU
References: <1338845342-12464-1-git-send-email-ddutile@redhat.com>	 <1338845342-12464-3-git-send-email-ddutile@redhat.com> <1338849430.10884.288.camel@shinybook.infradead.org>
In-Reply-To: <1338849430.10884.288.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 06:37 PM, David Woodhouse wrote:
> On Mon, 2012-06-04 at 17:29 -0400, Donald Dutile wrote:
>> Intel-iommu initialization doesn't currently reserve the memory used
>> for the IOMMU registers. This can allow the pci resource allocator
>> to assign a device BAR to the same address as the IOMMU registers.
>> This can cause some not so nice side affects when the driver
>> ioremap's that region.
>
> s/affect/effect/
>
ok.

> And surely this can happen even when IOMMU support is compiled out of
> the kernel. Shouldn't the BIOS be *telling* us that this region is
> unavailable for PCI resource allocation (or anything else, for that
> matter)?
>
good point....

> If the BIOS *doesn't* do that, then I believe this should be
> WARN_TAINT_ONCE(…TAINT_FIRMWARE_WORKAROUND…) like other BIOS problems
> that we have discovered.
>
well, one could argue it may be easier to claim the space reserved in
the OS then making yet another hole in the available IO address space
in the ACPI tables.  Although I think the workarounds more systems
implement is to stick the IOMMUs into an existing hole to avoid this problem.

> And we should probably do it based on the actual chipset registers, not
> the DMAR tables (which the BIOS has also been known to lie about).
>
but.... the DMAR tables are the source of all information.... wise and ... er, um... ;-)
yes, I've been on the receiving side of more bz's wrt bad DMAR tables then I can count,
but...

How does the kernel probe for chipsets, then registers with the chipsets
to find the programmed IOMMU BAR values?
-- I missed that class.... I only have Intel Virt Tech Directed I/O
Architecture spec., and the beginning of IOMMU is based on DMAR tables...
If you have more info/guidance, I'd appreciate it.

Seems like the patch would be easier to support, although it doesn't
solve the problem you mentioned above, unless the reservation code isn't
compiled out by INTEL-IOMMU (but something more general like !(x86 && PCI)).
the firmware taint message would be informative as to the quality of
the firmware, but my experience is nothing changes unless it's critical
to a system shipping.

IMO, if we can avoid a BIOS problem, we should.
The empirical data I've gathered so far in this space
(IOMMU, use by SRIOV VF devices), shows the BIOS has numerous
weaknesses, and this is yet another one.  The BIOS's are getting better,
but I've seen turtles run faster... ;-) .


