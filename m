Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2KYWzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 17:55:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab2KYWzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 17:55:35 -0500
Date: Sun, 25 Nov 2012 23:55:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: arch_check_bp_in_kernelspace: fix the range check
Message-ID: <20121125225533.GA24905@redhat.com>
References: <20121123163320.GA32716@redhat.com> <20121124134511.47C5A592076@miso.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121124134511.47C5A592076@miso.sublimeip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25, Amnon Shiloh wrote:
>
> 2) I was then told (in my own words): "oh, don't worry, the vsyscall page
>    has now been minimized, all it contains now is *real* system calls,
>    and it always calls them".

Not sure where did you get this idea ;) From the very beginning you were
told that EMULATE mode doesn't do this.

The NATIVE mode should be fine, yes.

> 6) I just suggested an alternative: to have the whole vsyscall page
>    removed on a per-process basis. I accept your reply that this is
>    not possible.

Yes, this is not possible.

> 7) I suggested a third alternative: to have the vsyscall page be
>    unexecutable on a per-process basis,

Like above, this is simply not possible. And at the same time the
vsyscall page is already unexecutable in EMULATE mode, but globally.

> 8) Any solution that allows a ptracer to prevent its traced process
>    from entering the vsyscall page and execute there system-calls
>    unchecked (thus in effect escape its jailer), would do for me.

Well. I am even more confused... probably this was already discussed
and I missed this, but.

Why do you need to _prevent_, say, sys_gettimeofday()? Why we can't
change emulate_vsyscall() to respect PTRACE_SYSCALL and report
TRAP_VSYSCALL or PTRACE_EVENT_VSYSCALL as I tried to suggest in
http://marc.info/?l=linux-kernel&m=135343635523715 ?

You previously replied that this can not work. Now that you see that
this _can_ work, could you please explain why this is not enough?

Oleg.

