Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab2FHRwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:52:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28652 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040Ab2FHRwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:52:16 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=szWgSEt-72UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=ar00d73-CmVkTEwMRkoA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339177929.13377.66.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/3] x86: Remove cmpxchg from i386 NMI nesting code
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 08 Jun 2012 13:52:09 -0400
In-Reply-To: <4FD238CD.8000601@zytor.com>
References: <20120608135200.371649691@goodmis.org>
	   <20120608135603.699156773@goodmis.org> <4FD223E1.1090707@zytor.com>
	  <1339173716.13377.50.camel@gandalf.stny.rr.com>
	  <4FD23626.4020802@zytor.com>
	 <1339176975.13377.56.camel@gandalf.stny.rr.com>
	 <4FD238CD.8000601@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 10:39 -0700, H. Peter Anvin wrote:
> On 06/08/2012 10:36 AM, Steven Rostedt wrote:
> >>
> >> On i386 it's infinite, but again, I don't think the code will ever be
> >> exercised on i386.  I'm much more concerned about performance on current
> >> processors.
> > 
> > I'm not worried about non i386 here. Some context missing from the patch
> > is that this code is surrounded by:
> > 
> 
> Sorry, I meant i386 as in actual i386 processors, as opposed to modern
> processors in 32-bit mode.
> 

Fair enough. But still, I think a dec_and_test() is nicer (even if we
use this_cpu_dec_and_return()). That's the rational for this change in
the first place, with an added benefit that it would work with the
fictional i386 old processor that does NMIs but no cmpxchg.

Not to mention that I would love to make all users that have x86_64
machines running i386 kernels, for something other than testing i386,
thrown into a large boiling pot of clue stew. It really pisses me off
when people run these i386 machines with 16 gigs of memory and complain
about performance. highmem should be disabled for any x86_64 box with
more than 1G of RAM running an i386 kernel with a nasty message on boot
up:

"Idiot! Why the f*ck are you running i386 on your nice shiny new x86_64
machine, with Umpteen Gigs of RAM. Boot a x86_64 kernel for Christ sake
and get your full potential. Your i386 userspace will still work just
fine on it. You're like one of those 75 year old retirees that can
finally buy a Porsche just to drive it 10 miles per hour below the speed
limit with a line of cars behind them!"

-- Steve


