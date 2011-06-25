Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab1FYNn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 09:43:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44562 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab1FYNnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 09:43:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RvAsKTtFKJZ8JNgnYntquSeBU4MWaU6tchuJh6c2qf+xa0CrSpybCA58Juf3WLwdkm
         1ruIzvNUpW+IkfuCIKBuAztFhsnpCgZXdmyNtzeJQFL0ItNxzzfISFscooCZkABnZOfP
         ufff+CYkMMXz/6m6xdCTJuPhclyDZ+pcTfIVA=
Date: Sat, 25 Jun 2011 15:43:50 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, vda.linux@googlemail.com,
        jan.kratochvil@redhat.com, pedro@codesourcery.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_reparented() should check
 same_thread_group()
Message-ID: <20110625134350.GU30101@htj.dyndns.org>
References: <20110624153330.GA9346@redhat.com>
 <20110624153406.GB9346@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110624153406.GB9346@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jun 24, 2011 at 05:34:06PM +0200, Oleg Nesterov wrote:
> exit_notify: we should respect ->exit_signal if the exiting leader
> is traced by any thread from the parent thread group. It is the
> child of the whole group, and we are going to send the signal to
> the whole group.

This seems correct.

> wait_task_zombie: without __WNOTHREAD do_wait() should do the same
> for any thread, only sys_ptrace() is "bound" to the single thread.
> However do_wait(WEXITED) succeeds but does not release a traced
> natural child unless the caller is the tracer.
>
> Test-case:
...
> Note that the main thread simply does
> 
> 	pid = fork();
> 	kill(pid, SIGKILL);
> 
> and then without the patch wait4(WEXITED) succeeds twice and reports
> WTERMSIG(stat) == SIGKILL.

This latter one is interesting to say the least.  Yes, wait(2) is
process-wide operation and should behave identically when for all
threads in the same process.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

This patch involves very subtle behavior change when the tracer is
multi-threaded && real parent of the tracee.  Slightly worrisome but
it is a bug fix and extremely fringe, so...

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
