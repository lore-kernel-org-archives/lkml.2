Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0CXWHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:07:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab0CXWHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:07:51 -0400
Date: Wed, 24 Mar 2010 23:06:24 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 07/11] Memory compaction core
Message-ID: <20100324220624.GN10659@random.random>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
 <1269347146-7461-8-git-send-email-mel@csn.ul.ie>
 <20100324133347.9b4b2789.akpm@linux-foundation.org>
 <20100324145946.372f3f31@bike.lwn.net>
 <20100324211924.GH10659@random.random>
 <20100324152854.48f72171@bike.lwn.net>
 <20100324214742.GL10659@random.random>
 <20100324155423.68c3d5b6@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324155423.68c3d5b6@bike.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 03:54:23PM -0600, Jonathan Corbet wrote:
> Ah, but that's the point: these NULL pointer dereferences were not DoS
> vulnerabilities - they were full privilege-escalation affairs.  Since
> then, some problems have been fixed and some distributors have started
> shipping smarter configurations.  But, on quite a few systems a NULL
> dereference still has the potential to be fully exploitable; if there's
> a possibility of it happening I think we should test for it.  A DoS is
> a much better outcome...

You're pointing the finger at lack of VM_BUG_ON but the finger should
be pointed in the code that shall enforce mmap_min_addr. That is the
exploitable bug. I can't imagine any other ways VM_BUG_ON could help
in preventing an exploit. Let's concentrate on mmap_min_addr and leave
the code fast.

If it's a small structure (<4096 bytes) we're talking about, I stand
that VM_BUG_ON() is just pure CPU overhead.

I do agree however for structures that may grow larger than 4096 bytes
VM_BUG_ON isn't bad idea, and furthermore I think it's wrong to keep
the min address at only 4096 bytes, it shall be like 100M or
something. Then all of them can go away. That is way more effective
than having to remember to add VM_BUG_ON(!null) when cpu can do it
zero cost.
