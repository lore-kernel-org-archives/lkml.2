Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0ECRxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 13:53:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23349 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab0ECRxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 13:53:08 -0400
Message-ID: <4BDF0CF1.5070006@oracle.com>
Date: Mon, 03 May 2010 10:50:41 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, trenn@suse.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.31.13] Build failure at arch/x86/kernel/apic/io_apic.c
References: <201004120230.o3C2UhfQ050532@www262.sakura.ne.jp> <20100412024446.GA28141@suse.de> <201004120410.o3C4Axwe066941@www262.sakura.ne.jp> <20100501180715.GA7745@suse.de> <4BDF04D6.7040003@oracle.com> <20100503174422.GC11676@suse.de>
In-Reply-To: <20100503174422.GC11676@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090209.4BDF0D7D.00F7:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2010 10:44 AM, Greg KH wrote:
> On Mon, May 03, 2010 at 10:16:06AM -0700, Yinghai wrote:
>> On 05/01/2010 11:07 AM, Greg KH wrote:
>>> On Mon, Apr 12, 2010 at 01:10:59PM +0900, Tetsuo Handa wrote:
>>>> Commit d539e5576605d048e6aeb21cbe3a8e71dc5eea81 "x86: Fix SCI on IOAPIC != 0"
>>>> introduced "void setup_IO_APIC_irq_extra(u32 gsi)" which calls
>>>> mp_find_ioapic() and mp_find_ioapic_pin().
>>>>
>>>> This commit does not compile if CONFIG_X86_IO_APIC=y and CONFIG_ACPI=n .
>>>
>>> Why would you want to build without ACPI on any modern system?  Anyway,
>>> have a fix for this?
>>>
>> maybe just put #ifdef CONFIG_ACPI around the callee etc?
> 
> Ick.  How was it solved upstream?
> 

those two functions are moved to arch/x86/kernel/apic/io_apic.c

maybe you can put that patch to 2.6.31.xx?

YH

commit 2a4ab640d3c28c2952967e5f63ea495555bf2a5f
Author: Feng Tang <feng.tang@intel.com>
Date:   Tue Jul 7 23:01:15 2009 -0400

    ACPI, x86: expose some IO-APIC routines when CONFIG_ACPI=n
    
    Some IO-APIC routines are ACPI specific now, but need to
    be exposed when CONFIG_ACPI=n for the benefit of SFI.
    
    Remove #ifdef ACPI around these routines:
    
    io_apic_get_unique_id(int ioapic, int apic_id);
    io_apic_get_version(int ioapic);
    io_apic_get_redir_entries(int ioapic);
    
    Move these routines from ACPI-specific boot.c to io_apic.c:
    
    uniq_ioapic_id(u8 id)
    mp_find_ioapic()
    mp_find_ioapic_pin()
    mp_register_ioapic()
    
    Also, since uniq_ioapic_id() is now no longer static,
    re-name it to io_apic_unique_id() for consistency
    with the other public io_apic routines.
    
    For simplicity, do not #ifdef the resulting code ACPI || SFI,
    thought that could be done in the future if it is important
    to optimize the !ACPI !SFI IO-APIC x86 kernel for size.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
    Cc: x86@kernel.org

