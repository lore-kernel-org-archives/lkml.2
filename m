Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab1ANTzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:55:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58552 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab1ANTzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:55:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=Grv3aPIdGldrFjGVbCWvFxPF5vxnA2n1ko6tVtPobU83tK6GYtKkEPeaYmWzKdH7BV
         VU4ZiRgCxCMwQDLMl2dLjrd2qHqIplDhcrCKqMYr0S1sXzzEr6Od/8PE5Viebrk48AwU
         jvQakJAnYofW9cdGWEpdUmOPkTXvwohr7Pv0A=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        lkml <linux-kernel@vger.kernel.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] perf-probe: make "perf-probe -L <function>" display the absolute path and absolute line number
References: <m38vyp85qv.fsf@gmail.com> <4D2EDBE4.3060608@hitachi.com>
	<m34o9c8ual.fsf@gmail.com> <4D2FC17D.5010203@hitachi.com>
	<m3tyhb6eme.fsf@gmail.com> <4D30267B.9080406@hitachi.com>
Date: Fri, 14 Jan 2011 20:53:59 +0100
In-Reply-To: <4D30267B.9080406@hitachi.com> (Masami Hiramatsu's message of
	"Fri, 14 Jan 2011 19:33:31 +0900")
Message-ID: <m3aaj3ntwo.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:

> (2011/01/14 18:03), Franck Bui-Huu wrote:
>> But if you think it should be used to hint for a probe point syntax,
>> (you'll probably use copy & paste since it uses absolute path name),
>
> Not only for copy&paste, but also for avoiding confusion.
> Please imagine that user see this output.
>
>    </usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:3823>
>         10         rq = cpu_rq(cpu);
>         11         rcu_note_context_switch(cpu);
>
> "Why the definition line number and starting line number are different?"
> "How I can put a probe?  sched.c:3823 ... + 10??"

No because if you see relative line number, then the user had used the
following command:

   $ perf probe -L schedule

so I would assume that his next add command would still use a function
name:

   $ perf probe schedule:10

> 
> "Or, it's just buggy! report it!"
>
> I don't want this.
>
>> then this patch is wrong.
>
> Yeah, but just a _bit_. Basically, I agree with your idea of showing
> actual path of the function, because, indeed, perf-probe just shows
> the first one even if there are many same-name functions.
>
> So, here, I had suggested an enhancement idea;
>
>   $ perf probe -L schedule:0-1
>   <schedule@/usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:0>
>         0  asmlinkage void __sched schedule(void)
>         1  {
>
> This is acceptable, because it shows which function you see and
> it also gives you how you can specify a probe point on a function
> line.

I can understand your point, but I'm currently not seeing it as a hint
for a probe point syntax.

But you're a far more experienced user than I am so you're probably
right.

Thanks
-- 
		Franck
