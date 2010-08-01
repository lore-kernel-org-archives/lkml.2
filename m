Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab0HAFWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 01:22:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20125 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab0HAFWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 01:22:36 -0400
Message-ID: <4C55041C.1030008@kernel.org>
Date: Sat, 31 Jul 2010 22:20:28 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org
Subject: Re: [PATCH] x86,setup: add serial_console_port_base in boot_params
References: <4C3F8B46.7080809@kernel.org> <20100731083409.GC5859@lenovo>	<4C5469AF.2010608@zytor.com> <20100731183211.GB29357@lenovo>	<4C548F7D.6000509@zytor.com> <4C54D3AD.8020906@kernel.org> <m14offuk8p.fsf@fess.ebiederm.org>
In-Reply-To: <m14offuk8p.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C550468.0161,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2010 07:42 PM, Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
>> On 07/31/2010 02:02 PM, H. Peter Anvin wrote:
>>> On 07/31/2010 11:32 AM, Cyrill Gorcunov wrote:
>>>>>
>>>>> No, this is the internal part of the boot protocol, so it's not an issue.
>>>>>
>>>>
>>>> Peter, I didn't mean any issue here, I meant that bootloaders don't know about
>>>> this field yet and they will have to update own sources to pass port value
>>>> at proper place of boot params. Or I miss something?
>>>>
>>>
>>> Boot loaders that use the 16-bit entry point are unaffected.
>>>
>>> Boot loaders which use the 32-bit entry point but properly clears the
>>> zero page simply will not have the feature.
>>>
>>> Boot loaders which use the 32-bit entry point but doesn't clear the zero
>>> page are broken.
>>>
>> can you if this one is right for kexec path?
> 
> I am walking out the door, but this seems like nonsense to me.
> 
> Further I don't see why we would add something to the zero page
> when we have a perfectly good way to pass this information via
> the kernel command line.  strstr and strtoul are trivial little
> functions so I don't see why anything would need to parse anything
> other than console= or early_printk=.  The difference in code size
> is negligible.
> 
so you prefer to check command line for console info in arch/x86/boot/compressed/misc.c again?

that commandline is analyzed in arch/x86/boot/tty.c already.

Yinghai
