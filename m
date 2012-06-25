Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2FYIpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:45:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36400 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab2FYIpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:45:52 -0400
Date: Mon, 25 Jun 2012 10:45:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
Message-ID: <20120625084545.GC24512@gmail.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
 <20120622145402.8047a669.akpm@linux-foundation.org>
 <20120623061313.GA21895@gmail.com>
 <1340437465.2274.5.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340437465.2274.5.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Sat, 2012-06-23 at 08:13 +0200, Ingo Molnar wrote:
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Thu, 21 Jun 2012 19:52:03 -0400
> > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > But with the new printk() changes, text without a newline 
> > > > gets buffered and does not print out to the console at the 
> > > > location of the printk.
> > > 
> > > uh, how about we fix that?  The old behaviour was good, the 
> > > new behaviour is noxious.
> > 
> > Absolutely.
> > 
> > pr_flush() really seems to be a workaround.
> 
> I think the new behavior an overall improvement.
> It helps avoid multiple thread interleaving.
> 
> I suggested a fix to enable a printk buffered/non-buffered
> mechanism with an optional printk_flush/pr_flush.
> 
> https://lkml.org/lkml/2012/6/21/305

Ugh, so you suggest a global toggle to turn buffering on/off?

That approach really misses thole whole *point* of printk() and 
debug logging in particular. In most cases when users are 
triggering and reporting problems they don't go around toggling 
various rarely used switches to see whether they make a 
difference. They and kernel developers just take printk output 
at face value and trust it.

Even if people are aware of this global toggle there are 
frequent cases where a hang is probabilistic and occurs only 
very rarely. If a once a year bug triggers then it's obviously 
useful to have good debug output on the screen or in the serial 
log and not wait another year with the debug option turned on 
...

If I cannot trust printk output anymore and would have to toggle 
global switches to make it work then printk() has lost value for 
debugging kernel problems and that would be sad.

So NAK on your patch, really. We should either fix this 
regression in behavior, or, as a second best alternative we 
should at least give a deterministic way to flush the printk 
output, which works all the time.

Thanks,

	Ingo
