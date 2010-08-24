Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab0HXUM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:12:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48840 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab0HXUM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:12:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=RFwu5+nsBM7WPLBE/CF+UzXeF1uSnxDNq6cU5f47+tnV9lzVFvOOGQI+HaiGbIsZN
	59lpC9AC6AUSoHBof7EFA==
Date: Tue, 24 Aug 2010 13:12:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Chinner <david@fromorbit.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Alasdair G Kergon <agk@redhat.com>,
        Chris Mason <chris.mason@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, cluster-devel@redhat.com,
        linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
In-Reply-To: <20100824135522.GK31488@dastard>
Message-ID: <alpine.DEB.2.00.1008241311380.21242@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop> <20100824135522.GK31488@dastard>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Dave Chinner wrote:

> > git grep GFP_NOFAIL isn't auditable enough?
> > 
> > might as well declare these functions depricated if you really want to
> > do this.
> 
> Also, if you are going to add tight loops, you might want to put a
> backoff in the loops like "congestion_wait(BLK_RW_ASYNC, HZ/50);" so
> that they don't spin....
> 

These loops don't actually loop at all, all users are passing 
order < PAGE_ALLOC_COSTLY_ORDER which implicitly loop forever in the page 
allocator without killing anything (they are all GFP_NOIO or GFP_NOFS, so 
the oom killer isn't involved).
