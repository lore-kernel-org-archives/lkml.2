Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1BUOcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:32:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab1BUOcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:32:01 -0500
Date: Mon, 21 Feb 2011 15:23:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110221142325.GA16664@redhat.com>
References: <20110219201603.GB8662@redhat.com> <20110219200637.GA8662@redhat.com> <20110220094050.GA7714@host1.dyn.jankratochvil.net> <20110220171658.GA27355@redhat.com> <20110220185204.GA14737@host1.dyn.jankratochvil.net> <20110220203819.GB32682@redhat.com> <20110220212053.GA23412@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110220212053.GA23412@host1.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Jan Kratochvil wrote:
>
> On Sun, 20 Feb 2011 21:38:19 +0100, Oleg Nesterov wrote:
>
> > So. So far I assume you are not against this change ;)
>
> No, although you should provide the patch in advance, it would be nice to also
> post it first to <gdb@sourceware.org> for comments.

OK.

> Now if new GDB should allow inferior functions calls on previously
> `(T) stopped' process doing PTRACE_CONT(SIGCONT)

No, no, this won't work. You need to send SIGCONT via kill/tkill. Once
again, we can add the special case for PTRACE_CONT(SIGCONT), but please
look at Roland's comment: http://marc.info/?l=linux-kernel&m=129796917823181

And given that currently gdb does PTRACE_CONT(0) this special case can't
help anyway unless you change gdb.

> but how to make it `(T) stopped' afterwards?  PTRACE_CONT(SIGSTOP)
> right after the inferior call will make the old kernels run the inferior - we
> do not want that.

Hmm... probably I am totally confused... but PTRACE_CONT(SIGSTOP)
should work in this case, the tracee reports SIGTRAP after the single-step
(if I understand correctly how gdb implements this).

Oleg.

