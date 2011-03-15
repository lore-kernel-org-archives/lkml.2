Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab1COF0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:26:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41120 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1COF0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:26:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wOFcVim0j59pn1G0hAo8ZakMDq72NYBAWsjIWN9AFlJAY8/il53Ub4Pq3bOuHfM6IC
         Z6+kgG+mulOQluTjBx7zgHulckHEDd50HaQsf4YOhvaVnnKGzQorCFrlqbzsjP/RtlNw
         1UMwB+AHZVOaS+wtCW6y6Col5u0UeTYhiovxg=
MIME-Version: 1.0
In-Reply-To: <AANLkTinX=KODGLx5X+k-XD6FHQQU8VJhq+nX1_MTMCzs@mail.gmail.com>
References: <20110311092811.GA2079@polaris.bitmath.org>
	<1299879287-30889-1-git-send-email-mmarek@suse.cz>
	<20110311230601.GA1559@polaris.bitmath.org>
	<AANLkTinX=KODGLx5X+k-XD6FHQQU8VJhq+nX1_MTMCzs@mail.gmail.com>
Date: Tue, 15 Mar 2011 08:26:05 +0300
Message-ID: <AANLkTik2WLrt4D5cKMmnbRMCB63TJrjvRdtkSJ=6mLf+@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Fix computing srcversion for modules
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 March 2011 08:04, Alexander Beregalov <a.beregalov@gmail.com> wrote:
> On 12 March 2011 02:06, Henrik Rydberg <rydberg@euromail.se> wrote:
>> On Fri, Mar 11, 2011 at 10:34:47PM +0100, Michal Marek wrote:
>>> Recent change to fixdep:
>>>
>>>     commit b7bd182176960fdd139486cadb9962b39f8a2b50
>>>     Author: Michal Marek <mmarek@suse.cz>
>>>     Date:   Thu Feb 17 15:13:54 2011 +0100
>>>
>>>     fixdep: Do not record dependency on the source file itself
>>>
>>> changed the format of the *.cmd files without realizing that it is also
>>> used by modpost. Put the path to the source file to the file back, in a
>>> special variable, so that modpost sees all source files when calculating
>>> srcversion for modules.
>>>
>
> Hi Michal,
>
> There is something wrong with the patch,
> I can't compile 2.6.38 neither linux-next on sparc64:
>
> $ make CROSS_COMPILE=sparc64-unknown-linux-gnu-
>  CHK     include/linux/version.h
>  CHK     include/generated/utsrelease.h
>  UPD     include/generated/utsrelease.h
>  CC      kernel/bounds.s
>  GEN     include/generated/bounds.h
>  CC      arch/sparc/kernel/asm-offsets.s
>  GEN     include/generated/asm-offsets.h
>  CALL    scripts/checksyscalls.sh
>  CC      scripts/mod/empty.o
>  MKELF   scripts/mod/elfconfig.h
>  HOSTCC  scripts/mod/file2alias.o
>  HOSTCC  scripts/mod/modpost.o
>  HOSTCC  scripts/mod/sumversion.o
>  HOSTLD  scripts/mod/modpost
> /usr/lib/gcc/sparc-unknown-linux-gnu/4.5.2/../../../../sparc-unknown-linux-gnu/bin/ld:
> scripts/mod/sumversion.o: Relocations in generic ELF (EM: 3)
> scripts/mod/sumversion.o: could not read symbols: File in wrong format
> collect2: ld returned 1 exit status
>
> $ file scripts/mod/sumversion.o
> scripts/mod/sumversion.o: ELF 32-bit LSB relocatable, Intel 80386,
> version 1 (SYSV), not stripped
>
> Why 386?
>
> gcc both sparc and sparc64 are 4.5.2, ld/binutils is 2.21
>

Sorry for the noise, it's my fault.

I use distcc for distributing sparc64-unknown-linux-gnu-gcc calls to x86 host.
I should not distribute plain 'gcc' calls.
