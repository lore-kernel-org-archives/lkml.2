Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab1FBK5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 06:57:18 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:50339 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab1FBK5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 06:57:16 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: execve-under-ptrace API bug (was Re: Ptrace documentation, draft #3)
Date: Thu, 2 Jun 2011 11:57:12 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com> <201105310143.12280.vda.linux@googlemail.com> <20110531135116.GA4799@redhat.com>
In-Reply-To: <20110531135116.GA4799@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106021157.13367.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 May 2011 14:51:16, Oleg Nesterov wrote:

> The main problem is: it is not clear do we really want EVENT_EXIT
> in this case. I think we do, Roland thought we do not. OTOH I never
> really the purpose of EVENT_EXIT, but this doesn't matter.
> 
> If we decide we do want this notification (in this case), then we
> need fixes. EVENT_EXIT is not reliable. Say, the thread can exit
> before it dequeues SIGKILL and in this case it doesn't stop.
> Also. If we guarantee EVENT_EXIT in this case, then probably the
> implicit SIGKILL should not wakeup the TASK_TRACED tracee (except
> the new PTRACE_LISTEN case).
> 
> In short: currently I do not know what should be documented. I do
> not know the original intent, I can only see what the code actually
> does. 

Daniel Jacobowitz said when he submitted it:

<http://lkml.indiana.edu/hypermail/linux/kernel/0302.0/1051.html>

"PTRACE_EVENT_EXIT, which triggers in do_exit().  This is useful to quickly
 find out where a program is making an exit syscall from, etc. - it
 triggers before the mm is released, so we can still get backtraces et
 cetera."

That said, GDB was never made to use it:

  /* Do not enable PTRACE_O_TRACEEXIT until GDB is more prepared to support
     read-only process state.  */

-- 
Pedro Alves
