Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1CYNFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:05:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:41493 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1CYNFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:05:05 -0400
Subject: Re: [PATCH] sched: leave sched_setscheduler earlier if possible.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dario Faggioli <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gregory Haskins <ghaskins@novell.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>, Junio C Hamano <junio@pobox.com>
In-Reply-To: <1301057573.14261.168.camel@gandalf.stny.rr.com>
References: <1300971618.3960.82.camel@Palantir>
	 <1300976519.14261.141.camel@gandalf.stny.rr.com>
	 <1301048910.2250.184.camel@laptop>
	 <1301057573.14261.168.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 14:07:10 +0100
Message-ID: <1301058430.2250.211.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 08:52 -0400, Steven Rostedt wrote:
> > And you know I prefer to fix the tools ;-)
> 
> And when the tools are fixed, I'll also prefer
> 
So instead of complaining about it, tell people to use:

QUILT_DIFF_OPTS="-F ^[[:alpha:]\$_].*[^:]\$"

Just like you tell them about all your other patch style issues.

Junio, know of any way to make git-diff do the same? The purpose is to
skip labels as functions so that people stop doing stupid crap like
indenting labels, eg.:

void foo(void)
{
 again:
	/* do stuff */
	if (retry)
		goto again;
}

instead of the normal:

void foo(void)
{
again:
	/* do stuff */
	if (retry)
		goto again;
}

