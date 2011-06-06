Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab1FFLxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:53:48 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36327 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab1FFLxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:53:45 -0400
X-AuditID: b753bd60-a0ac3ba000003bac-4c-4decbfc5cdd3
X-AuditID: b753bd60-a0ac3ba000003bac-4c-4decbfc5cdd3
Message-ID: <4DECBFC3.2090701@hitachi.com>
Date: Mon, 06 Jun 2011 20:53:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        yrl.pp-manager.tt@hitachi.com, Russell King <rmk@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH -tip ] [BUGFIX]tracing/kprobes: Fix kprobe-tracer to support
 stack trace
References: <20110512102255.2540.88867.stgit@ltc-x64-VirtualBox>	 <1306375622.1465.137.camel@gandalf.stny.rr.com>	 <BANLkTinMH_tsESVqN=dJZgpEncpYyDMHzQ@mail.gmail.com> <1306413103.1465.142.camel@gandalf.stny.rr.com>
In-Reply-To: <1306413103.1465.142.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/26 21:31), Steven Rostedt wrote:
> On Thu, 2011-05-26 at 01:25 -0400, Mike Frysinger wrote:
> 
>>>  save_stack_trace_regs() function.
>>
>> i think only x86 implements that func ? 
> 
> Looks to be the case. I didn't think so because not all archs failed.
> Hmm, archs like sparc compiled. Perhaps my config prevented tracing
> enabled? I'll need to take a deeper look.

Hm, at a grans, save_stack_trace_tsk() has also limited
implementations, however, there is an weak symbol defined
in kernel/stacktrace.c.
I think we can add save_stack_trace_regs() same way.

BTW, parameters of save_stack_trace_tsk/regs are
a bit different. It would also be fixed.

Thanks,
-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
