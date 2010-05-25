Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0EYNJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:09:42 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:51393 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab0EYNJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:09:41 -0400
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request
Date: Tue, 25 May 2010 15:09:39 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33.2-gentoo-r1-ck1; KDE/4.4.3; x86_64; ; )
References: <201005231829.32106.M4rkusXXL@web.de> <201005232244.41977.M4rkusXXL@web.de> <20100523211717.GD1408@liondog.tnic>
In-Reply-To: <20100523211717.GD1408@liondog.tnic>
Cc: Borislav Petkov <bp@alien8.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005251509.39495.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX1/2y0Fkvsl2nY5CutMTEaWa2Nt3VpizigX7Wl7M
	xdZQn/2d30Fe9zdvvh5JQWW+tFDwtBUVvlbDN6woyfctZuqEox
	lITKuEuXU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Had disabled swap (saw the string "swapper" and "page_fault"...) and now 
the problem does not show up anymore. Dont know, if its now "fixed", but 
is it possible that raid1 and swap on top does not really work? Normal 
system usage (auto-detected raid1, add swap by fstab, regularly running 
a check and perhaps a resync).

Thanks,
Markus


> From: Markus <M4rkusXXL@web.de>
> Date: Sun, May 23, 2010 at 10:44:41PM +0200
> 
> > It is 0000000001912178.
> > http://img256.imageshack.us/img256/4370/shotn.gif
> 
> True story, the fact that this value is not what it is expected to be
> judging from the code it happens might actually be a clue:
> 
> [64112.502507] Code: 8b bf b0 00 00 00 31 ed 48 8d 50 f0 48 85 c0 48
> 0f 45 ea 48 85 ff 74 10 48 89 ee e8 8d d3 ff ff 85 c0 0f 8e c5 00 00
> 00 48 89 eb <49> 8b bd b8 00 00 00 48 85 ff 74 10 48 89 ee e8 6e d3
> ff ff 85 All code
> ========
>    0:   8b bf b0 00 00 00       mov    0xb0(%rdi),%edi
>    6:   31 ed                   xor    %ebp,%ebp
>    8:   48 8d 50 f0             lea    -0x10(%rax),%rdx
>    c:   48 85 c0                test   %rax,%rax
>    f:   48 0f 45 ea             cmovne %rdx,%rbp
>   13:   48 85 ff                test   %rdi,%rdi
>   16:   74 10                   je     0x28
>   18:   48 89 ee                mov    %rbp,%rsi
>   1b:   e8 8d d3 ff ff          callq  0xffffffffffffd3ad
>   20:   85 c0                   test   %eax,%eax
>   22:   0f 8e c5 00 00 00       jle    0xed
>   28:   48 89 eb                mov    %rbp,%rbx
>   2b:*  49 8b bd b8 00 00 00    mov    0xb8(%r13),%rdi     <--
> trapping instruction 32:   48 85 ff                test   %rdi,%rdi
>   35:   74 10                   je     0x47
>   37:   48 89 ee                mov    %rbp,%rsi
>   3a:   e8 6e d3 ff ff          callq  0xffffffffffffd3ad
>   3f:   85                      .byte 0x85
> 
> Code starting with the faulting instruction
> ===========================================
>    0:   49 8b bd b8 00 00 00    mov    0xb8(%r13),%rdi
>    7:   48 85 ff                test   %rdi,%rdi
>    a:   74 10                   je     0x1c
>    c:   48 89 ee                mov    %rbp,%rsi
>    f:   e8 6e d3 ff ff          callq  0xffffffffffffd382
>   14:   85                      .byte 0x85
> 
> 
> and %r13 contains 00000000019129c0 in the register snapshot. Hmm...
> 
> > Serial console is no option, but this "netconsole"-thing looks
> > promising. I'll set that up and try to catch the next one with
> > this.
> 
> That'll help. Also let me make sure: Is this a vanilla kernel or are
> there any distribution patches on top of it? I see it says
> 2.6.34-gentoo but just in case. If it is not a vanilla kernel please
> try a vanilla one from kernel.org.
> 
> Also, please send the whole dmesg of the system, there might be
> something suspicious there and also the output of 'cat /proc/cpuinfo'
> and 'dmidecode', the last one run as root.
> 
> Thanks.

