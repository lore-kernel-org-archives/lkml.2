Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1DFM6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:58:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984Ab1DFM6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:58:35 -0400
Date: Wed, 6 Apr 2011 14:57:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 1/5] signals: Always place SIGCONT and SIGSTOP on
	'shared_pending'
Message-ID: <20110406125757.GA12099@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org> <1302031310-1765-2-git-send-email-matt@console-pimps.org> <20110405201958.GA1404@redhat.com> <20110405215003.636e950b@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110405215003.636e950b@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05, Matt Fleming wrote:
>
> On Tue, 5 Apr 2011 22:19:58 +0200
>
> > SIGSTOP can't have the handler, still we shouldn't place it on the
> > shared list, debuggers won't be happy.
>
> Urgh, debuggers actually peek at shared_pending and pending?

Argh, sorry, I was not clear.

First of all, only SIGSTOP is never delivered to user-space, other
sig_kernel_stop() signals can have a handler and in this case, say,
SIGTTIN doesn't stop but acts like the normal signal. This means you
can't put it into shared_pending.

But even SIGSTOP should be routed properly. If the process is ptraced,
the tracee reports SIGSTOP to the debugger first. This means that
tkill(SIGSTOP) should be delivered to the right target.

> > Also. This code was changed very much, please do these changes on
> > top of
> > http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=refs/heads/ptrace
>
> My patches are already based on that tree.

Ah, good.

Oleg.

