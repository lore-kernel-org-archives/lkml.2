Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab0EXPQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 11:16:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab0EXPQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 11:16:04 -0400
Date: Mon, 24 May 2010 17:14:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/1] ptrace: PTRACE_GETFDPIC: fix the unsafe usage
	of child->mm
Message-ID: <20100524151445.GA6393@redhat.com>
References: <20100522165401.GB19573@redhat.com> <1266280229-18469-1-git-send-email-vapier@gentoo.org> <1274431345-22366-1-git-send-email-vapier@gentoo.org> <20100521162659.GA16193@redhat.com> <20100521183512.4477F40476@magilla.sf.frob.com> <20100522165320.GA19573@redhat.com> <25539.1274711817@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25539.1274711817@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Now that Mike Frysinger unified the FDPIC ptrace code, we can fix
> > the unsafe usage of child->mm in ptrace_request(PTRACE_GETFDPIC).
> >
> > We have the reference to task_struct, and ptrace_check_attach()
> > verified the tracee is stopped. But nothing can protect from
> > SIGKILL after that, we must not assume child->mm != NULL.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Acked-by: David Howells <dhowells@redhat.com>
>
> Does it make sense to move the call to get_task_mm() up to sys_ptrace() since
> several ptrace functions use it?  The mm pointer could then be handed down the
> ptrace hierarchy.

You mean, pass it to arch_ptrace() ?

grep, grep, grep. I guess I understand you. We have more unsafe code
like this in arch/*/kernel/ptrace.c. Of course, it can be fixed without
doing get_task_mm() in sys_ptrace(), but perhaps it would be more clean
to do what you suggest.

Roland, what do you think?

Oleg.

