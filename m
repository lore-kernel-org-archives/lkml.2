Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab2FPPiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 11:38:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49589 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab2FPPiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 11:38:14 -0400
Date: Sat, 16 Jun 2012 08:38:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
Message-ID: <20120616153809.GA8062@kroah.com>
References: <20120614045930.GA10508@kroah.com>
 <1339671715.13377.209.camel@gandalf.stny.rr.com>
 <20120614154153.GD17140@kroah.com>
 <1339693625.13377.242.camel@gandalf.stny.rr.com>
 <20120615042233.GA10973@localhost>
 <20120615043017.GA9587@kroah.com>
 <20120615120430.GB23681@gmail.com>
 <20120615231318.GD8205@kroah.com>
 <20120616065903.GA24594@gmail.com>
 <1339851087.11656.3.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339851087.11656.3.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 05:51:27AM -0700, Joe Perches wrote:
> On Sat, 2012-06-16 at 08:59 +0200, Ingo Molnar wrote:
> > * Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > On Fri, Jun 15, 2012 at 02:04:30PM +0200, Ingo Molnar wrote:
> > > > These printk's are useful, are used for a specific (albeit 
> > > > limited) purpose and were and continue to be useful in that 
> > > > role.
> > > > 
> > > > The changes Steve bisected to broke this use of printk().
> > > 
> > > And note, fixed others :)
> > 
> > Sorry, the "we fix some bugs and introduce others" stance is not 
> > a valid response to a regression. Either fix *all* regressions 
> > or revert the original change. Simple and robust policy, isn't 
> > it?
> > 
> > > > Please apply Steve's fix, fix it yourself or revert the 
> > > > changes that regressed printk().
> > > 
> > > I thought Steve's patch was just a RFC thing, is it really 
> > > something that everyone wants to see applied?
> > 
> > You mean the adding of an API to flush buffered output when 
> > that's the desired outcome? Why the heck should we *not* want 
> > that? Either I'm the weird one or you are being difficult ;-)
> 
> The API might be better as a global flag
> not a per-site flush.
> 
> Maybe printk_is_buffered(true/false)

Hm, that sounds a bit better, and I thin it would solve the timestamp
problem that the proposed patch has, right?  We would then just
timestamp on a new line, as we should "know" when that happens?

Steven, do you like this idea better?

thanks,

greg k-h
