Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1FBPCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 11:02:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61288 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1FBPCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 11:02:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LOJeiYvjHmzcSctS7ZAp9VKhhZt76gTZzkrjnCiZwlC9uuwHmxOHeCm+XuSrLvIc9R
         kkATvfd5/FO62xOrxkOHCvjrsf42p040cv/owXGUkr1PrX7ETA7cWrITXMIBMQFNfwti
         jY2AXzC+GofW4ent9acBWEZL3ME5pKqQDfdGU=
MIME-Version: 1.0
In-Reply-To: <201106021157.13367.pedro@codesourcery.com>
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com>
 <201105310143.12280.vda.linux@googlemail.com> <20110531135116.GA4799@redhat.com>
 <201106021157.13367.pedro@codesourcery.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 2 Jun 2011 16:59:48 +0200
Message-ID: <BANLkTinY97cJACinjneQkZgEcLQGFoe2Pw@mail.gmail.com>
Subject: Re: execve-under-ptrace API bug (was Re: Ptrace documentation, draft #3)
To: Pedro Alves <pedro@codesourcery.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 12:57 PM, Pedro Alves <pedro@codesourcery.com> wrote:
> On Tuesday 31 May 2011 14:51:16, Oleg Nesterov wrote:
>
>> The main problem is: it is not clear do we really want EVENT_EXIT
>> in this case. I think we do, Roland thought we do not. OTOH I never
>> really the purpose of EVENT_EXIT, but this doesn't matter.
>>
>> If we decide we do want this notification (in this case), then we
>> need fixes. EVENT_EXIT is not reliable. Say, the thread can exit
>> before it dequeues SIGKILL and in this case it doesn't stop.
>> Also. If we guarantee EVENT_EXIT in this case, then probably the
>> implicit SIGKILL should not wakeup the TASK_TRACED tracee (except
>> the new PTRACE_LISTEN case).
>>
>> In short: currently I do not know what should be documented. I do
>> not know the original intent, I can only see what the code actually
>> does.
>
> Daniel Jacobowitz said when he submitted it:
>
> <http://lkml.indiana.edu/hypermail/linux/kernel/0302.0/1051.html>
>
> "PTRACE_EVENT_EXIT, which triggers in do_exit().  This is useful to quickly
>  find out where a program is making an exit syscall from, etc. - it
>  triggers before the mm is released, so we can still get backtraces et
>  cetera."

We have circa 340 syscalls. What makes exit so special that it has to have
a separate ptrace stop specially for it? People may legitimately
want to know where write() syscall happens, should we add
PTRACE_EVENT_WRITE? Rinse, repeat...

-- 
vda
