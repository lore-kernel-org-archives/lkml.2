Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1LVQHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:07:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab1LVQHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:07:07 -0500
Date: Thu, 22 Dec 2011 11:04:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 2/2] mempool: fix first round failure behavior
Message-ID: <20111222160423.GE1388@redhat.com>
References: <20111222001800.GL9213@google.com>
 <20111222001939.GM9213@google.com>
 <20111222004629.GO9213@google.com>
 <20111221170919.f7d49fc6.akpm@linux-foundation.org>
 <20111222012312.GP9213@google.com>
 <20111222151529.GA1388@redhat.com>
 <20111222152009.GB1388@redhat.com>
 <CAOS58YN3hvnXofcz9WVER_bV2KwG+=mqoaJ8zRx2nsoHdpH4wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YN3hvnXofcz9WVER_bV2KwG+=mqoaJ8zRx2nsoHdpH4wQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 07:58:18AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Thu, Dec 22, 2011 at 7:20 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Also mempool expects all the objects to be returned to the pool at the
> > time of destroy. Given the fact that blkio groups are reference counted,
> > theoritically they can be freed later.
> 
> I removed that part but no you still can't free objects after mempool
> destruction refcnted or not. mempool is destructed on module unload.
> Which text would free those objects? If that's theoretically possible,
> the code is broken.

That's a good point. I did not think about module unload. I think then
my current patch for allocating per cpu object from worker thread is buggy
as on IO scheduler exit I don't try to flush the possibly in progress
work[s]. 

Thanks
Vivek
