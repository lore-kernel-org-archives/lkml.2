Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab1JDRdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:33:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701Ab1JDRdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:33:54 -0400
Date: Tue, 4 Oct 2011 19:29:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
Message-ID: <20111004172938.GB3489@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org> <20110930165206.GA22048@redhat.com> <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com> <20111003131610.GA26823@redhat.com> <1317718577.3375.103.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317718577.3375.103.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Matt Fleming wrote:
>
> Ah, I think it was these lines that confused me into thinking
> ->ctrl_lock wasn't required around PF_EXITING,
>
> void exit_signals(struct task_struct *tsk)
> {
>         int group_stop = 0;
>         sigset_t unblocked;
>
>         if (thread_group_empty(tsk) || signal_group_exit(tsk->signal)) {
>                 tsk->flags |= PF_EXITING;
>                 return;
>         }
>
> But I guess that's safe because either we're the only thread in the
> group or the group is already going to exit?

Yes. Except s/exit/exit or exec/.

And this reminds me... This is not exactly right. I do not mean
this particular function, but the whole logic. An execing process
can miss SIGSTOP. Or the coredumping signal.

Oleg.

