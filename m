Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983Ab2CHWXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:23:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758883Ab2CHWXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:23:36 -0500
Date: Thu, 8 Mar 2012 14:23:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, hugetlb: add thread name and pid to SHM_HUGETLB
 mlock rlimit warning
Message-Id: <20120308142335.e2dc17cb.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1203081400340.23632@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1203061825070.9015@chino.kir.corp.google.com>
	<20120308120238.c4486547.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1203081333300.23632@chino.kir.corp.google.com>
	<20120308135643.225920ad.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1203081400340.23632@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012 14:08:30 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Thu, 8 Mar 2012, Andrew Morton wrote:
> 
> > >  We have a get_task_comm() that does the task_lock() 
> > > internally but requires a TASK_COMM_LEN buffer in the calling code.  It's 
> > > just easier for the calling code to the task_lock() itself for a tiny 
> > > little printk().
> > 
> > Well for a tiny little printk we could just omit the locking?  The
> > printk() won't oops and once in a million years one person will see a
> > garbled comm[] string?
> > 
> 
> Sure, but task_lock() shouldn't be highly contended when the thread isn't 
> forking or exiting (everything else is attaching/detaching from a cgroup 
> or testing a mempolicy).  I've always added it (like in the oom killer for 
> the same reason) just because the race exists.  Taking it for every thread 
> on the system for one call to the oom killer has never slowed it down.

I wasn't concerned about the performance side of things - just that
it's such a pain over such a silly thing.

btw, if the code had done

	printk_once(..., get_task_comm(...), ...)

the task_lock() would have been performed just a single time, rather
than every time.


