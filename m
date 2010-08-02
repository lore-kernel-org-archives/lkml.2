Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab0HBUbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:31:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18219 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab0HBUbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:31:46 -0400
Message-ID: <4C572AD9.5070500@kernel.org>
Date: Mon, 02 Aug 2010 13:30:17 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, setup: reorgize the early_console_setup
References: <4C56701B.1030000@kernel.org> <20100802150958.GA5544@lenovo> <4C571B25.3080806@kernel.org> <20100802201750.GG5544@lenovo>
In-Reply-To: <20100802201750.GG5544@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C572AFE.02D6,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 01:17 PM, Cyrill Gorcunov wrote:
> On Mon, Aug 02, 2010 at 12:23:17PM -0700, Yinghai Lu wrote:
>> On 08/02/2010 08:09 AM, Cyrill Gorcunov wrote:
>>> On Mon, Aug 02, 2010 at 12:13:31AM -0700, Yinghai Lu wrote:
>> So try to include string.c/printf.c/cmdline.c/early_serial_console.c in arch/x86/boot/compressed/misc.c
>> and analyze that command line again.
>>
>> then kexec path will get support too. that is from arch/x86/boot/compressed/head_32.S or head_64.S, startup_32.
>> and skip arch/x86/boot/main.c
>>
>> later with following patch for 3, we get all covered in c code.
>> 1. arch/x86/boot/main.c: setup code.
>> 2. arch/x86/boot/compressed/misc.c: decompress_kernel code : the 2 -v3 patches that i sent last night.
>> 3. arch/x86/kernel/head64.c: real kernel.
>>
>>
>> [PATCH -v2] x86: Setup early console as early as possible
>>
>> Analyze "console=uart8250,io,0x3f8,115200n8" in i386_start_kernel/x86_64_start_kernel,
>> and call setup_early_serial8250_console() to init early serial console.
>>
>> only can handle io port kind of 8250. because mmio need ioremap.
>>
>> -v2: use boot_params.hdr.version instead of adding another variable, Suggested by hpa
>>      update after using x86 memblock patchset
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---

> ...
>   
>> +	/* make sure if it is copied already */
>> +	if (boot_params.hdr.version)
>> +		return;
>> +
> 
> And Yinghai, lets be more verbose here a bit, since for those who will
> be reading this code later might be non-obvious why we have checked for
> 'version' here. I guess something like "an easy way to check if boot_params
> were already copied". Actually it's clean from commit message but I think
> we first read code comments and commit messages after, agreed? ;-)

will change to 

        /*
         * hdr.version is always not 0, so check it to see
         *  if boot_params is copied or not.
         */

will resend this patch after memblock x86 changes.

YH
