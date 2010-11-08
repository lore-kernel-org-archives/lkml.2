Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab0KHSlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:41:09 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50462 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab0KHSlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:41:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nxH+VVhBqrvwEqKnzhe7KscWnR+rxHxwVj78iL4NqAcPpytDKtaq1Js/fSrfaMp6k8
         u+jAAcuIzpN/fI+wo3wOTJMyJ8OHUTXIVI2NAUz+GAOeMgzez7T4fI3CQBPXzWQ8WwIq
         fJlBJmazmf9mRXcrbLKZM3iZQ8/qz+Vm/Kl+4=
Date: Mon, 8 Nov 2010 19:41:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && task->ptrace_bps[]
Message-ID: <20101108184057.GB5375@nowhere>
References: <20101108145647.GA3426@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108145647.GA3426@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 03:56:47PM +0100, Oleg Nesterov wrote:
> Hello.
> 
> I am trying to understand the usage of hw-breakpoints in arch_ptrace().
> ptrace_set_debugreg() and related code looks obviously racy. Nothing
> protects us against flush_ptrace_hw_breakpoint() called by the dying
> tracee. Afaics we can leak perf_event or use the already freed memory
> or both.
> 
> Am I missed something?
> 
> Looking into the git history, I don't even know which patch should be
> blamed (if I am right), there were too many changes. I noticed that
> 2ebd4ffb6d0cb877787b1e42be8485820158857e "perf events: Split out task
> search into helper" moved the PF_EXITING check from find_get_context().
> This check coould help if sys_ptrace() races with SIGKILL, but it was
> racy anyway.
> 
> It is not clear to me what should be done. Looking more, I do not
> understand the scope of perf_event/ctx at all, sys_perf_event_open()
> looks wrong too, see the next email I am going to send.
> 
> Oleg.
> 


But I don't understand how ptrace_set_debugreg() and flush_old_exec() can
happen at the same time. The parent can only do the ptrace request when
the child is stopped, right? But it can't be stopped in flush_old_exec()...?

Not sure how any race can happen here. I am certainly missing something obvious.

Thanks.

