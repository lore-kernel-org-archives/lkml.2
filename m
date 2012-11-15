Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768866Ab2KOT2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 14:28:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36034 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768796Ab2KOT2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 14:28:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQU3PM+2=Kt8XwAe6OuVMJUvRzimnfp3MEJgZi+EJMbXHw@mail.gmail.com>
References: <20121112193044.GA11615@phenom.dumpdata.com>
	<1352755122-25660-1-git-send-email-yinghai@kernel.org>
	<1352755122-25660-22-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1211131707380.28049@kaball.uk.xensource.com>
	<CAE9FiQU1HGyw8ZLu8KdmR3ikyZ=YTG+8dUoDAVbO4Bc1hEPPgQ@mail.gmail.com>
	<50A2A706.1090608@zytor.com>
	<CAE9FiQU3PM+2=Kt8XwAe6OuVMJUvRzimnfp3MEJgZi+EJMbXHw@mail.gmail.com>
Date: Thu, 15 Nov 2012 11:28:00 -0800
X-Google-Sender-Auth: zvp8FSQcdrhlMoNMsoC8r59QBKI
Message-ID: <CAE9FiQX=oRbqVCDyBALDoiQWHh=544r-PAcuwV075Ei3S8THwQ@mail.gmail.com>
Subject: Re: [PATCH 21/46] x86, mm: setup page table in top-down
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 12:36 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Nov 13, 2012 at 12:01 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 11/13/2012 11:59 AM, Yinghai Lu wrote:
>>>>
>>>> The changes to init_mem_mapping are a bit iffy but they aren't too
>>>> unreasonable.
>>>> Overall the patch is OK even though I would certainly appreciate more
>>>> comments and better variable names (real_end?), see below.
>>>
>>> real_end is not good?
>>>
>>> xen put big reserved range between real_end and end.
>>>
>>> that real_end is some kind of end of real usable areas.
>>>
>>> so change to real_usable_end  or usable_end?
>>>
>>
>> A description of a variable that includes the words "some kind of"
>> clearly indicates major confusion.  We need to know what the semantics
>> are, here.
>
> originally, we map range in this sequence:
> 1. map [0, 1M],
> 2. map 2M near max_pfn. and end is max_pfn<<PAGE_SHIFT
> 3. use new mapped area, to map low range.
> 4. change step size if more ram get mapped.
> 5. goto 3, until reach 1M.
>
> now for xen, there is big chunk range under max_pfn and they are reserved
> in memblock.reserved.
> so even we map them, we still can not use them for page table.
>
> so 2 become:
> 2a. find real_end under max_pfn that we can use it for page table
> 2b, map [real_end - 2M, real_end)
>
> and need to add
> 6. map [real_end, max_pfn<<PAGE_SHIFT)

hi, peter,

I updated for-x86-mm branch at
	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-mm

with updated changlog and acked-by from Stefano for some patches.
