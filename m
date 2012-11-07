Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab2KGHil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:38:41 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51338 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab2KGHik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:38:40 -0500
X-AuditID: 9c930197-b7c0bae00000042f-82-509a0ffdedfa
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 00/16] perf: add memory access sampling support
References: <1352123463-7346-1-git-send-email-eranian@google.com>
	<20121106205220.GF13629@infradead.org>
Date: Wed, 07 Nov 2012 16:38:36 +0900
In-Reply-To: <20121106205220.GF13629@infradead.org> (Arnaldo Carvalho de
	Melo's message of "Tue, 6 Nov 2012 17:52:21 -0300")
Message-ID: <87fw4looar.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Tue, 6 Nov 2012 17:52:21 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Nov 05, 2012 at 02:50:47PM +0100, Stephane Eranian escreveu:
> [root@sandy acme]# perf mem -t load rep --stdio --sort=symbol,symbol_daddr,cost
> # Samples: 30  of event 'cpu/mem-loads/pp'
> # Total cost : 640
> # Sort order : symbol,symbol_daddr,cost
> #
> # Overhead      Samples                  Symbol             Data Symbol     Cost
> # ........  ...........  ......................  ......................  .......
> #
>     55.00%            1  [k] lookup_fast         [k] 0xffff8803b7521bd4      352
>      5.47%            1  [k] cache_alloc_refill  [k] 0xffff880407705024       35
>      3.44%            1  [k] cache_alloc_refill  [k] 0xffff88041d8527d8       22
>      3.28%            1  [k] run_timer_softirq   [k] 0xffff88041e2c3e90       21
>      2.50%            1  [k] __list_add          [k] 0xffff8803b7521d68       16
>      2.19%            1  [.] __strcoll_l         [.] 0x00007fffa8d44080       14
>      1.88%            1  [.] __strcoll_l         [.] 0x00007fffa8d44104       12
>
> If we go to the annotation browser to see where is that lookup_fast hitting we get:
>
> 100.00 │       mov    -0x34(%rbp),%eax
>
> How to map 0xffff8803b7521bd4 to a stack variable, struct members and all?
>
> Humm, for userspace we have PERF_SAMPLE_REGS_USER for the dwarf unwinder we
> need for userspace, but what about reverse mapping of kernel variables? Jiri?

I suspect there aren't much thing we can do on stack.  One thing we can
do is adding dso_daddr to sort key and seeing it's a [stack] (or
[stack:tid]) or not.  But not sure it can be done for kernel stacks too.

Thanks,
Namhyung
