Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642Ab2FUSta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 14:49:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12414 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156Ab2FUSt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 14:49:29 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FlAZEPfbBygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=hEXalvAwcFEYwnp2SCkA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340304566.27036.200.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2012 14:49:26 -0400
In-Reply-To: <1340303969.22218.9.camel@joe2Laptop>
References: <20120614154153.GD17140@kroah.com>
	 <1339693625.13377.242.camel@gandalf.stny.rr.com>
	 <20120615042233.GA10973@localhost> <20120615043017.GA9587@kroah.com>
	 <20120615120430.GB23681@gmail.com> <20120615231318.GD8205@kroah.com>
	 <1339804415.25903.63.camel@gandalf.stny.rr.com>
	 <20120618230337.GB23627@kroah.com>
	 <1340069326.25903.177.camel@gandalf.stny.rr.com>
	 <20120620122549.GA10561@gmail.com> <20120621171338.GF3270@kroah.com>
	 <1340300509.27036.185.camel@gandalf.stny.rr.com>
	 <1340302623.22065.9.camel@joe2Laptop>
	 <1340303360.27036.194.camel@gandalf.stny.rr.com>
	 <1340303969.22218.9.camel@joe2Laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 11:39 -0700, Joe Perches wrote:

> > A global buffering disable may cause other things that are printed to be
> > screwed up.
> 
> After Kay's deferral patch (an actual improvement), lots
> of output could have been changed.  Turning off buffering
> would simply revert to pre 3.5 behavior.  I don't think
> that's a significant issue.

But prints that actually require buffering disabled (like the one I'm
using) does so because it may be testing something that may crash the
system. On SMP, that crash could cause garbled output. Yes, it is pre
3.5 behavior, but why have garbled output on the crash when Kay went
through all that effort to have it work.


> 
> > Something that actually expects to be buffered.
> 
> There is nothing today that _expects_ buffering or is
> guaranteed non-buffered.

I'm not saying there is. But if the new buffering system is here, then
there may be something that will _expect_ buffering to be enabled.

> 
> The locations that benefit from non-buffering are few
> and isolated.

Which means we can use individual flushing.

> 
> > Or perhaps have printk_flush() become a new printk. That is,
> > printk_flush("this does not buffer").
> 
> Yuck.
> 
> Then there'd be all the likely variants for
> prefix [pr|dev|netdev]_<level>[_once|_ratelimited] postfix
> too.

Actually, I'm starting to lean back to my original patch, and stick a
pr_flush() in there. As it basically just acts like a barrier. "Make
sure the output I printed actually gets out to the console before I
continue".

-- Steve


