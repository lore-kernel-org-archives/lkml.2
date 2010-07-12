Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab0GLQYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:24:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55949 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0GLQYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:24:42 -0400
Message-ID: <4C3B40F3.6070009@kernel.org>
Date: Mon, 12 Jul 2010 09:21:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Setup early console as early as possible
References: <4C3A3B27.7020009@oracle.com> <4C3AD94C.7070807@cs.helsinki.fi> <4C3B38F7.1050400@zytor.com>
In-Reply-To: <4C3B38F7.1050400@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C3B418F.00FC,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 08:47 AM, H. Peter Anvin wrote:
> On 07/12/2010 01:58 AM, Pekka Enberg wrote:
>> Hi Yinghai,
>>
>> Yinghai Lu wrote:
>>> Analyze "console=uart8250,io,0x3f8,115200n8" in
>>> i386_start_kernel/x86_64_start_kernel,
>>> and call setup_early_serial8250_console() to init early serial console.
>>>
>>> only can handle io port kind of 8250. because mmio need ioremap.
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> What's the purpose of this patch? Does it make my early boot I/O patch
>> obsolete?
>>
>>             Pekka
> 
> No, they're complementary.  Your patch serial-port enables the RM
> kernel, whereas Yinghai pushes the initialization earlier in the PM kernel.

yes. cover more range.

Can you consider to ask Pekka to anaylze "console=uart8250,io, 0x3f8,115200n8" instead?

it looks like we can remove "earlyprintk=ttyS0,115200", or "earlyprintk=serial" etc.

earlycon=uart8250 or console=uart8250 should be better than earlyprintk.
because it is shared between different archs already.

> 
> Incidentally, Yinghai: it would be possible to push even an MMIO
> reference earlier by reserving a fixmap slot for the early console.  I'm
> not sure if it's worth it, though.

in setup_arch() for x86, now we have

        /* VMI may relocate the fixmap; do this before touching ioremap area */
        vmi_init();

        /* OFW also may relocate the fixmap */
        olpc_ofw_detect();

        early_trap_init();
        early_cpu_init();
        early_ioremap_init()

so may need to move these 
	vmi_init()
	olpc_ofw_detect()
	early_ioremap_init()

to i386_start_kernel(), x86_start_kernel()

may be not worth it at this time, could do that later if needed.

Thanks

Yinghai
