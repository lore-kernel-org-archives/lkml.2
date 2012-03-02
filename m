Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab2CBVVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:21:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:53666 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545Ab2CBVVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:21:16 -0500
Message-ID: <1330723262.11248.233.camel@twins>
Subject: Re: [PATCH] cpuset: mm: Remove memory barrier damage from the page
 allocator
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Miao Xie <miaox@cn.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 02 Mar 2012 22:21:02 +0100
In-Reply-To: <20120302112358.GA3481@suse.de>
References: <20120302112358.GA3481@suse.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 11:23 +0000, Mel Gorman wrote:
> For extra style points, the commit introduced the use of yield() in an
> implementation of what looks like a spinning mutex.

Andrew, could you simply say no to any patch adding a yield()? There's a
99% chance its a bug, as was this. 

This code would life-lock when cpuset_change_task_nodemask() would be
called by the highest priority FIFO task on UP or when pinned to the
same cpu the task doing get_mems_allowed().
