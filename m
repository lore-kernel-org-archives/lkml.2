Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2KMR46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:56:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34796 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab2KMR45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:56:57 -0500
Message-ID: <50A289BB.5030009@zytor.com>
Date: Tue, 13 Nov 2012 09:56:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 28/46] x86, mm: Add pointer about Xen mmu requirement
 for alloc_low_pages
References: <20121112193044.GA11615@phenom.dumpdata.com> <1352755122-25660-1-git-send-email-yinghai@kernel.org> <1352755122-25660-29-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1211131638060.28049@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1211131638060.28049@kaball.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 08:38 AM, Stefano Stabellini wrote:
> On Mon, 12 Nov 2012, Yinghai Lu wrote:
>> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>
>> Add link to commit 279b706 for more information
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ah, here it is, OK then
>
>>   arch/x86/mm/init.c |    5 +++++
>>   1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
>> index f5e0120..a7939ed 100644
>> --- a/arch/x86/mm/init.c
>> +++ b/arch/x86/mm/init.c
>> @@ -25,6 +25,11 @@ unsigned long __meminitdata pgt_buf_top;
>>
>>   static unsigned long min_pfn_mapped;
>>
>> +/*
>> + * Pages returned are already directly mapped.
>> + *
>> + * Changing that is likely to break Xen, see commit 279b706 for detail info.
>                                                                      ^detailed
>

When making references to git commits, please include the title of the 
commit:

  *
  * Changing that is likely to break Xen, see commit:
  *
  *    279b706 x86,xen: introduce x86_init.mapping.pagetable_reserve
  *
  * for detailed information.

Otherwise it might be very confusing if we have an abbreviated hash 
collision or end up having to change git to use another hash system.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

