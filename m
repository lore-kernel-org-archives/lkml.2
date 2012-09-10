Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2IJKZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:25:20 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:52419 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242Ab2IJKZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:25:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120908101724.GB28448@n2100.arm.linux.org.uk>
References: <CADysL2YwpyuhgzwF6djObZQTpgdHCsLp=K7NsCJth6wAXuFV=A@mail.gmail.com>
	<20120908101724.GB28448@n2100.arm.linux.org.uk>
Date: Mon, 10 Sep 2012 15:55:17 +0530
Message-ID: <CADysL2YTmqrEbKfbqwGWaajWqHR7njViu=47zLh89rU76gq8Cg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] OMAP:IOMMU:flush L1 and L2 caches
From: "Gupta, Ramesh" <grgupta@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,


On Sat, Sep 8, 2012 at 3:47 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Jul 05, 2012 at 10:50:24AM +0530, Gupta, Ramesh wrote:
>>  static void flush_iopgd_range(u32 *first, u32 *last)
>>  {
>> -     /* FIXME: L2 cache should be taken care of if it exists */
>> -     do {
>> -             asm("mcr        p15, 0, %0, c7, c10, 1 @ flush_pgd"
>> -                 : : "r" (first));
>> -             first += L1_CACHE_BYTES / sizeof(*first);
>> -     } while (first <= last);
>> +     flush_iommu_mem(first, last);
>> +     outer_flush_range(virt_to_phys(first), virt_to_phys(last));
>
> I think this would be safer if these operated on an area rather than a
> range - which means taking a start plus size.
>
>         phys_addr_t phys = virt_to_phys(start);
>
>         iommu_flush_area(start, size);
>         outer_flush_range(phys, phys + size);
>
> is safer than the above if virt_to_phys() is non-linear.

Agree, I will use the area.

>
>>               *iopgd = virt_to_phys(iopte) | IOPGD_TABLE;
>> -             flush_iopgd_range(iopgd, iopgd);
>> +             flush_iopgd_range(iopgd, iopgd + 1);
>
> And operating on a start + size also makes this kind of stuff clearer.

Sure, I will cleanup this and send an updated patch series.


Thank you for the inputs.

Best regards
Ramesh Gupta G
