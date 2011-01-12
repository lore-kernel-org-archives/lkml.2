Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab1ALHtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 02:49:36 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:43225 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab1ALHte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 02:49:34 -0500
Date: Wed, 12 Jan 2011 13:19:30 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 1/2] [PATCH -tip 1/2] sched: Reinstate group names
 in /proc/sched_debug.
Message-ID: <20110112074930.GF2723@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110111101040.GD4772@in.ibm.com>
 <20110111101153.GE4772@in.ibm.com>
 <20110111124658.GA4507@zhy>
 <20110111134244.GJ4772@in.ibm.com>
 <20110111140005.GA6069@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111140005.GA6069@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 10:00:05PM +0800, Yong Zhang wrote:
> On Tue, Jan 11, 2011 at 07:12:44PM +0530, Bharata B Rao wrote:
> > The group name is generated in a global buffer which is protected by
> > this lock. Earlier small sized local buffer (on stack) was used for
> > this purpose which wasn't ideal. Also since we can be here from
> > interrupt context, I wanted to avoid allocation too. Hence went for
> > a global buffer protected by a lock.
> 
> Sounds good ;)
> 
> BTW, I guess we can also remove rcu_read_lock/unlock() in print_rt_stats()
> and print_cfs_stats() with sched_debug_lock hold.

We could, but I guess its not a recommended practice anymore to depend on
spinlocks to protect rcu readside.

Regards,
Bharata.
