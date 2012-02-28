Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab2B1DoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 22:44:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50141 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab2B1Dn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 22:43:59 -0500
Message-ID: <4F4C4D5C.70908@zytor.com>
Date: Mon, 27 Feb 2012 19:43:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] x86: Cleanup and simplify cpu-specific data
References: <1330041476-719-1-git-send-email-kjwinchester@gmail.com> <20120227115905.GB9943@elte.hu> <CAELBVzDQx-geNELEvHYheSL0hKbaXfUAvjperNcPELThT9bqWg@mail.gmail.com>
In-Reply-To: <CAELBVzDQx-geNELEvHYheSL0hKbaXfUAvjperNcPELThT9bqWg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 04:52 PM, Kevin Winchester wrote:
> On 27 February 2012 07:59, Ingo Molnar<mingo@elte.hu>  wrote:
>>
>> * Kevin Winchester<kjwinchester@gmail.com>  wrote:
>>
>>> Various per-cpu fields are define in arch/x86/kernel/smpboot.c
>>> that are basically equivalent to the cpu-specific data in
>>> struct cpuinfo_x86. By moving these fields into the structure,
>>> a number of codepaths can be simplified since they no longer
>>> need to care about those fields not existing on !SMP builds.
>>
>> Works mostly fine, except with the attached 32-bit UP !APIC
>> config I get various build failures (resolved via the patch
>> below) and a link failure (not resolved):
>>
>
> I get the following failure before I get to link time:
>
> In file included from
> /home/kevin/linux/linux-2.6/arch/x86/include/asm/uaccess.h:573:0,
>                   from
> /home/kevin/linux/linux-2.6/arch/x86/include/asm/sections.h:5,
>                   from
> /home/kevin/linux/linux-2.6/arch/x86/include/asm/hw_irq.h:26,
>                   from include/linux/irq.h:357,
>                   from
> /home/kevin/linux/linux-2.6/arch/x86/include/asm/hardirq.h:5,
>                   from include/linux/hardirq.h:7,
>                   from include/linux/interrupt.h:12,
>                   from net/core/pktgen.c:135:
> In function ‘copy_from_user’,
>      inlined from ‘pktgen_if_write’ at net/core/pktgen.c:877:20:
> /home/kevin/linux/linux-2.6/arch/x86/include/asm/uaccess_32.h:211:26:
> error: call to ‘copy_from_user_overflow’ declared with attribute
> error: copy_from_user() buffer size is not provably correct
> make[2]: *** [net/core/pktgen.o] Error 1
>
> On:
>
> gcc (GCC) 4.6.2 20120120 (prerelease)
>
> Is that my fault, or something else?
>
> Kevin
>

That comes from compiling with warnings as errors.  Not that someone 
shouldn't look at that kind of problem.

	-hpa

