Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2BWOhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:37:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55981 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab2BWOhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:37:05 -0500
Message-ID: <4F464EF4.80902@zytor.com>
Date: Thu, 23 Feb 2012 06:36:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, luto@mit.edu, tglx@linutronix.de,
        hjl.tools@gmail.com
Subject: Re: [tip:x86/x32] x32: Drop non-__vdso weak symbols from the x32
 VDSO
References: <4F42E171.9080005@mit.edu> <tip-862ae3132dc393ab6ea750b9ee9e0e1c276b9abb@git.kernel.org> <20120223105534.GA17026@elte.hu>
In-Reply-To: <20120223105534.GA17026@elte.hu>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 02:55 AM, Ingo Molnar wrote:
> 
> * tip-bot for H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> Commit-ID:  862ae3132dc393ab6ea750b9ee9e0e1c276b9abb
>> Gitweb:     http://git.kernel.org/tip/862ae3132dc393ab6ea750b9ee9e0e1c276b9abb
>> Author:     H. Peter Anvin <hpa@zytor.com>
>> AuthorDate: Wed, 22 Feb 2012 20:37:10 -0800
>> Committer:  H. Peter Anvin <hpa@zytor.com>
>> CommitDate: Wed, 22 Feb 2012 20:40:07 -0800
>>
>> x32: Drop non-__vdso weak symbols from the x32 VDSO
> 
> One of the recent x32 commit broke the build on some configs:
> 
>   VDSO    arch/x86/vdso/vdsox32.so.dbg
> /usr/bin/ld: arch/x86/vdso/vgetcpu-x32.o: relocation R_X86_64_64 
> against symbol `.rodata' isn't supported in x32 mode
> arch/x86/vdso/vgetcpu-x32.o: could not read symbols: Bad value
> collect2: error: ld returned 1 exit status
> 
> config attached.
> 
> binutils-2.21.51, gcc-4.7.0.
> 
> Thanks,
> 
> 	Ingo

Yes, this is known: binutils-2.21.51 has some x32 support, but that
version of the ABI is too old for what the kernel needs; in other words
it's not functional.

	-hpa

