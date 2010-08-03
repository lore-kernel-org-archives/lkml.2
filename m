Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab0HCJKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:10:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44209 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab0HCJKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:10:34 -0400
Message-ID: <4C57DCCF.4000202@kernel.org>
Date: Tue, 03 Aug 2010 02:09:35 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3] x86: Setup early console as early as possible
References: <4C56701B.1030000@kernel.org>	<20100802150958.GA5544@lenovo>	<4C571B25.3080806@kernel.org>	<20100802201750.GG5544@lenovo>	<4C57C1DE.9050400@kernel.org> <20100803020638.4e2177c3.akpm@linux-foundation.org>
In-Reply-To: <20100803020638.4e2177c3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C57DCD3.006A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 02:06 AM, Andrew Morton wrote:
> On Tue, 03 Aug 2010 00:14:38 -0700 Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>
>> Analyze "console=uart8250,io,0x3f8,115200n8" in i386_start_kernel/x86_64_start_kernel,
>> and call setup_early_serial8250_console() to init early serial console.
>>
>> only can handle io port kind of 8250. because mmio need ioremap.
>>
>> -v2: use boot_params.hdr.version instead of adding another variable, Suggested by hpa
>>      update after using x86 memblock patchset
>> -v3: x86 memblock can not make into with 2.6.36 now
>>      so update this patch to be applied before x86 memblock patchset again.
>>
>> ...
>>
>> --- linux-2.6.orig/kernel/printk.c
>> +++ linux-2.6/kernel/printk.c
>> @@ -1203,6 +1203,10 @@ void register_console(struct console *ne
>>  	if (console_drivers && newcon->flags & CON_BOOT) {
>>  		/* find the last or real console */
>>  		for_each_console(bcon) {
>> +			/* not again */
>> +			if (bcon == newcon)
>> +				return;
>> +
>>  			if (!(bcon->flags & CON_BOOT)) {
>>  				printk(KERN_INFO "Too late to register bootconsole %s%d\n",
> 
> Why this change?

it seems register the same console as early console will dead loop.

let me double check that again to see if can remove that change.

Yinghai
