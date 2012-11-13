Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab2KMT7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:59:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47734 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2KMT7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:59:41 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1211131707380.28049@kaball.uk.xensource.com>
References: <20121112193044.GA11615@phenom.dumpdata.com>
	<1352755122-25660-1-git-send-email-yinghai@kernel.org>
	<1352755122-25660-22-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1211131707380.28049@kaball.uk.xensource.com>
Date: Tue, 13 Nov 2012 11:59:40 -0800
X-Google-Sender-Auth: LdVMLHUxWFonFUqtVFLC8zOCp-c
Message-ID: <CAE9FiQU1HGyw8ZLu8KdmR3ikyZ=YTG+8dUoDAVbO4Bc1hEPPgQ@mail.gmail.com>
Subject: Re: [PATCH 21/46] x86, mm: setup page table in top-down
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 9:26 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Mon, 12 Nov 2012, Yinghai Lu wrote:
>> Get pgt_buf early from BRK, and use it to map PMD_SIZE from top at first.
>> Then use mapped pages to map more ranges below, and keep looping until
>> all pages get mapped.
>>
>> alloc_low_page will use page from BRK at first, after that buffer is used
>> up, will use memblock to find and reserve pages for page table usage.
>>
>> Introduce min_pfn_mapped to make sure find new pages from mapped ranges,
>> that will be updated when lower pages get mapped.
>>
>> Also add step_size to make sure that don't try to map too big range with
>> limited mapped pages initially, and increase the step_size when we have
>> more mapped pages on hand.
>>
>> At last we can get rid of calculation and find early pgt related code.
>>
>> -v2: update to after fix_xen change,
>>      also use MACRO for initial pgt_buf size and add comments with it.
>> -v3: skip big reserved range in memblock.reserved near end.
>> -v4: don't need fix_xen change now.
>>
>> Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> The changes to alloc_low_page and early_alloc_pgt_buf look OK to me.
>
> The changes to init_mem_mapping are a bit iffy but they aren't too
> unreasonable.
> Overall the patch is OK even though I would certainly appreciate more
> comments and better variable names (real_end?), see below.

real_end is not good?

xen put big reserved range between real_end and end.

that real_end is some kind of end of real usable areas.

so change to real_usable_end  or usable_end?
