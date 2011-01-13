Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab1AMOr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:47:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab1AMOr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:47:57 -0500
Date: Thu, 13 Jan 2011 15:40:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, roland@redhat.com, linux-kernel@vger.kernel.org,
        rjw@sisk.pl
Subject: Re: [PATCH 1/4] signal: fix SIGCONT notification code
Message-ID: <20110113144011.GA28678@redhat.com>
References: <1293016398-18001-1-git-send-email-tj@kernel.org> <1293016398-18001-2-git-send-email-tj@kernel.org> <20110112204136.GB13830@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110112204136.GB13830@host1.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12, Jan Kratochvil wrote:
>
> On Wed, 22 Dec 2010 12:13:15 +0100, Tejun Heo wrote:
> > If SIGCONT is received while the child process is stopped, the code should
> > be CLD_CONTINUED.  If SIGCONT is recieved while the child process is in the
> > process of being stopped, it should be CLD_STOPPED.
>
> If a process does
> 	kill (PID, SIGSTOP);
> 	<varying delay, possibly even from a different process>
> 	kill (PID, SIGCONT);
>
> does it mean the PID's parent may get different waitid() results?

No. The only problem is that SIGCHLD can come with the wrong
info.si_code/si_status

> Or even that PID will finally remain still `T (stopped)'?

No.

> I do not see it has any userland impact,

Yes, the problem is minor.

Still, this is the clear bug due to
SIGNAL_CLD_CONTINUED/SIGNAL_STOP_CONTINUED typo. And damn, it was
introduced by me ;)

> the
> PTRACE_ATTACH-to-T(stopped)-process is already racy for different reasons.

Please note that this bug affects !ptrace case too.

Oleg.

