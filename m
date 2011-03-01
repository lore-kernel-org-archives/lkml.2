Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab1CAWOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:14:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37597 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1CAWOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:14:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TmsHNen11EYIwnxayIqWLEx2tM6eYDcyLmPyUEw2dMnBd4tlrt9tPQ/PXP5EynQRX7
         KQMcCzXLNOcpWhUNoQHQvAVLobX5rQSFRNLdvaZm/KikCyKA1sOE6uMeDSLURQmwhDcN
         tfH6CT3QkB1fUZob4Ox4orl0fQEQ4jaPlbN70=
MIME-Version: 1.0
In-Reply-To: <20110301190638.GA12196@host1.dyn.jankratochvil.net>
References: <20110301152457.GE26074@htj.dyndns.org> <20110301190638.GA12196@host1.dyn.jankratochvil.net>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 1 Mar 2011 23:14:14 +0100
Message-ID: <AANLkTiknaHNADRa3R4Tefg2TGuFmKPZY-_08_krFiNFF@mail.gmail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 8:06 PM, Jan Kratochvil
<jan.kratochvil@redhat.com> wrote:
> On Tue, 01 Mar 2011 16:24:57 +0100, Tejun Heo wrote:
>> P4. PTRACE_SEIZE
> [...]
>> Completion notification is delivered in the usual way via wait(2).  If
>> the task was in jctl stop, it would report the stop signal with the
>> matching siginfo.  If the task hits an existing ptrace trap condition,
>> the matching SIGTRAP will be reported; otherwise, SIGTRAP will be
>> reported with siginfo indicating PTRACE_SEIZE trap.
>
> This is a change from the Roland's proposed PTRACE_ATTACH_NOSTOP.

As I see it, Tejun's PTRACE_SEIZE looks almost identical to the sequence of
PTRACE_ATTACH_NOSTOP ("attach, but don't affect current state of the
tracee. In particular, if it runs normally, let it continue to run")
plus
PTRACE_INTERRUPT ("if tracee isn't stopped yet, stop it with magic SIGTRAP").

There may be reasons to have PTRACE_SEIZE operation split like that.
For one, this allows debugger to do PTRACE_CONT, and later issue
PTRACE_INTERRUPT to stop the tracee again. PTRACE_INTERRUPT stop may
be better for some scenarios where debugger wants to make the stop
invisible to the parent, or when debugger wants to stop just one
thread of the process.


> Currently it is already a problem that apps did not / do not expect the first
> waitpid after PTRACE_ATTACH may not be SIGSTOP.

That's exactly why we want to add a better alternative, which doesn't
insert that blasted SIGSTOP.

-- 
vda
