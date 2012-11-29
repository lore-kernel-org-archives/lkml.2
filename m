Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab2K2QYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:24:14 -0500
Received: from mail.vapor.com ([83.220.149.2]:33873 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab2K2QYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:24:13 -0500
Date: Thu, 29 Nov 2012 17:24:03 +0100
From: Ian Kumlien <pomac@vapor.com>
To: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] NULL pointer dereference in 3.7-rc7 (syscall_trace_enter)
Message-ID: <20121129162403.GC6365@pomac.netswarm.net>
References: <1354144802.5396.3.camel@pi>
 <20121129092621.GA21100@liondog.tnic>
 <20121129122708.GA6365@pomac.netswarm.net>
 <20121129142220.GC30789@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129142220.GC30789@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:22:20PM +0100, Borislav Petkov wrote:
> On Thu, Nov 29, 2012 at 01:27:08PM +0100, Ian Kumlien wrote:
> > I think that chrome does traceing all the time as a part of it's
> > sandbox - this is most likely chrome monitoring flash...
> 
> Ah, ok.

[ --8<--8<-- ]

> Right, so I can get the code now where it happens, but it is pretty
> unreliable to map it to what my compiler generates here (of course,
> different compilers and hardware):

Yeah i know... =)

> Code: 53 28 48 85 ff 74 29 83 3f 00 75 24 eb 37 65 48 8b 0c 25 80 b8 00 00 48 8b 89 c0 04 00 00 4c 8b 4b 38 48 8b 53 70 48 85 c9 74 08 <83> 39 00 74 1f 48 83 ca ff 48 85 ed 75 04 48 8b 53 78 5b 5d 48
> All code
> ========
>    0:   53                      push   %rbx
>    1:   28 48 85                sub    %cl,-0x7b(%rax)
>    4:   ff 74 29 83             pushq  -0x7d(%rcx,%rbp,1)
>    8:   3f                      (bad)  
>    9:   00 75 24                add    %dh,0x24(%rbp)
>    c:   eb 37                   jmp    0x45
>    e:   65 48 8b 0c 25 80 b8    mov    %gs:0xb880,%rcx
>   15:   00 00 
>   17:   48 8b 89 c0 04 00 00    mov    0x4c0(%rcx),%rcx
>   1e:   4c 8b 4b 38             mov    0x38(%rbx),%r9
>   22:   48 8b 53 70             mov    0x70(%rbx),%rdx
>   26:   48 85 c9                test   %rcx,%rcx
>   29:   74 08                   je     0x33
>   2b:*  83 39 00                cmpl   $0x0,(%rcx)     <-- trapping instruction
>   2e:   74 1f                   je     0x4f
>   30:   48 83 ca ff             or     $0xffffffffffffffff,%rdx
>   34:   48 85 ed                test   %rbp,%rbp
>   37:   75 04                   jne    0x3d
>   39:   48 8b 53 78             mov    0x78(%rbx),%rdx
>   3d:   5b                      pop    %rbx
>   3e:   5d                      pop    %rbp
>   3f:   48                      rex.W
> 
> So we oops when we try to deref 0x63 which is, of course, not a valid
> pointer. The question is, what exactly is that thing in rcx. It looks
> like a percpu variable to me but I'm not sure.
>
> Can you do:
> 
> make arch/x86/kernel/ptrace.lst
> 
> and send me that file, privately is fine too.

Done, =)

> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
