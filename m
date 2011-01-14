Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab1ANKdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:33:44 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42277 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab1ANKdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:33:36 -0500
X-AuditID: b753bd60-9f960ba000000f65-3c-4d30267ee8c6
Message-ID: <4D30267B.9080406@hitachi.com>
Date: Fri, 14 Jan 2011 19:33:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        lkml <linux-kernel@vger.kernel.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] perf-probe: make "perf-probe -L <function>" display the
 absolute path and absolute line number
References: <m38vyp85qv.fsf@gmail.com> <4D2EDBE4.3060608@hitachi.com>	<m34o9c8ual.fsf@gmail.com> <4D2FC17D.5010203@hitachi.com> <m3tyhb6eme.fsf@gmail.com>
In-Reply-To: <m3tyhb6eme.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Franck,

(2011/01/14 18:03), Franck Bui-Huu wrote:
> But if you think it should be used to hint for a probe point syntax,
> (you'll probably use copy & paste since it uses absolute path name),

Not only for copy&paste, but also for avoiding confusion.
Please imagine that user see this output.

   </usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:3823>
        10         rq = cpu_rq(cpu);
        11         rcu_note_context_switch(cpu);

"Why the definition line number and starting line number are different?"
"How I can put a probe?  sched.c:3823 ... + 10??"
"Or, it's just buggy! report it!"

I don't want this.

> then this patch is wrong.

Yeah, but just a _bit_. Basically, I agree with your idea of showing
actual path of the function, because, indeed, perf-probe just shows
the first one even if there are many same-name functions.

So, here, I had suggested an enhancement idea;

  $ perf probe -L schedule:0-1
  <schedule@/usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:0>
        0  asmlinkage void __sched schedule(void)
        1  {

This is acceptable, because it shows which function you see and
it also gives you how you can specify a probe point on a function
line.

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
