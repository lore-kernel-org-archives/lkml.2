Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab2EBTq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:46:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:57086 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab2EBTq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:46:57 -0400
Message-ID: <1335988003.13683.182.camel@twins>
Subject: Re: [GIT PULL 0/5] perf/annotate fixes and improvements
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Wed, 02 May 2012 21:46:43 +0200
In-Reply-To: <1335987758-11039-1-git-send-email-acme@infradead.org>
References: <1335987758-11039-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 16:42 -0300, Arnaldo Carvalho de Melo wrote:
> 
> avtab_search_node
>                push   %rbp
>                mov    %rsp,%rbp
>              → callq  mcount
>                movzwl 0x6(%rsi),%edx
>                and    $0x7fff,%dx
>                test   %rdi,%rdi
>        ┌─────↓ jne    20
>        │  17:  xor    %eax,%eax
>        │  19:  leaveq
>        │     ← retq
>        │       nopl   0x0(%rax,%rax,1)
>        └─→20:  mov    (%rdi),%rax
>                test   %rax,%rax
>              ↑ je     17
>                movzwl (%rsi),%ecx
>                movzwl 0x2(%rsi),%r9d
>                movzwl 0x4(%rsi),%r8d
>                movzwl %cx,%esi
>                movzwl %r9w,%r10d
>                shl    $0x9,%esi
>                lea    (%rsi,%r10,4),%esi
>                lea    (%r8,%rsi,1),%esi
>                and    0x10(%rdi),%si
>                movzwl %si,%esi
>                mov    (%rax,%rsi,8),%rax
>   1.63         test   %rax,%rax
>              ↑ je     19
>                nopw   0x0(%rax,%rax,1)
>   4.88    60:  cmp    %cx,(%rax)
>              ↓ jne    7e
>                cmp    %r9w,0x2(%rax)
>              ↓ jne    7e
>                cmp    %r8w,0x4(%rax)
>              ↓ jne    79
>                test   %dx,0x6(%rax)
>              ↑ jne    19
>           79:  cmp    %r8w,0x4(%rax)
>  86.99    7e:↑ ja     17
>   3.25         mov    0x10(%rax),%rax
>   3.25         test   %rax,%rax
>              ↑ jne    60
>                leaveq
>              ← retq
> 
> . Changes:
> 
>         - Don't show the big vertical line. 

Not sure about that, loosing that separator makes it looks messy.
