Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab0HCIgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:36:54 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:40993 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab0HCIgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:36:53 -0400
Date: Tue, 3 Aug 2010 17:36:48 +0900
From: Simon Horman <horms@verge.net.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Hui Zhu <teawater@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        gdb@sourceware.org
Subject: Re: [PATCH] kexec: set prstatus.pr_pid to cpu id when current->pid
 is  0
Message-ID: <20100803083647.GB15434@verge.net.au>
References: <AANLkTikuUi=i6Lk-ZpE65Gr0tWOeVnrnpWPe85T=J=Ph@mail.gmail.com>
 <m1zkx4w3hx.fsf@fess.ebiederm.org>
 <AANLkTi=-By6ZWjo9bW0s4MndFftHegROO7oa0jbpnCho@mail.gmail.com>
 <m1d3u0un7b.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d3u0un7b.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 01:15:04AM -0700, Eric W. Biederman wrote:
> Hui Zhu <teawater@gmail.com> writes:
> 
> > On Tue, Aug 3, 2010 at 15:37, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> Hui Zhu <teawater@gmail.com> writes:
> >>
> >
> > Equal 0 is not a bug, the trouble is a lot of core's pid is same.
> >
> > This is what gdb say:
> > /* Found an old thread with the same id.  It has to be dead,
> >        otherwise we wouldn't be adding a new thread with the same id.
> >        The OS is reusing this id --- delete it, and recreate a new
> >        one.  */
> 
> gdb bug compatibility is not a primary goal.  Having an extensible
> format and not inventing it totally out of the blue is the goal.
> 
> The goal was always that something could post process the output of
> the kernel crashdump and create something that is gdb compatible.  It
> looks to me like it would take just a moment to strip out all of the
> idle threads.
> 
> Claiming the pid is the cpu number when the pid is the idle pid gives
> you no insulation against duplication, and it looses information.

Agreed, there clearly an ambiguity brought in by this patch as the range
of valid values for pids and cpus is essentially the same.

Doing this in user-space is the right place, though I'm not really
convinced its even correct there.

