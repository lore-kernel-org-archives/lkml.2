Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab2F0FxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 01:53:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46777 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2F0FxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 01:53:04 -0400
Date: Wed, 27 Jun 2012 07:52:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] printk: Revert the buffered-printk() changes for now
Message-ID: <20120627055255.GC14913@gmail.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
 <20120622145402.8047a669.akpm@linux-foundation.org>
 <20120623061313.GA21895@gmail.com>
 <1340452052.1784.40.camel@mop>
 <20120625090933.GD24512@gmail.com>
 <CAPXgP10E7HNDQ73ZFyb4EyDVBko2yXs8Rw0KOSKukGUpSBSz_g@mail.gmail.com>
 <20120625140748.GB1301@gmail.com>
 <1340635734.27036.327.camel@gandalf.stny.rr.com>
 <20120625164033.GA14000@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625164033.GA14000@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Mon, Jun 25, 2012 at 10:48:54AM -0400, Steven Rostedt wrote:
> > On Mon, 2012-06-25 at 16:07 +0200, Ingo Molnar wrote:
> > 
> > > System logging is an arguably secondary role, and it 
> > > should not degrade printk()s primary role.
> > 
> > I would argue that printk() should not play the role of 
> > normal system logging. It's main role should be for boot up 
> > and crashes. If devices need to log information to 
> > userspace, it should really use some other means. What was 
> > /sys made for anyway?
> 
> Specifically not for logging.  See the very old discussions of 
> this a long time ago (back in the 2.5 days), if you are 
> curious.
> 
> printk() is the best thing we have for logging as everyone 
> uses it and the information in it is exactly what userspace 
> wants to know about. Because of that, why wouldn't we use it?

I agree with Greg's point there: the reality is that we have 
over 50,000 printk() sites in the kernel, which is a heck of a 
good source of system logging information, which we are not 
going to change over to some other facility, even if we had some 
marginal reasons to do it.

Just consider the life time of printk() call sites: in most 
cases it gets added as a debugging printout, as a: "Hey, I just 
finished reading Linux Device Drivers, 3rd Edition, and this 
best ever Linux driver is now ALIVE!!" tag of success.

Then it gets extended with a few more printouts of unexpected 
behavior: "So, if you got here the hardware must be buggy or you 
must be doing something stupid, as the driver code sure as heck 
is perfect".

Most of the printk()s get removed during productization, but 
some actually make sense and remain (and some don't make sense 
but just never trigger).

Very few people add printk()s as "inform the system logging 
daemon about an event". The prevailing mindset is that perfect 
code does not need any logging, so what is left are over 50,000 
call sites of bragging and debugging code, occasionally massaged 
to be somewhat user friendly.

System logging and tracing in particular can hook off this 
mechanism, but we probably aren't going to change the social 
role of printk()s overnight (or ever).

> Anyway, your "never buffer printk data" patch looks like the 
> right solution here, I'm guessing you are going to respin it 
> based on the feedback so far, right?

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
