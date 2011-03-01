Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab1CAXvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:51:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61776 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950Ab1CAXvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:51:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jzzAvUZCYBlExiNTLyHF79I0EaBX/uBf9l4Nis+kh9Fq0dGADH0bCR36q971rG3Sqt
         XSq2Uck9Rmsw6sraxMTEhFr9UDSwNdNjGWoSQcyIwg25wrkz9VGyfNSHsZyon2QmWflc
         GoyRl/aXsFSCwl9oYbyVBqhQK8ks7mzDtbY+o=
MIME-Version: 1.0
In-Reply-To: <20110301183454.GC23527@mtj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org> <201103011757.48593.vda.linux@googlemail.com>
 <20110301170953.GB17933@htj.dyndns.org> <AANLkTi=8=Tw2aYzvwM_s8dsMmw3W_tYjsYkqTHS9moUW@mail.gmail.com>
 <20110301183454.GC23527@mtj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 2 Mar 2011 00:51:24 +0100
Message-ID: <AANLkTikC=EETfwN+Se+KyETP12nxDGmWSQth_UFS36tJ@mail.gmail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 7:34 PM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Mar 01, 2011 at 06:21:49PM +0100, Denys Vlasenko wrote:
>> > gdb can do whatever it wants to do but I don't think the above needs
>> > fixing.  In the first case, the user is explicitly telling gdb to
>> > continue the tracee, so it continues as it always has.
>>
>> It does not look like that to me.
>>
>> User attached to some process. User might be unaware that
>> the process is currently stopped (imagine a group of processes
>> which use SIGSTOP/SIGCONT in their normal interactions).
>>
>> User peeked some state, and then wants to let process
>> continue whatever process was doing, but remain in the debugger.
>>
>> What user did not know is that "whatever process was doing" =
>> "being stopped by SIGSTOP, waiting to be woken up".
>> Therefore, if "continue" makes process run, it does not
>> return process to whatever process was doing.
>>
>> > In the latter
>> > case, the debugging session is over.  The tracee now should do
>> > whatever it's supposed to do.
>>
>> It should do that in both cases.
>
> Maybe it should, maybe not, but that's mostly irrelevant because the
> described behavior is the current behavior.

This is not a good argument. We are in this discussion exactly because
there are cases of current behavior in strace and gdb which are clearly
wrong and which we want to change. Therefore, "it's the current
behavior" does not automatically mean it is desired behavior.

> There is no
> continue-if-not-job-control-stopped operation and we shouldn't change
> that beneath gdb

I feel that "continue" is meant to be such operation. Currently
it is not merely because ptrace is buggy.

There is already continue-no-matter-what command in gdb:

(gdb) signal SIGCONT

> because otherwise not only the behavior changes
> unexpectedly

"strace no longer breaks ^Z" is also an unexpected
change in behavior. This doesn't mean we should avoid it,
right?

Bottom line is: I am not trying to shoot your proposal down.
It looks good to me.

I am only discussing it in more detail from the userspace API
POV and from "what changes will be needed in strace and gdb?"
and "what improvements in strace and gdb are becoming possible
with this proposal, and how exactly to implement them there?"
POVs.

-- 
vda
