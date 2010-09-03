Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab0ICOJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:09:47 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53378 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753281Ab0ICOJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:09:46 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/7yYV58vb7yZFcKSMID4YahPeRIL3svqQuK/z+T+
	oCRoghAKywDNoc
Subject: Re: 2.6.32 cgroup regression
From: Mike Galbraith <efault@gmx.de>
To: Minoru Usui <usui@mxm.nes.nec.co.jp>
Cc: johunt@akamai.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100831162542.98269492.usui@mxm.nes.nec.co.jp>
References: <4C74274D.9060300@akamai.com>
	 <1282715761.20033.23.camel@marge.simson.net>
	 <20100831162542.98269492.usui@mxm.nes.nec.co.jp>
Content-Type: text/plain
Date: Fri, 03 Sep 2010 16:09:57 +0200
Message-Id: <1283522997.8373.25.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 16:25 +0900, Minoru Usui wrote:
> Hi, Mike
> 
> On Wed, 25 Aug 2010 07:56:01 +0200
> Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Tue, 2010-08-24 at 13:10 -0700, Josh Hunt wrote:
> > > This commit makes the ltp cpuctl latency test #2 hang indefinitely:
> > > 
> > > commit b5d9d734a53e0204aab0089079cbde2a1285a38f
> > > Author: Mike Galbraith <efault@gmx.de>
> > > Date:   Tue Sep 8 11:12:28 2009 +0200
> > > 
> > >     sched: Ensure that a child can't gain time over it's parent after fork()
> > 
> > Ouch.  Yeah, that commit is buggy, and never got fixed up in stable.
> > Reverting it will restore a slightly less buggy, but not very good
> > situation.  Getting the fork problems all fixed up took a while.
> > (quick fix vs revert didn't help your testcase)
> 
> I'm interested in this problem, because I hit the same problem in RHEL6 beta2.
> (It based on 2.6.32)
> 
> Are you writing a patch to solving this problem?

No, the necessary patches were already written.  I just needed to
backport.  Illness and squabbles with git sendemail (i lost) held me up.

> If you are doing, I can test it in RHEL6 beta2 (or latest).

I just sent a 50 patch series, ever so lovingly git am applied. git
format-patch exported, then imported into evolution one darn patch at a
time, to stable to either apply or bin as maintainers see fit.  To test,
all you should need to do is test mainline.  If you'd like a quilt
tarball against 32.21 anyway, just holler.

The series has all the fork/exec/wakeup/hotplug yada yada fixes I think
are mana from heaven for our long-term stable kernel.  I may well get
"are you outta yer ever lovin' mind?" back, but _I_ think it's needed,
so...

	-Mike

