Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab2DYHFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 03:05:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52250 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2DYHFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 03:05:45 -0400
Date: Wed, 25 Apr 2012 09:05:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/13] Annotation improvements (G+ edition)
Message-ID: <20120425070537.GA29496@gmail.com>
References: <1334867644-2722-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1334867644-2722-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit a385ec4f11bdcf81af094c03e2444ee9b7fad2e5:
> 
>   Merge tag 'v3.4-rc2' into perf/core (2012-04-13 09:57:10 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/annotate
> 
> for you to fetch changes up to 3f862fd076275c442dfe295eddb5650a6e0aecd4:
> 
>   perf annotate: Add missing jump variants (2012-04-19 17:10:12 -0300)
> 
> ----------------------------------------------------------------
> Annotate improvements
> 
> Now the default annotate browser uses a much more compact format, implementing
> suggestions made made by several people, notably Linus.
> 
> Here is part of the new __list_del_entry annotation:
> 
> __list_del_entry
>     8.47 │      push   %rbp
>     8.47 │      mov    (%rdi),%rdx
>    20.34 │      mov    $0xdead000000100100,%rcx
>     3.39 │      mov    0x8(%rdi),%rax
>     0.00 │      mov    %rsp,%rbp
>     1.69 │      cmp    %rcx,%rdx
>     0.00 │      je     43
>     1.69 │      mov    $0xdead000000200200,%rcx
>     3.39 │      cmp    %rcx,%rax
>     0.00 │      je     a3
>     5.08 │      mov    (%rax),%r8
>    18.64 │      cmp    %r8,%rdi
>     0.00 │      jne    84
>     1.69 │      mov    0x8(%rdx),%r8
>    25.42 │      cmp    %r8,%rdi
>     0.00 │      jne    65
>     1.69 │      mov    %rax,0x8(%rdx)
>     0.00 │      mov    %rdx,(%rax)
>     0.00 │      leaveq
>     0.00 │      retq
>     0.00 │ 43:  mov    %rdx,%r8
>     0.00 │      mov    %rdi,%rcx
>     0.00 │      mov    $0xffffffff817cd6a8,%rdx
>     0.00 │      mov    $0x31,%esi
>     0.00 │      mov    $0xffffffff817cd6e0,%rdi
>     0.00 │      xor    %eax,%eax
>     0.00 │      callq  ffffffff8104eab0 <warn_slowpath_fmt>
>     0.00 │      leaveq
>     0.00 │      retq
>     0.00 │ 65:  mov    %rdi,%rcx
>     0.00 │      mov    $0xffffffff817cd780,%rdx
>     0.00 │      mov    $0x3a,%esi
>     0.00 │      mov    $0xffffffff817cd6e0,%rdi
>     0.00 │      xor    %eax,%eax
>     0.00 │      callq  ffffffff8104eab0 <warn_slowpath_fmt>
>     0.00 │      leaveq
>     0.00 │      retq
> 
> The infrastructure is there to provide formatters for any instruction,
> like the one I'll do for call functions to elide the address.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (13):
>       perf annotate: Rename objdump_line to disasm_line
>       perf annotate: Parse instruction
>       perf annotate browser: Use the disasm_line instruction name and operand fields
>       perf annotate: Disassembler instruction parsing
>       perf annotate: Parse call targets earlier
>       perf annotate: Introduce scnprintf ins_ops method
>       perf annotate browser: Rename disasm_line_rb_node
>       perf symbols: Introduce symbol__size method
>       perf annotate browser: Hide non jump target addresses in offset mode
>       perf annotate browser: Align jump labels
>       perf annotate browser: Make lines more compact
>       perf annotate browser: Use a vertical line as percentage separator
>       perf annotate: Add missing jump variants
> 
>  tools/perf/ui/browsers/annotate.c |  323 +++++++++++++++++++++----------------
>  tools/perf/util/annotate.c        |  263 +++++++++++++++++++++++++-----
>  tools/perf/util/annotate.h        |   32 +++-
>  tools/perf/util/symbol.h          |    5 +
>  tools/perf/util/util.c            |   10 ++
>  tools/perf/util/util.h            |    2 +
>  6 files changed, 446 insertions(+), 189 deletions(-)

The new output looks very (very!) nice - but it is still a bit 
fragile:

earth5:~/tip/tools/perf> ./perf record -a sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.092 MB perf.data (~4008 samples) ]

earth5:~/tip/tools/perf> ./perf annotate _int_free
perf: Segmentation fault

The crash happens here:

Program received signal SIGSEGV, Segmentation fault.
0x0000000000486cda in annotate_browser__mark_jump_targets (size=<optimized out>, 
    browser=<optimized out>) at ui/browsers/annotate.c:704
704			bdlt->jump_target = true;

But other than that the new assembly output is awesome :-)

Thanks,

	Ingo
