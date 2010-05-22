Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0EVOSb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 10:18:31 -0400
Received: from www.tglx.de ([62.245.132.106]:56057 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab0EVOS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 10:18:29 -0400
Date: Sat, 22 May 2010 16:18:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, John Stultz <johnstul@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] Negative time on Acer Ferrari One with current
 -git
In-Reply-To: <alpine.LFD.2.00.1005221429360.3368@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1005221616310.3368@localhost.localdomain>
References: <201005212343.25184.rjw@sisk.pl> <alpine.LFD.2.00.1005211515460.3689@i5.linux-foundation.org> <alpine.LFD.2.00.1005221429360.3368@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 May 2010, Thomas Gleixner wrote:
> On Fri, 21 May 2010, Linus Torvalds wrote:
> > On Fri, 21 May 2010, Rafael J. Wysocki wrote:
> > > 
> > > Trying to boot current -git on Acer Ferrari One (64-bit), I get mount errors
> > > for all filesystems telling me that "now = (null) is in the future" and when
> > > run 'date' it says: "date: time <long negative number> is out of range".
> > > 
> > > Any ideas anyone?
> > 
> > No ideas, but apart from the obvious "maybe you can pin it down a bit with 
> > a few bisection compiles", it's almost certainly through the timer tree 
> > merge from Thomas, which included various wall-clock-time changes from 
> > John Stultz & co.
> > 
> > I don't see anything else that would likely affect any wall-clock time, 
> > but who knows..
> > 
> > John, Thomas? Ring any bells?
> 
> Went through the pile and nothing stands out.
> 
> The system has an AMD X2 with the jinxed C1E, so I'd rather suspect
> that we managed to break C1E again.
> 
> Just tried to boot -git on my X2 machine and it does not come
> up. Investigating.

Second boot worked, I love heisenbugs. :(

Rafael, can you check whether the C1E idle is selected. Also which
clocksource is used ?

Thanks,

	tglx
