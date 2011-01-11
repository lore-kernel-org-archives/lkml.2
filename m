Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1AKNmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:42:55 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:46514 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab1AKNmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:42:54 -0500
Date: Tue, 11 Jan 2011 19:12:44 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 1/2] [PATCH -tip 1/2] sched: Reinstate group names
 in /proc/sched_debug.
Message-ID: <20110111134244.GJ4772@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110111101040.GD4772@in.ibm.com>
 <20110111101153.GE4772@in.ibm.com>
 <20110111124658.GA4507@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111124658.GA4507@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 08:46:58PM +0800, Yong Zhang wrote:
> On Tue, Jan 11, 2011 at 03:41:54PM +0530, Bharata B Rao wrote:
> > sched: Reinstate group names in /proc/sched_debug.
> > 
> > Displaying of group names in /proc/sched_debug was dropped in autogroup
> > patches. Add group names while displaying cfs_rq and tasks information.
> > 
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > ---
> >  kernel/sched_debug.c |   35 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> > 
> > --- a/kernel/sched_debug.c
> > +++ b/kernel/sched_debug.c
> > @@ -16,6 +16,8 @@
> >  #include <linux/kallsyms.h>
> >  #include <linux/utsname.h>
> >  
> > +static DEFINE_SPINLOCK(sched_debug_lock);
> 
> I don't get your point on introducing this lock.
> Just to avoid concurrent access?

Yes.

> Or could you explain please?

The group name is generated in a global buffer which is protected by
this lock. Earlier small sized local buffer (on stack) was used for
this purpose which wasn't ideal. Also since we can be here from
interrupt context, I wanted to avoid allocation too. Hence went for
a global buffer protected by a lock.

Regards,
Bharata.
