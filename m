Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab2JZJoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:44:16 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35400 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab2JZJoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:44:12 -0400
MIME-Version: 1.0
In-Reply-To: <20121025074147.GA2240@swordfish>
References: <20121017034918.GA13295@redhat.com>
	<20121024164235.GA2467@swordfish>
	<20121024180608.GA22840@redhat.com>
	<20121024182111.GA2340@swordfish>
	<CAFTL4hxmh7yV8ePUhY_7hOuG=JrbZZcNvV88bWcUmwG9X0W04A@mail.gmail.com>
	<20121025055056.GA2661@swordfish>
	<CAFTL4hxM8KqL3=GLkJDU-9pKVHrb1nSoDgFx8UVB7F7tryw6HA@mail.gmail.com>
	<20121025074147.GA2240@swordfish>
Date: Fri, 26 Oct 2012 11:44:11 +0200
Message-ID: <CAFTL4hw=orRVYzuk8L1aBHCxVD05uT_fdFoRJ_BkihoNd0huJg@mail.gmail.com>
Subject: Re: lots of suspicious RCU traces
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Dave Jones <davej@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/25 Sergey Senozhatsky <sergey.senozhatsky@gmail.com>:
> On (10/25/12 09:06), Frederic Weisbecker wrote:
>> >> > My understanding is (I may be wrong) that we can schedule() from ptrace chain to
>> >> > some arbitrary task, which will continue its execution from the point where RCU assumes
>> >> > CPU as not idle, while CPU in fact still in idle state -- no one said rcu_idle_exit()
>> >> > (or similar) prior to schedule() call.
>> >>
>> >> Yeah but when we are in syscall_trace_leave(), the CPU shouldn't be in
>> >> RCU idle mode. That's where the bug is. How do you manage to trigger
>> >> this bug?
>> >>
>> >
>> > strace -f <anything>
>>
>> I can't reproduce. Can you send me your config?
>>
>
> sure, attached.

Thanks.

Sergey, Dave,

Does the patch I just sent you fix the issue?

Patch is "[PATCH] rcu: Fix unrecovered RCU user mode in syscall_trace_leave()"

Thanks.
