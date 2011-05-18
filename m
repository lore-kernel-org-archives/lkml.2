Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835Ab1ERDr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 23:47:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50536 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469Ab1ERDr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 23:47:57 -0400
Message-ID: <4DD3414B.2020602@zytor.com>
Date: Tue, 17 May 2011 20:47:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] x86/kernel/cpu/intel.c: Initialize Enhanced REP MOVSB/STOSBenhanced
References: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>    <1305671358-14478-3-git-send-email-fenghua.yu@intel.com> <ca1b13fa72e83adbc23b56e0cb28df7a.squirrel@www.firstfloor.org>
In-Reply-To: <ca1b13fa72e83adbc23b56e0cb28df7a.squirrel@www.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 07:46 PM, Andi Kleen wrote:
>> From: Fenghua Yu <fenghua.yu@intel.com>
>>
>> If kernel intends to use enhanced REP MOVSB/STOSB, it must ensure
>> IA32_MISC_ENABLE.Fast_String_Enable (bit 0) is set and CPUID.(EAX=07H,
>> ECX=0H):
>> EBX[bit 9] also reports 1.
> 
> I suspect the check at this place is not too useful because it will
> only work for the BSP. For all others it's too late -- the patching
> has already happened.
> 
> So either this is a problem and then it should be checked on all CPUs.
> Or maybe not at all.
> 
> The problem is that the alternative patching currently relies on being
> run early with no other CPUs. It has no race protections, support
> for cross modification etc.
> 
> While it would be possible to fix that it would be quite complicated
> I bet.
> 
> So I think it's better to just remove it unless it's a real problem
> in the field.
> 

The reason for having it is that if the BIOS has a chicken switch that
disables FAST_STRING (and it's the BIOS' responsibility to do it on all
CPUs) then this will make the kernel honor this.

	-hpa
