Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab1CZKYL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 06:24:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:56511 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1CZKYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 06:24:09 -0400
Subject: Re: [PATCH] sched: leave sched_setscheduler earlier if possible.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Junio C Hamano <junio@pobox.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Dario Faggioli <raistlin@linux.it>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Gregory Haskins <ghaskins@novell.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>
In-Reply-To: <7vzkoi4yl3.fsf@alter.siamese.dyndns.org>
References: <1300971618.3960.82.camel@Palantir>
	 <1300976519.14261.141.camel@gandalf.stny.rr.com>
	 <1301048910.2250.184.camel@laptop>
	 <1301057573.14261.168.camel@gandalf.stny.rr.com>
	 <1301058430.2250.211.camel@laptop>
	 <7vzkoi4yl3.fsf@alter.siamese.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 11:26:13 +0100
Message-ID: <1301135173.2250.324.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 15:36 -0700, Junio C Hamano wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> 
> > Junio, know of any way to make git-diff do the same? The purpose is to
> > skip labels as functions so that people stop doing stupid crap like
> > indenting labels, eg.:
> >
> > void foo(void)
> > {
> >  again:
> 
> Perhaps "git help attributes" and look for "funcname"?

Awesome so the diff.$foo.xfuncname is about what I want, except I seem
to need a .gitattributes file per repository. 

Is there a way to over-ride the default in a global way so that I can
only change ~/.gitconfig and not bother with all various repos I have?

Another question, the built-in patterns consist of multiple regexes, can
custom patterns also have multiple?


So what worked for me was:

~/.gitconfig:

[diff "cpp"]
	xfuncname = "^[[:alpha:]$_].*[^:]$"

and linux-2.6/.gitattributes:

*.h diff=cpp
*.c diff=cpp

What I tried was:

[diff]
  xfuncname = "^[[:alpha:]$_].*[^:]$"

But that didn't seem to work.. I also tried ~/.gitattributes, but again,
no joy.



