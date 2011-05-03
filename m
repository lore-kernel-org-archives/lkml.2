Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab1ECIkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 04:40:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab1ECIkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 04:40:09 -0400
Message-ID: <4DBFBF3F.7060203@redhat.com>
Date: Tue, 03 May 2011 11:39:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110421 Fedora/3.1.9-2.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: linux-kernel@vger.kernel.org, kees.cook@canonical.com, eparis@redhat.com,
        agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        rostedt@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call filtering
References: <1303960136-14298-1-git-send-email-wad@chromium.org> <1303960136-14298-2-git-send-email-wad@chromium.org>
In-Reply-To: <1303960136-14298-2-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2011 06:08 AM, Will Drewry wrote:
> This change adds a new seccomp mode based on the work by
> agl@chromium.org. This mode comes with a bitmask of NR_syscalls size and
> an optional linked list of seccomp_filter objects. When in mode 2, all
> system calls are first checked against the bitmask to determine if they
> are allowed or denied.  If allowed, the list of filters is checked for
> the given syscall number. If all filter predicates for the system call
> match or the system call was allowed without restriction, the process
> continues. Otherwise, it is killed and a KERN_INFO notification is
> posted.
>
> The filter language itself is provided by the ftrace filter engine.
> Related patches tweak to the perf filter trace and free allow the calls
> to be shared. Filters inherit their understanding of types and arguments
> for each system call from the CONFIG_FTRACE_SYSCALLS subsystem which
> predefines this information in syscall_metadata associated enter_event
> (and exit_event) structures.
>
> The result is that a process may reduce its available interfaces to
> the kernel through prctl() without knowing the appropriate system call
> number a priori and with the flexibility of filtering based on
> register-stored arguments.  (String checks suffer from TOCTOU issues and
> should be left to LSMs to provide policy for! Don't get greedy :)

This is potentially very useful for qemu/kvm.

-- 
error compiling committee.c: too many arguments to function

