Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab2CEUSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:18:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab2CEUSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:18:06 -0500
Date: Mon, 5 Mar 2012 12:18:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mel Gorman <mgorman@suse.de>, Miao Xie <miaox@cn.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] cpuset: mm: Remove memory barrier damage from the page
 allocator
Message-Id: <20120305121804.3b4daed4.akpm@linux-foundation.org>
In-Reply-To: <1330723262.11248.233.camel@twins>
References: <20120302112358.GA3481@suse.de>
	<1330723262.11248.233.camel@twins>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2012 22:21:02 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2012-03-02 at 11:23 +0000, Mel Gorman wrote:
> > For extra style points, the commit introduced the use of yield() in an
> > implementation of what looks like a spinning mutex.
> 
> Andrew, could you simply say no to any patch adding a yield()? There's a
> 99% chance its a bug, as was this. 

I'd normally at least poke my tongue out at it - I must have missed
this one.

> This code would life-lock when cpuset_change_task_nodemask() would be
> called by the highest priority FIFO task on UP or when pinned to the
> same cpu the task doing get_mems_allowed().

Joe, can we please have a checkpatch rule?
