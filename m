Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab2DTAJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:09:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48510 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2DTAJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:09:01 -0400
Message-ID: <4F90A74B.8040001@gmail.com>
Date: Thu, 19 Apr 2012 18:01:15 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/13] Annotation improvements (G+ edition)
References: <1334867644-2722-1-git-send-email-acme@infradead.org>
In-Reply-To: <1334867644-2722-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something hosed up on your send: I only have 9 of the 13, I don't see 
the missing ones here: https://lkml.org/lkml/2012/4/19/, and the subject 
line on the lkml summary page is messed up.

David


On 4/19/12 2:33 PM, Arnaldo Carvalho de Melo wrote:
> Hi Ingo,
>
> 	Please consider pulling,
>
> - Arnaldo
>
> The following changes since commit a385ec4f11bdcf81af094c03e2444ee9b7fad2e5:
>
>    Merge tag 'v3.4-rc2' into perf/core (2012-04-13 09:57:10 +0200)
>
> are available in the git repository at:
>
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/annotate
>
> for you to fetch changes up to 3f862fd076275c442dfe295eddb5650a6e0aecd4:
>
>    perf annotate: Add missing jump variants (2012-04-19 17:10:12 -0300)
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
>      8.47 │      push   %rbp
>      8.47 │      mov    (%rdi),%rdx
>     20.34 │      mov    $0xdead000000100100,%rcx
>      3.39 │      mov    0x8(%rdi),%rax
>      0.00 │      mov    %rsp,%rbp
>      1.69 │      cmp    %rcx,%rdx
>      0.00 │      je     43
>      1.69 │      mov    $0xdead000000200200,%rcx
>      3.39 │      cmp    %rcx,%rax
>      0.00 │      je     a3
>      5.08 │      mov    (%rax),%r8
>     18.64 │      cmp    %r8,%rdi
>      0.00 │      jne    84
>      1.69 │      mov    0x8(%rdx),%r8
>     25.42 │      cmp    %r8,%rdi
>      0.00 │      jne    65
>      1.69 │      mov    %rax,0x8(%rdx)
>      0.00 │      mov    %rdx,(%rax)
>      0.00 │      leaveq
>      0.00 │      retq
>      0.00 │ 43:  mov    %rdx,%r8
>      0.00 │      mov    %rdi,%rcx
>      0.00 │      mov    $0xffffffff817cd6a8,%rdx
>      0.00 │      mov    $0x31,%esi
>      0.00 │      mov    $0xffffffff817cd6e0,%rdi
>      0.00 │      xor    %eax,%eax
>      0.00 │      callq  ffffffff8104eab0<warn_slowpath_fmt>
>      0.00 │      leaveq
>      0.00 │      retq
>      0.00 │ 65:  mov    %rdi,%rcx
>      0.00 │      mov    $0xffffffff817cd780,%rdx
>      0.00 │      mov    $0x3a,%esi
>      0.00 │      mov    $0xffffffff817cd6e0,%rdi
>      0.00 │      xor    %eax,%eax
>      0.00 │      callq  ffffffff8104eab0<warn_slowpath_fmt>
>      0.00 │      leaveq
>      0.00 │      retq
>
> The infrastructure is there to provide formatters for any instruction,
> like the one I'll do for call functions to elide the address.
>
> Signed-off-by: Arnaldo Carvalho de Melo<acme@redhat.com>
>
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (13):
>        perf annotate: Rename objdump_line to disasm_line
>        perf annotate: Parse instruction
>        perf annotate browser: Use the disasm_line instruction name and operand fields
>        perf annotate: Disassembler instruction parsing
>        perf annotate: Parse call targets earlier
>        perf annotate: Introduce scnprintf ins_ops method
>        perf annotate browser: Rename disasm_line_rb_node
>        perf symbols: Introduce symbol__size method
>        perf annotate browser: Hide non jump target addresses in offset mode
>        perf annotate browser: Align jump labels
>        perf annotate browser: Make lines more compact
>        perf annotate browser: Use a vertical line as percentage separator
>        perf annotate: Add missing jump variants
>
>   tools/perf/ui/browsers/annotate.c |  323 +++++++++++++++++++++----------------
>   tools/perf/util/annotate.c        |  263 +++++++++++++++++++++++++-----
>   tools/perf/util/annotate.h        |   32 +++-
>   tools/perf/util/symbol.h          |    5 +
>   tools/perf/util/util.c            |   10 ++
>   tools/perf/util/util.h            |    2 +
>   6 files changed, 446 insertions(+), 189 deletions(-)

