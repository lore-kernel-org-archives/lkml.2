Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935528Ab2JXUGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:06:42 -0400
Received: from woodbine.london.02.net ([87.194.255.145]:40860 "EHLO
	woodbine.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935427Ab2JXUGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:06:40 -0400
From: Matthew Leach <matthew@mattleach.net>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org,
        Martin =?utf-8?Q?P=C3=A4rtel?= <martin.partel@gmail.com>
Subject: Re: [REGRESSION] uml: signal.c build errors
References: <87pq48lqut.fsf@mattleach.net>
	<20121024213919.5543e90b@spider.haslach.nod.at>
	<87objr3b2z.fsf@mattleach.net>
	<20121024215445.04d53d0d@spider.haslach.nod.at>
Date: Wed, 24 Oct 2012 21:06:25 +0100
In-Reply-To: <20121024215445.04d53d0d@spider.haslach.nod.at> (Richard
	Weinberger's message of "Wed, 24 Oct 2012 21:54:45 +0200")
Message-ID: <87hapj3a9q.fsf@mattleach.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:
> Am Wed, 24 Oct 2012 20:48:52 +0100
> schrieb Matthew Leach <matthew@mattleach.net>:
>
>> 
>> Richard Weinberger <richard@nod.at> writes:
>> > Am Wed, 24 Oct 2012 00:18:34 +0100
>> >> I have tracked this down to [1] where, indeed, the type of
>> >> sig_info is different; the second parameter in signal.c is
>> >> 'siginfo_t' where as in as-layout.h the second parameter's type is
>> >> declared as 'struct siginfo'.
>> >> 
>> >> [1]: d3c1cfcdb43e023ab1b1c7a555cd9e929026500a
>> >
>> > Looks like we have to revert that commit.
>> > Moving everything to siginfo_t requires a non-trivial header cleanup
>> > and may introduce new regressions.
>> >
>> > Matthew, does the attached revert patch help?
>> 
>> The revert did remove the errors for the compilation of signal.c, so
>> that seems fine. I still get the following errors, however:
>> 
>>   CC      arch/um/os-Linux/sigio.o
>>   CC      arch/um/os-Linux/signal.o
>>   CC      arch/um/os-Linux/start_up.o
>> arch/um/os-Linux/start_up.c: In function ‘check_coredump_limit’:
>> arch/um/os-Linux/start_up.c:338:16: error: storage size of ‘lim’
>> isn’t known arch/um/os-Linux/start_up.c:339:2: error: implicit
>> declaration of function
>> ‘getrlimit’ [-Werror=implicit-function-declaration]
>> arch/um/os-Linux/start_up.c:339:22: error: ‘RLIMIT_CORE’ undeclared
>> (first use in this function) arch/um/os-Linux/start_up.c:339:22:
>> note: each undeclared identifier is reported only once for each
>> function it appears in arch/um/os-Linux/start_up.c:347:22: error:
>> ‘RLIM_INFINITY’ undeclared (first use in this function)
>> arch/um/os-Linux/start_up.c:338:16: warning: unused variable
>> ‘lim’ [-Wunused-variable] cc1: some warnings being treated as errors
>> make[1]: *** [arch/um/os-Linux/start_up.o] Error 1 make: ***
>> [arch/um/os-Linux] Error 2
>
> Does adding
> #include <sys/time.h>
> #include <sys/resource.h>
>
> to arch/um/os-Linux/start_up.c help?

Adding the above includes and the revert commit did the trick!

Thanks,
matt
