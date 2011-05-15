Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992Ab1EOOkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 10:40:40 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:53099 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754333Ab1EOOkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 10:40:37 -0400
Date: Sun, 15 May 2011 16:40:17 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: waitpid(WNOHANG) should report SIGCHLD-notified signals  [Re: [PATCH
 09/11] job control: reorganize wait_task_stopped()]
Message-ID: <20110515144017.GC31855@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-10-git-send-email-tj@kernel.org>
 <20110511154854.GB23688@redhat.com>
 <20110511192902.GC24245@mtj.dyndns.org>
 <20110512154247.GC18599@redhat.com>
 <20110512160253.GK1030@htj.dyndns.org>
 <20110512172506.GA23033@redhat.com>
 <20110512173228.GO1030@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512173228.GO1030@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011 19:32:28 +0200, Tejun Heo wrote:
[...]
> 	  while (1) {
> 		  siginfo_t si = {};
> 
> 		  waitid(P_PID, child, &si,
> 			 WSTOPPED | WCONTINUED | WNOWAIT | WNOHANG);
> 		  if (!si.si_pid)
> 			  break;
> 	  }
> 
> 	  kill(control, SIGKILL);
> 	  kill(child, SIGKILL);
> 	  return 0;
>   }
> 
> waitid(2) should always succeed as it's never consuming wait state,
> but it does, with or without the patch.  All transitions need to be
> made water tight to remove the bug.

It may be not related, I do not inderstand the kernel internals being
discussed.

I was told by Roland McGrath that after SIGCHLD of a ptrace even from tracee
invokes sighandler for that SIGCHLD in the tracer then waitpid(WNOHANG) still
may return 0 as the signal is not yet ready.  I was not able to reproduce it
with a testcase myself.

But if it is a case it should be fixed as there is no later notification when
to call waitpid(WNOHANG) again.  And sure the debugger cannot busy-loop poll
it.


Thanks,
Jan
