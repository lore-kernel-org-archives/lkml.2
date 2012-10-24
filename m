Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161533Ab2JXWcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:32:18 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52068 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161362Ab2JXWcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:32:15 -0400
MIME-Version: 1.0
In-Reply-To: <20121024182111.GA2340@swordfish>
References: <20121017034918.GA13295@redhat.com>
	<20121024164235.GA2467@swordfish>
	<20121024180608.GA22840@redhat.com>
	<20121024182111.GA2340@swordfish>
Date: Thu, 25 Oct 2012 00:32:14 +0200
Message-ID: <CAFTL4hxmh7yV8ePUhY_7hOuG=JrbZZcNvV88bWcUmwG9X0W04A@mail.gmail.com>
Subject: Re: lots of suspicious RCU traces
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, thanks a lot for your report.

2012/10/24 Sergey Senozhatsky <sergey.senozhatsky@gmail.com>:
> On (10/24/12 20:06), Oleg Nesterov wrote:
>> On 10/24, Sergey Senozhatsky wrote:
>> >
>> > small question,
>> >
>> > ptrace_notify() and forward calls are able to both indirectly and directly call schedule(),
>> > /* direct call from ptrace_stop()*/,
>> > should, in this case, rcu_user_enter() be called before tracehook_report_syscall_exit(regs, step)
>> > and ptrace chain?
>>
>> Well, I don't really understand this magic... but why?
>>
>
> My understanding is (I may be wrong) that we can schedule() from ptrace chain to
> some arbitrary task, which will continue its execution from the point where RCU assumes
> CPU as not idle, while CPU in fact still in idle state -- no one said rcu_idle_exit()
> (or similar) prior to schedule() call.

Yeah but when we are in syscall_trace_leave(), the CPU shouldn't be in
RCU idle mode. That's where the bug is. How do you manage to trigger
this bug?

>
> if so, does the same apply to in_user?
