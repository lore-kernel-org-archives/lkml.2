Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab1IUFLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:11:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41350 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab1IUFLE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:11:04 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20110721165137.GA21345@redhat.com>
References: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
 <20110721165137.GA21345@redhat.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 21 Sep 2011 07:10:44 +0200
Message-ID: <CAKgNAkj8STLfO2t5gejct+yPFkFtFtojVkYKJREiE7S2QHSctg@mail.gmail.com>
Subject: Re: [PATCH] man ptrace: add extended description of various ptrace quirks
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Michael Kerrisk <mtk.manpages@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys,

On Thu, Jul 21, 2011 at 6:51 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 07/21, Denys Vlasenko wrote:
>>
>> Deleted several outright false statements:
>> - pid 1 can be traced
>> - tracer is not shown as parent in ps output
>> - PTRACE_ATTACH is not "the same behavior as if tracee had done
>>   a PTRACE_TRACEME": PTRACE_ATTACH delivers a SIGSTOP.
>> - SIGSTOP _can_ be injected.
>
> Yes, this is correct, thanks.
>
>> +Tracer can not assume that tracee ALWAYS ends its life by reporting
>> +WIFEXITED(status) or WIFSIGNALED(status).
>> +.LP
>> +.\" or can it? Do we include such a promise into ptrace API?
>
> IIRC, we already discussed this... The traced group leader can
> disappear during mt-exec, otherwise the tracee can never go away
> silently.
>
>> +Tracer can kill a tracee with ptrace(PTRACE_KILL, pid, 0, 0). This
>> +operation is deprecated, use kill(SIGKILL) or tgkill(SIGKILL) instead.
>> +The problem with this operation is that it requires tracee to be in
>> +signal-delivery-stop, otherwise it may not work (may complete
>> +successfully but won't kill the tracee),
>
> In short, ptrace(PTRACE_KILL) is more or less ptrace(PTRACE_CONT, SIGKILL),
> but it always returns 0. IOW, it never worked as decribed in the man
> page. And I guess today nobody can explain why PTRACE_KILL exists.
>
> Oleg.

Does your patch need any revision in the light of Oleg's comments?

Thanks,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
