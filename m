Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148Ab1EORPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:15:41 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:36061 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752020Ab1EORPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:15:41 -0400
Date: Sun, 15 May 2011 19:15:12 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_SEIZE should not stop  [Re: [PATCH 02/11] ptrace:
 implement PTRACE_SEIZE]
Message-ID: <20110515171512.GA24047@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110515155602.GD31855@host1.jankratochvil.net>
 <20110515162630.GG23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515162630.GG23665@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 May 2011 18:26:30 +0200, Tejun Heo wrote:
> the code to SEIZE and establish initial state would be simple.

In normal case yes; but one needs to handle all the corner cases when the
first signal is not INTERRUPT; which one usually does not handle as during
development (=in normal cases) it is always INTERRUPT.

Such thing is even difficult to test in QA testcases as in some cases one just
cannot reproduce the (in current case) non-SIGSTOP signal arriving as first
one.


> How long does it take to attach to / detach from 10000+ threads?  If
> you don't do it serially, it shouldn't take that long.

It is not (such) a problem it takes time.  It is a problem it stops the tracee
for a moment which completely changes the tracee's racy behavior one tries to
debug.


> You can tell them apart from userland and it doesn't matter which order or
> how many times INTERRUPT occurs.

I must know in which order they come to know when the tracee is still stopped
and I collect the signals to be displayed to the user and at which moment
there are no more signals in the queue and I start waiting on the debuggee
which started running.

Otherwise I can workaround it by various waitpid(NOHANG)s but it is better if
the ordering and when INTERRUPT is / is not reported is well defined.


Thanks,
Jan
