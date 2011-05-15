Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab1EORrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:47:41 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:52761 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750703Ab1EORrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:47:40 -0400
Date: Sun, 15 May 2011 19:47:22 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: waitpid(WNOHANG) should report SIGCHLD-notified signals  [Re:
 [PATCH 09/11] job control: reorganize wait_task_stopped()]
Message-ID: <20110515174722.GA26361@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-10-git-send-email-tj@kernel.org>
 <20110511154854.GB23688@redhat.com>
 <20110511192902.GC24245@mtj.dyndns.org>
 <20110512154247.GC18599@redhat.com>
 <20110512160253.GK1030@htj.dyndns.org>
 <20110512172506.GA23033@redhat.com>
 <20110512173228.GO1030@htj.dyndns.org>
 <20110515144017.GC31855@host1.jankratochvil.net>
 <20110515164705.GI23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515164705.GI23665@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Sun, 15 May 2011 18:47:05 +0200, Tejun Heo wrote:
> Hmmm... I could easily be wrong but AFAICS that shouldn't happen.  If
> you can reproduce the problem, please let us know.

I was unable to reproduce it before so OK, I will follow now your statement.


> > But if it is a case it should be fixed as there is no later notification when
> > to call waitpid(WNOHANG) again.  And sure the debugger cannot busy-loop poll
> > it.
> 
> But, the current WNOHANG wait is racy.  It's unlikely but definitely
> possible for WNOHANG to fail when it's expected to succeed (not the
> above case but more convoluted ones).

OK, so FYI it breaks current GDB.


> But, just out of curiosity, is there any reason the ptracer itself
> should be doing something other than waitpid() while tracee is
> running?  It's not like ptrace requests can be issued during that time
> and sleeping waitpid() is way saner mechanism to wait for tracee
> events than signal.

If the debugger wants to be single-threaded ("poll() model", not "threads
model") and it wants to communicate with user and examine debuggee symbols and
memory data it cannot use sleeping wait.  GDB is single-threaded and it
supports `set target-async 1': info '(gdb)Background Execution'


Thanks,
Jan
