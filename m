Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1COHYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 03:24:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab1COHYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 03:24:12 -0400
Message-ID: <4D7F1418.1070802@suse.cz>
Date: Tue, 15 Mar 2011 08:24:08 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] kbuild: Fix computing srcversion for modules
References: <20110311092811.GA2079@polaris.bitmath.org>	<1299879287-30889-1-git-send-email-mmarek@suse.cz>	<20110311230601.GA1559@polaris.bitmath.org> <AANLkTinX=KODGLx5X+k-XD6FHQQU8VJhq+nX1_MTMCzs@mail.gmail.com>
In-Reply-To: <AANLkTinX=KODGLx5X+k-XD6FHQQU8VJhq+nX1_MTMCzs@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.3.2011 06:04, Alexander Beregalov wrote:
> On 12 March 2011 02:06, Henrik Rydberg <rydberg@euromail.se> wrote:
>> On Fri, Mar 11, 2011 at 10:34:47PM +0100, Michal Marek wrote:
>>> Recent change to fixdep:
>>>
>>>     commit b7bd182176960fdd139486cadb9962b39f8a2b50
>>>     Author: Michal Marek <mmarek@suse.cz>
>>>     Date:   Thu Feb 17 15:13:54 2011 +0100
>>>
>>>     fixdep: Do not record dependency on the source file itself
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
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   UPD     include/generated/utsrelease.h
>   CC      kernel/bounds.s
>   GEN     include/generated/bounds.h
>   CC      arch/sparc/kernel/asm-offsets.s
>   GEN     include/generated/asm-offsets.h
>   CALL    scripts/checksyscalls.sh
>   CC      scripts/mod/empty.o
>   MKELF   scripts/mod/elfconfig.h
>   HOSTCC  scripts/mod/file2alias.o
>   HOSTCC  scripts/mod/modpost.o
>   HOSTCC  scripts/mod/sumversion.o
>   HOSTLD  scripts/mod/modpost
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

I don't know. If you are building on x86 for sparc, then the host
executables have to be x86. Please provide details. But I'm quite sure
that the above patch is not the cause.

Michal
