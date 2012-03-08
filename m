Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab2CHWIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:08:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758714Ab2CHWId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:08:33 -0500
Date: Thu, 8 Mar 2012 14:08:30 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, hugetlb: add thread name and pid to SHM_HUGETLB
 mlock rlimit warning
In-Reply-To: <20120308135643.225920ad.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1203081400340.23632@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1203061825070.9015@chino.kir.corp.google.com> <20120308120238.c4486547.akpm@linux-foundation.org> <alpine.DEB.2.00.1203081333300.23632@chino.kir.corp.google.com> <20120308135643.225920ad.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012, Andrew Morton wrote:

> >  We have a get_task_comm() that does the task_lock() 
> > internally but requires a TASK_COMM_LEN buffer in the calling code.  It's 
> > just easier for the calling code to the task_lock() itself for a tiny 
> > little printk().
> 
> Well for a tiny little printk we could just omit the locking?  The
> printk() won't oops and once in a million years one person will see a
> garbled comm[] string?
> 

Sure, but task_lock() shouldn't be highly contended when the thread isn't 
forking or exiting (everything else is attaching/detaching from a cgroup 
or testing a mempolicy).  I've always added it (like in the oom killer for 
the same reason) just because the race exists.  Taking it for every thread 
on the system for one call to the oom killer has never slowed it down.
