Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0HCCDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 22:03:21 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51443 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab0HCCDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 22:03:19 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org
Subject: Re: [PATCH] x86,setup: add serial_console_port_base in boot_params
References: <4C3F8B46.7080809@kernel.org> <20100731083409.GC5859@lenovo>
	<4C5469AF.2010608@zytor.com> <20100731183211.GB29357@lenovo>
	<4C548F7D.6000509@zytor.com> <4C54D3AD.8020906@kernel.org>
	<m14offuk8p.fsf@fess.ebiederm.org> <4C55041C.1030008@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 02 Aug 2010 19:03:04 -0700
In-Reply-To: <4C55041C.1030008@kernel.org> (Yinghai Lu's message of "Sat\, 31 Jul 2010 22\:20\:28 -0700")
Message-ID: <m18w4o4fmv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 07/31/2010 07:42 PM, Eric W. Biederman wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>> 
>>> On 07/31/2010 02:02 PM, H. Peter Anvin wrote:
>>>> On 07/31/2010 11:32 AM, Cyrill Gorcunov wrote:
>>>>>>
>>>>>> No, this is the internal part of the boot protocol, so it's not an issue.
>>>>>>
>>>>>
>>>>> Peter, I didn't mean any issue here, I meant that bootloaders don't know about
>>>>> this field yet and they will have to update own sources to pass port value
>>>>> at proper place of boot params. Or I miss something?
>>>>>
>>>>
>>>> Boot loaders that use the 16-bit entry point are unaffected.
>>>>
>>>> Boot loaders which use the 32-bit entry point but properly clears the
>>>> zero page simply will not have the feature.
>>>>
>>>> Boot loaders which use the 32-bit entry point but doesn't clear the zero
>>>> page are broken.
>>>>
>>> can you if this one is right for kexec path?
>> 
>> I am walking out the door, but this seems like nonsense to me.
>> 
>> Further I don't see why we would add something to the zero page
>> when we have a perfectly good way to pass this information via
>> the kernel command line.  strstr and strtoul are trivial little
>> functions so I don't see why anything would need to parse anything
>> other than console= or early_printk=.  The difference in code size
>> is negligible.
>> 
> so you prefer to check command line for console info in arch/x86/boot/compressed/misc.c again?
>
> that commandline is analyzed in arch/x86/boot/tty.c already.

Instead of changing 2 or 3 bootloaders, waiting years for the change
to propagate, and then trying to change users habits.

I definitely do.

Eric
