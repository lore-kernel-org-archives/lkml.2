Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab0ERUnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:43:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56900 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab0ERUnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:43:41 -0400
Message-ID: <4BF2FBE0.4090008@zytor.com>
Date: Tue, 18 May 2010 13:43:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/fpu] x86: Add new static_cpu_has() function using alternatives
References: <1273135546-29690-2-git-send-email-avi@redhat.com>	 <tip-a3c8acd04376d604370dcb6cd2143c9c14078a50@git.kernel.org> <1274213443.2485.3.camel@edumazet-laptop>
In-Reply-To: <1274213443.2485.3.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 01:10 PM, Eric Dumazet wrote:
> Le mercredi 12 mai 2010 à 01:06 +0000, tip-bot for H. Peter Anvin a
> écrit :
>> Commit-ID:  a3c8acd04376d604370dcb6cd2143c9c14078a50
>> Gitweb:     http://git.kernel.org/tip/a3c8acd04376d604370dcb6cd2143c9c14078a50
>> Author:     H. Peter Anvin <hpa@zytor.com>
>> AuthorDate: Tue, 11 May 2010 17:47:07 -0700
>> Committer:  H. Peter Anvin <hpa@zytor.com>
>> CommitDate: Tue, 11 May 2010 17:47:07 -0700
>>
>> x86: Add new static_cpu_has() function using alternatives
>>
>> For CPU-feature-specific code that touches performance-critical paths,
>> introduce a static patching version of [boot_]cpu_has().  This is run
>> at alternatives time and is therefore not appropriate for most
>> initialization code, but on the other hand initialization code is
>> generally not performance critical.
>>
>> On gcc 4.5+ this uses the new "asm goto" feature.
> 
> Might be time to change Documentation/Changes about gcc requirements ...
> 

Well, this failure is in the fallback code.  What this seems to imply is
that gcc 3.4.6 doesn't know how to propagate what is already known to be
constant in an inline into an immediate.  This is a pretty big fail, and
yes, if it really is this broken it might just be time to declare gcc
3.4 dead.

> # make
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CC      arch/x86/kernel/process_32.o
> /usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h: In function
> `prepare_to_copy':
> /usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h:315: warning: asm
> operand 1 probably doesn't match constraints
> /usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h:315: error:
> impossible constraint in `asm'
> /usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h:313: warning:
> 'flag' might be used uninitialized in this function
> make[2]: *** [arch/x86/kernel/process_32.o] Error 1
> make[1]: *** [arch/x86/kernel] Error 2
> make: *** [arch/x86] Error 2
> # gcc -v
> Reading specs from /usr/lib/gcc/i386-redhat-linux/3.4.6/specs
> Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
> --infodir=/usr/share/info --enable-shared --enable-threads=posix
> --disable-checking --with-system-zlib --enable-__cxa_atexit
> --disable-libunwind-exceptions --enable-java-awt=gtk
> --host=i386-redhat-linux
> Thread model: posix
> gcc version 3.4.6 20060404 (Red Hat 3.4.6-10)
> 

	-hpa
