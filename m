Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2EBTmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:42:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49668 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab2EBTmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:42:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: =?UTF-8?q?=5BGIT=20PULL=200/5=5D=20perf/annotate=20fixes=20and=20improvements?=
Date: Wed,  2 May 2012 16:42:33 -0300
Message-Id: <1335987758-11039-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo
The following changes since commit 38b31bd0cefbb0e69a182d9a94b09a7e648549dc:

  perf annotate browser: Don't draw jump connectors for out of function jumps (2012-04-25 14:18:42 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/annotate

for you to fetch changes up to 0822cc80d9aee026b1ebe43c02dc01e0a0227864:

  perf annotate browser: Don't display 0.00 percentages (2012-04-27 17:13:53 -0300)

----------------------------------------------------------------
Perf annotate improvements and fixes:

. Current output:

avtab_search_node
               push   %rbp
               mov    %rsp,%rbp
             → callq  mcount
               movzwl 0x6(%rsi),%edx
               and    $0x7fff,%dx
               test   %rdi,%rdi
       ┌─────↓ jne    20
       │  17:  xor    %eax,%eax
       │  19:  leaveq
       │     ← retq
       │       nopl   0x0(%rax,%rax,1)
       └─→20:  mov    (%rdi),%rax
               test   %rax,%rax
             ↑ je     17
               movzwl (%rsi),%ecx
               movzwl 0x2(%rsi),%r9d
               movzwl 0x4(%rsi),%r8d
               movzwl %cx,%esi
               movzwl %r9w,%r10d
               shl    $0x9,%esi
               lea    (%rsi,%r10,4),%esi
               lea    (%r8,%rsi,1),%esi
               and    0x10(%rdi),%si
               movzwl %si,%esi
               mov    (%rax,%rsi,8),%rax
  1.63         test   %rax,%rax
             ↑ je     19
               nopw   0x0(%rax,%rax,1)
  4.88    60:  cmp    %cx,(%rax)
             ↓ jne    7e
               cmp    %r9w,0x2(%rax)
             ↓ jne    7e
               cmp    %r8w,0x4(%rax)
             ↓ jne    79
               test   %dx,0x6(%rax)
             ↑ jne    19
          79:  cmp    %r8w,0x4(%rax)
 86.99    7e:↑ ja     17
  3.25         mov    0x10(%rax),%rax
  3.25         test   %rax,%rax
             ↑ jne    60
               leaveq
             ← retq

. Changes:

	- Don't show the big vertical line.

        - Add an arrow to the right before call instructions

        - Scrap bogus loop detection and instead start showing
          arrows from jump (fwd or back) instructions to its targets
          when cursor is on jump instruction. Press 'j' to toggle this.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (5):
      perf annotate browser: Add a right arrow before call instructions
      perf ui browser: Add method to draw up/down arrow line
      perf annotate browser: Show current jump, back or forward
      perf annotate browser: Remove the vertical line after the percentages
      perf annotate browser: Don't display 0.00 percentages

 tools/perf/ui/browser.c           |   54 ++++++++++++++++++++++++++++--
 tools/perf/ui/browser.h           |    4 +--
 tools/perf/ui/browsers/annotate.c |   66 ++++++++++++++++++-------------------
 3 files changed, 86 insertions(+), 38 deletions(-)
