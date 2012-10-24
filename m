Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab2JXIKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:10:50 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab2JXIKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:10:46 -0400
Message-ID: <5087A285.4030305@nod.at>
Date: Wed, 24 Oct 2012 10:10:45 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Matthew Leach <matthew@mattleach.net>
CC: linux-kernel@vger.kernel.org,
        =?UTF-8?B?TWFydGluIFDDpHJ0ZWw=?= <martin.partel@gmail.com>
Subject: Re: [REGRESSION] uml: signal.c build errors
References: <87pq48lqut.fsf@mattleach.net> <5087A203.4060505@nod.at>
In-Reply-To: <5087A203.4060505@nod.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.10.2012 10:08, Richard Weinberger wrote:
> On 24.10.2012 01:18, Matthew Leach wrote:
>> Hi,
>>
>> When building UML against 3.7-rc2 I encounter the following build error:
>>
>> # make ARCH=uml
>> scripts/kconfig/conf --silentoldconfig arch/x86/um/Kconfig
>>    CHK     include/generated/uapi/linux/version.h
>>    UPD     include/generated/uapi/linux/version.h
>>    WRAP    arch/um/include/generated/asm/clkdev.h
>>    SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_32.h
>>    SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_64.h
>>    SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_x32.h
>>
>> ...
>>
>>    CC      arch/um/os-Linux/signal.o
>> arch/um/os-Linux/signal.c:18:8: error: conflicting types for ‘sig_info’
>> In file included from arch/um/os-Linux/signal.c:12:0:
>> /home/matthew/Development/linux/arch/um/include/shared/as-layout.h:64:15: note: previous declaration of ‘sig_info’ was
>> here
>> arch/um/os-Linux/signal.c:19:2: warning: initialization from incompatible pointer type [enabled by default]
>> arch/um/os-Linux/signal.c:19:2: warning: (near initialization for ‘sig_info[5]’) [enabled by default]
>> arch/um/os-Linux/signal.c:20:2: warning: initialization from incompatible pointer type [enabled by default]
>> arch/um/os-Linux/signal.c:20:2: warning: (near initialization for ‘sig_info[8]’) [enabled by default]
>> arch/um/os-Linux/signal.c:21:2: warning: initialization from incompatible pointer type [enabled by default]
>> arch/um/os-Linux/signal.c:21:2: warning: (near initialization for ‘sig_info[4]’) [enabled by default]
>> arch/um/os-Linux/signal.c:22:2: warning: initialization from incompatible pointer type [enabled by default]
>> arch/um/os-Linux/signal.c:22:2: warning: (near initialization for ‘sig_info[28]’) [enabled by default]
>> arch/um/os-Linux/signal.c:23:2: warning: initialization from incompatible pointer type [enabled by default]
>> arch/um/os-Linux/signal.c:23:2: warning: (near initialization for ‘sig_info[7]’) [enabled by default]
>> arch/um/os-Linux/signal.c:24:2: warning: initialization from incompatible pointer type [enabled by default]
>> arch/um/os-Linux/signal.c:24:2: warning: (near initialization for ‘sig_info[11]’) [enabled by default]
>> arch/um/os-Linux/signal.c:25:2: warning: initialization from incompatible pointer type [enabled by default]
>> arch/um/os-Linux/signal.c:25:2: warning: (near initialization for ‘sig_info[29]’) [enabled by default]
>> arch/um/os-Linux/signal.c:26:2: warning: initialization from incompatible pointer type [enabled by default]
>> arch/um/os-Linux/signal.c:26:2: warning: (near initialization for ‘sig_info[26]’) [enabled by default]
>> arch/um/os-Linux/signal.c:133:1: warning: initialization from incompatible pointer type [enabled by default]
>> arch/um/os-Linux/signal.c:133:1: warning: (near initialization for ‘handlers[26]’) [enabled by default]
>> make[1]: *** [arch/um/os-Linux/signal.o] Error 1
>> make: *** [arch/um/os-Linux] Error 2
>>
>> I have tracked this down to [1] where, indeed, the type of sig_info is
>> different; the second parameter in signal.c is 'siginfo_t' where as in
>> as-layout.h the second parameter's type is declared as 'struct siginfo'.
>>
>> [1]: d3c1cfcdb43e023ab1b1c7a555cd9e929026500a
>
> Does this patch fix the issue?
> Are you using glibc 2.17?

If not, Martin, can you please convert your code to siginfo_t?
It looks like struct sig_info and siginfo_t are no longer compatible.

Thanks,
//richard
