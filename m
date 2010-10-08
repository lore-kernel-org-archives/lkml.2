Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0JHHW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:22:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45057 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753916Ab0JHHW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:22:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/tUKRNBJ/tvKXkvcQgX37L/8u+0iwRF843phh0rH
	h4UOmc3qOswiWb
Subject: Re: [PATCH 0/3][RFC] Improve load balancing when tasks have large
 weight differential
From: Mike Galbraith <efault@gmx.de>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinf7fj5A4DnQOWdj8QeMhf4exPGgpMUdTGA9mTC@mail.gmail.com>
References: <1285633798-26886-1-git-send-email-ncrao@google.com>
	 <1285682273.7469.3.camel@marge.simson.net>
	 <AANLkTin=Dic2UE55yUaam8NzGHTib=9s=x-wyzk03BU0@mail.gmail.com>
	 <1285724758.7440.11.camel@marge.simson.net>
	 <AANLkTi=TQnYGLPC=Pi0o1As83W6VdWdjvimZNSrGT4qW@mail.gmail.com>
	 <1286161717.7410.12.camel@marge.simson.net>
	 <AANLkTinf7fj5A4DnQOWdj8QeMhf4exPGgpMUdTGA9mTC@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 08 Oct 2010 09:22:23 +0200
Message-Id: <1286522543.8189.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 01:23 -0700, Nikhil Rao wrote:
> On Sun, Oct 3, 2010 at 8:08 PM, Mike Galbraith <efault@gmx.de> wrote:
> > On Wed, 2010-09-29 at 12:32 -0700, Nikhil Rao wrote:
> >> The closest I have is a quad-core dual-socket machine (MC, CPU
> >> domains). And I'm having trouble reproducing it on that machine as
> >> well :-( I ran 5 soaker threads (one of them niced to -15) for a few
> >> hours and didn't see the problem. Can you please give me some trace
> >> data & schedstats to work with?
> >
> > Booting with isolcpus or offlining the excess should help.
> >
> 
> Sorry for the late reply. Booting with isolcpus did the trick, thanks.
> 
> ... and now to dig into why this is happening.

I was poking it (again) yesterday, and it's kind of annoying.  I can't
call this behavior black/white broken.  It's freeing up a cache for a
very high priority task, which is kinda nice, but SMP nice is costing
25% of my box's processor power in this case too.  Hrmph.

	-Mike

