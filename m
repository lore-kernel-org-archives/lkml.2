Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab1F1AdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 20:33:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60700 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab1F1Ab3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 20:31:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xUlzTH3x+5uTYbf+1qC3eVarBc+oRo/23kQUBTLv0lUwI4LO1DAQdbbC1sdO1x1IQ+
         Bhu3xStZwrClD59R28CDipa2RTLb3pFUDF6AUihJ0RXk0diTrzwMNk667f03zjh1dHtB
         0I7TX5aYx1YxF1dU16fn54eaZriK9e4ACZnXc=
MIME-Version: 1.0
In-Reply-To: <20110626200442.GA16293@redhat.com>
References: <201106262108.43011.vda.linux@googlemail.com> <20110626200442.GA16293@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 28 Jun 2011 02:31:08 +0200
Message-ID: <BANLkTi=ST3TZq2FaMfPG8h6ug+e-Q_98CA@mail.gmail.com>
Subject: Re: [PATCH] ptrace: make former thread ID available via
 PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop (v.2)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 10:04 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> +                     pid_t old_pid = old_pid; /* for compiler */
>
> we have uninitialized_var() for this,
>
>        pid_t uninitialized_var(old_pid);
>
>> -                     retval = fn(bprm, regs);
>> +                     if (task_ptrace(current) & PT_PTRACED) {
>
> May be PT_TRACE_EXEC makes more sense. Note that ptrace_event_enabled() was
> recently added.
>
>> +                             /* Need to fetch pid before load_binary changes it */
>> +                             rcu_read_lock();
>> +                             old_pid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
>
> OK, this looks correct. But imho this code looks strange inside the
> for (;;) loop. Perhaps it would be more clean to record the old pid
> before.
>
>>                               if (depth == 0)
>> -                                     tracehook_report_exec(fmt, bprm, regs);
>> +                                     tracehook_report_exec(fmt, bprm, regs, old_pid);
>
> Heh, you are out of luck ;) This hook was already killed. Please redo
> against git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git ptrace

I just sent rediffed version against this branch as a separate mail.

I think I addressed all your concerns in it.

-- 
vda
