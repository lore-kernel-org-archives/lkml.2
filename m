Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2EDHAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 03:00:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35781 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2EDHAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 03:00:54 -0400
Date: Fri, 4 May 2012 09:00:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/3] perf/annotate improvements
Message-ID: <20120504070048.GA10289@gmail.com>
References: <1336062935-19964-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336062935-19964-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> 	Just a bit on top of yesterday's pile.
> 
> - Arnaldo
> 
> The following changes since commit 0822cc80d9aee026b1ebe43c02dc01e0a0227864:
> 
>   perf annotate browser: Don't display 0.00 percentages (2012-04-27 17:13:53 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/annotate
> 
> for you to fetch changes up to 64aa17ca5a4e428fcb6d0806823a99a18c548506:
> 
>   perf annotate browser: Don't change the asm line color when toggling source (2012-05-03 13:23:00 -0300)
> 
> ----------------------------------------------------------------
> Perf annotate browser improvements.
> 
> . Get back the line separating the overheads from the disassembly, requested by
>   Peter Zijlstra, Linus agreed now that it is a solid line and more column real
>   state was harvested. Also it has the jump->arrow lines separated from it by
>   the address/jump target column.
> 
> . Don't change asm line color when toggling source code view. Requested by
>   Peter Zijlstra.
> 
> Current snapshot:
> 
> avtab_search_node
>        │      push   %rbp
>        │      mov    %rsp,%rbp
>        │    → callq  mcount
>        │      movzwl 0x6(%rsi),%edx
>        │      and    $0x7fff,%dx
>        │      test   %rdi,%rdi
>        │    ↓ jne    20
>   0.42 │17:┌─→xor    %eax,%eax
>        │19:│  leaveq
>   0.42 │   │← retq
>        │   │  nopl   0x0(%rax,%rax,1)
>        │20:│  mov    (%rdi),%rax
>   0.08 │   │  test   %rax,%rax
>        │   └──je     17
>        │      movzwl (%rsi),%ecx
>        │      movzwl 0x2(%rsi),%r9d
>        │      movzwl 0x4(%rsi),%r8d
>        │      movzwl %cx,%esi
>        │      movzwl %r9w,%r10d
>        │      shl    $0x9,%esi
>        │      lea    (%rsi,%r10,4),%esi
>        │      lea    (%r8,%rsi,1),%esi
>        │      and    0x10(%rdi),%si
>        │      movzwl %si,%esi
>        │      mov    (%rax,%rsi,8),%rax
>   1.01 │      test   %rax,%rax
>        │    ↑ je     19
>        │      nopw   0x0(%rax,%rax,1)
>   3.19 │60:   cmp    %cx,(%rax)
>        │    ↓ jne    7e
>   0.08 │      cmp    %r9w,0x2(%rax)
>        │    ↓ jne    7e
>        │      cmp    %r8w,0x4(%rax)
>        │    ↓ jne    79
>        │      test   %dx,0x6(%rax)
>        │    ↑ jne    19
>        │79:   cmp    %r8w,0x4(%rax)
>  83.45 │7e: ↑ ja     17
>   3.36 │      mov    0x10(%rax),%rax
>   7.98 │      test   %rax,%rax
>        │    ↑ jne    60
>        │      leaveq
>        │    ← retq
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (3):
>       perf ui browser: Introduce routine to draw vertical line
>       perf annotate browser: More clearly separate columns
>       perf annotate browser: Don't change the asm line color when toggling source
> 
>  tools/perf/ui/browser.c           |   23 ++++++++++++-----
>  tools/perf/ui/browser.h           |    4 ++-
>  tools/perf/ui/browsers/annotate.c |   51 ++++++++++++++++++++-----------------
>  3 files changed, 47 insertions(+), 31 deletions(-)

Hm, this regresses for some symbols, the annotation window only 
shows this:

__strlen_sse2_pminub                                                                               
       │
       │

It used to show the full thing:

__strlen_sse2_pminub                                                                               
    0.00 :          392a35dbde:   jne    392a35dc30 
<__strlen_sse2_pminub+0x2a0>                  ▒
    0.00 :          392a35dbe0:   pcmpeqb 0x40(%rax),%xmm3                                        
▒
    0.00 :          392a35dbe5:   pmovmskb %xmm3,%edx                                             
▒
    0.00 :          392a35dbe9:   sub    %rdi,%rax                                                
▒
    0.00 :          392a35dbec:   bsf    %rdx,%rdx                                                
▒
    0.00 :          392a35dbf0:   add    %rdx,%rax                                                
▒
    0.00 :          392a35dbf3:   add    $0x40,%rax                                               
▒
    0.00 :          392a35dbf7:   retq                                           

Other symbols are fine.

	Ingo
