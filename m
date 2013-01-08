Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3AHWkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:40:31 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55366 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3AHWk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:40:29 -0500
Date: Tue, 8 Jan 2013 14:40:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [add to stable] ftrace: Do not function trace inlined functions
Message-ID: <20130108224025.GA20323@kroah.com>
References: <1357681121.5190.42.camel@gandalf.local.home>
 <20130108221006.GA29782@kroah.com>
 <1357683913.5190.47.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357683913.5190.47.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 05:25:13PM -0500, Steven Rostedt wrote:
> On Tue, 2013-01-08 at 14:10 -0800, Greg Kroah-Hartman wrote:
> > On Tue, Jan 08, 2013 at 04:38:41PM -0500, Steven Rostedt wrote:
> > > Hi Greg and Ben,
> > > 
> > > Can you add commit 45959ee7aa645815a5ce303a0ea1e48a21e67c6a to the
> > > stable trees.
> > 
> > That showed up in 3.3-rc1, so I don't think it's needed in 3.2-stable.
> 
> Well, it should have been marked for stable, which means it missed 3.2.

Ugh, you are right, sorry about that, too many kernels being kept track
of here has fried my "which one is newer" circuts...  I was meaning "3.4
and 3.7" here.

> > 
> > But why add it now?  What does it "fix" for 3.4 and 3.7?
> > 
> 
> When gcc doesn't inline a function marked inline (with different
> compilers, it does different things), a function that shouldn't be
> traced gets traced by the function tracer. The result is a kernel crash,
> which usually ends up being a triple fault (automatic reboot, hard to
> debug).
> 
> That's because some low level function like local_irqs_disable() gets
> traced, which is used in the function tracer recursion protection. Which
> means, that it's outside the recursion protection and when you enable
> function tracing, it causes the system to reboot.
> 
> Thomas just hit this on 3.2-rt, and was asking me why it wasn't marked
> for stable. I just didn't think of it at the time.

Ok, fair enough, I'll queue it up for 3.0

greg k-h
