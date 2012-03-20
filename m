Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030712Ab2CTRLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 13:11:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40914 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814Ab2CTRLE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 13:11:04 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1203201758220.2542@ionos>
References: <20120319231253.GA20893@www.outflux.net>
	<20120320133141.GC2918@peqn>
	<alpine.LFD.2.02.1203201758220.2542@ionos>
Date: Tue, 20 Mar 2012 10:11:02 -0700
X-Google-Sender-Auth: 6R-b-1e1wvkG7puyBegXZnYpYQ0
Message-ID: <CAGXu5jKVx41+NSEWsw0YF74z5_heSQ6GOmkuDi1DXNPcO4sjTQ@mail.gmail.com>
Subject: Re: [PATCH] futex: do not leak robust list to unprivileged process
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, linux-kernel@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        kernel-hardening@lists.openwall.com, spender@grsecurity.net,
        mingo@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 10:02 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 20 Mar 2012, Serge Hallyn wrote:
>
>> Quoting Kees Cook (keescook@chromium.org):
>> > It was possible to extract the robust list head address from a setuid
>> > process if it had used set_robust_list(), allowing an ASLR info leak. This
>> > changes the permission checks to be the same as those used for similar
>> > info that comes out of /proc.
>> >
>> > Running a setuid program that uses robust futexes would have had:
>> >   cred->euid != pcred->euid
>> >   cred->euid == pcred->uid
>> > so the old permissions check would allow it. I'm not aware of any setuid
>> > programs that use robust futexes, so this is just a preventative measure.
>> >
>> > (This patch is based on changes from grsecurity.)
>> >
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>> I like the change.  Much cleaner.  I'm not 100% sure though that
>> there are no legitimate cases of robust futexes use which would now
>> be forbidden.  (Explicitly cc:ing Ingo)
>
> get_robust_list is not necessary for robust futexes. There is no
> reference to get_robust_list in glibc.
>
> I really wonder why we have this syscall at all.

The documentation I found yesterday while looking at this was:
http://linux.die.net/man/2/get_robust_list

Which says "The system call is only available for debugging purposes
and is not needed for normal operations. Both system calls are not
available to application programs as functions; they can be called
using the syscall(3) function."

Dropping the syscall entirely would certainly make it secure. ;)

-Kees

-- 
Kees Cook
ChromeOS Security
