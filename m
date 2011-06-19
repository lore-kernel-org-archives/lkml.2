Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1FSXtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 19:49:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42271 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab1FSXti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 19:49:38 -0400
Message-ID: <4DFE89E0.5020509@zytor.com>
Date: Sun, 19 Jun 2011 16:44:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Petr Tesarik <ptesarik@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
References: <201106171038.25988.ptesarik@suse.cz> <20110617093032.GA19235@elte.hu> <4DFE7FF9.9070406@gmail.com>
In-Reply-To: <4DFE7FF9.9070406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2011 04:02 PM, Ryan Mallon wrote:
> On 17/06/11 19:30, Ingo Molnar wrote:
>> * Petr Tesarik<ptesarik@suse.cz>  wrote:
>>
>>> This patch series enhances /dev/mem, so that read and write is
>>> possible at any address. The patchset includes actual
>>> implementation for x86.
>> This series lacks a description of why this is desired.
>>
>> My strong opinion is that it's not desired at all: /dev/mem never
>> worked beyond 4G addresses so by today it has become largely obsolete
>> and is on the way out really.
>>
>> I'm aware of these current /dev/mem uses:
>>
>>   - Xorg maps below 4G non-RAM addresses and the video BIOS
>>
>>   - It used to have some debugging role but these days kexec and kgdb
>>     has largely taken over that role - partly due to the 4G limit.
>>
>>   - there's some really horrible out-of-tree drivers that do mmap()s
>>     via /dev/mem, those should be fixed if they want to move beyond
>>     4G: their char device should be mmap()able.
> 
> There are drivers where this makes sense. For example an FPGA device
> with a proprietary register layout on the memory bus can be done this
> way. The FPGA can simply be mapped in user-space via /dev/mem and
> handled there. If the device requires no access other than memory bus
> reads and writes then writing a custom char device driver just to get an
> mmap function seems a bit overkill.
> 

There are some test drivers which really want /dev/mem to work.

FPGA devices like that really should be exported as resources from a
platform driver or device tree driver, at which point those resources
can be memory-mapped.  That being said, using /dev/mem for fixed
resources is semicommon.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

