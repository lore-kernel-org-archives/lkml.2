Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab1D1QxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:53:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32858 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab1D1QxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:53:20 -0400
MIME-Version: 1.0
In-Reply-To: <1304008096.18763.151.camel@gandalf.stny.rr.com>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	<1303960136-14298-2-git-send-email-wad@chromium.org>
	<1304008096.18763.151.camel@gandalf.stny.rr.com>
Date: Thu, 28 Apr 2011 11:53:19 -0500
Message-ID: <BANLkTinrg3E_XYERndJ=fwgRNSmPHcsr9w@mail.gmail.com>
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call filtering
From: Will Drewry <wad@chromium.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com, eparis@redhat.com,
        agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 11:28 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-04-27 at 22:08 -0500, Will Drewry wrote:
>
>> The only other twist is that it is possible to delay enforcement by one
>> system call by supplying a "on_next_syscall: 1" 'filter'.  This allows
>> for a launcher process to fork(), prctl(), then execve() leaving the
>> launched binary in a filtered state.
>
> I wonder if the more "unixy" thing to do is, instead of on_next_sycall,
> have "enable_on_exec". Where the user could do multiple syscalls but the
> filter will not take place until an exec is made?

That's what it was originally, but since ftrace syscalls doesn't wrap
sys_execve on x86, I opted to just say "next syscall".  But of course
I can just check the _NR_execve == syscall_nr and do the right thing.
Duh.

thanks!
