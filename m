Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0KHVAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:00:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42383 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab0KHVAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:00:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vwIV5oQPkgVu23LAabTzl3GogE/bPu+QZoK5xCJSJvPr59z1KyGIC0m8veCV7gQHKu
         yYiuNsswHHv6ygtwlMPlgqrYtdgMMKfLfBUumaRYigAE62N6RalGi14F1DuBRajzF3cP
         jq6iQ5Vw3ZxvSrscEhXniyMf4zToRVa298KnQ=
MIME-Version: 1.0
In-Reply-To: <20101107184711.GB15561@linux.vnet.ibm.com>
References: <AANLkTimGgzOZb8EwUQO16cZcL+ycveKTYzg_AAX+D+Kw@mail.gmail.com>
	<20101107184711.GB15561@linux.vnet.ibm.com>
Date: Mon, 8 Nov 2010 16:00:51 -0500
Message-ID: <AANLkTikuOr_MygyDZdmxZaEkRoF8L6tL5Ks5a5w=SMM1@mail.gmail.com>
Subject: Re: 2.6.36-git11 -- kernel/pid.c:419 invoked rcu_dereference_check()
 without protection!
From: Miles Lane <miles.lane@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Great!  Works here.  :-)

On Sun, Nov 7, 2010 at 1:47 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Oct 29, 2010 at 01:22:28AM -0400, Miles Lane wrote:
>> [ INFO: suspicious rcu_dereference_check() usage. ]
>> ---------------------------------------------------
>> kernel/pid.c:419 invoked rcu_dereference_check() without protection!
>>
>> other info that might help us debug this:
>>
>>
>> rcu_scheduler_active = 1, debug_locks = 1
>> 1 lock held by ureadahead/943:
>>  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff810ec497>]
>> sys_ioprio_set+0x8e/0x2aa
>>
>> stack backtrace:
>> Pid: 943, comm: ureadahead Not tainted 2.6.36-git11 #8
>> Call Trace:
>>  [<ffffffff8105d335>] lockdep_rcu_dereference+0x9d/0xa5
>>  [<ffffffff8104c825>] find_task_by_pid_ns+0x3f/0x58
>>  [<ffffffff8104c85b>] find_task_by_vpid+0x1d/0x1f
>>  [<ffffffff810ec4c6>] sys_ioprio_set+0xbd/0x2aa
>>  [<ffffffff813547a3>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>  [<ffffffff81002aab>] system_call_fastpath+0x16/0x1b
>
> Could you please try the patch from Sergey Senozhatsky, currently
> in -mm, that may be found at http://lkml.org/lkml/2010/10/29/168?
>
>                                                        Thanx, Paul
>
