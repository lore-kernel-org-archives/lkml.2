Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2I0IWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:22:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33081 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2I0IWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:22:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120913150001.GA779@jshin-Toonie>
References: <1346823991-22911-1-git-send-email-yinghai@kernel.org>
	<20120905200815.GA2457@jshin-Toonie>
	<20120913150001.GA779@jshin-Toonie>
Date: Thu, 27 Sep 2012 01:22:19 -0700
X-Google-Sender-Auth: w-7WmQ9Qd8kgOw2iPR2vg-LhTko
Message-ID: <CAE9FiQXTz80xK-op4VH9r8kau+3pH58JuT_rmMNaJbehrmOO9w@mail.gmail.com>
Subject: Re: [PATCH -v3 00/14] x86, mm: init_memory_mapping cleanup
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 8:00 AM, Jacob Shin <jacob.shin@amd.com> wrote:
> On Wed, Sep 05, 2012 at 03:08:15PM -0500, Jacob Shin wrote:
>> On Tue, Sep 04, 2012 at 10:46:17PM -0700, Yinghai Lu wrote:
>> > Only create mapping for E820_820 and E820_RESERVED_KERN.
>> >
>> > Seperate calculate_table_space_size and find_early_page_table out with
>> > init_memory_mapping.
>> >
>> > For all ranges, will allocate page table one time, but init mapping
>> > only for E820 RAM and E820_RESERVED_KERN.
>> >
>> > Could be found at:
>> > git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm
>> >
>> > Thanks
>> >         Yinghai
>> >
>> >
>> > Jacob Shin (4):
>> >   x86: if kernel .text .data .bss are not marked as E820_RAM, complain and fix
>> >   x86: Fixup code testing if a pfn is direct mapped
>> >   x86: Only direct map addresses that are marked as E820_RAM
>> >   x86/mm: calculate_table_space_size based on memory ranges that are being mapped
>> >
>> > Yinghai Lu (10):
>> >   x86, mm: Add global page_size_mask
>> >   x86, mm: Split out split_mem_range
>> >   x86, mm: Moving init_memory_mapping calling
>> >   x86, mm: Revert back good_end setting for 64bit
>> >   x86, mm: Find early page table only one time
>> >   x86, mm: Separate out calculate_table_space_size()
>> >   x86, mm: Move down two calculate_table_space_size down.
>> >   x86, mm: set memblock initial limit to 1M
>> >   x86, mm: Use func pointer to table size calculation and mapping
>> >   x86, mm: Map ISA area with connected ram range at the same time
>> >
>> >  arch/x86/include/asm/init.h       |    1 -
>> >  arch/x86/include/asm/page_types.h |    2 +
>> >  arch/x86/include/asm/pgtable.h    |    1 +
>> >  arch/x86/kernel/cpu/amd.c         |    8 +-
>> >  arch/x86/kernel/setup.c           |   36 +++--
>> >  arch/x86/mm/init.c                |  357 +++++++++++++++++++++++++------------
>> >  arch/x86/mm/init_64.c             |    6 +-
>> >  arch/x86/platform/efi/efi.c       |    8 +-
>> >  8 files changed, 280 insertions(+), 139 deletions(-)
>> >
>> > --
>> > 1.7.7
>> >
>> >
>>
>> Tested -v3 on our (AMD) machines and everything looks good.
>
> Hi, hpa, wondering if this version finally looks okay to you for 3.7 ?
>

Can you please put patch 1-13 into tip?

Thanks

Yinghai
