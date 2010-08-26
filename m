Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab0HZAax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 20:30:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28303 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab0HZAav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 20:30:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=I77zyD0aoQ/FqVGQem07LsxhNCRJoYsN05brGjE0PFYJd2d/b+TGMIsmP6W7z2Eno
	r6zOJgFiuc0dC4bqv6aLg==
Date: Wed, 25 Aug 2010 17:30:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Ted Ts'o" <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Alasdair G Kergon <agk@redhat.com>,
        Chris Mason <chris.mason@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
In-Reply-To: <20100826001901.GL4453@thunk.org>
Message-ID: <alpine.DEB.2.00.1008251724360.25783@chino.kir.corp.google.com>
References: <20100825115709.GD4453@thunk.org> <1282740516.2605.3644.camel@laptop> <1282740778.2605.3652.camel@laptop> <E25A6DCB-3188-4CF9-9DC4-631192B2F0E2@mit.edu> <1282743090.2605.3696.camel@laptop> <alpine.DEB.2.00.1008251340420.16484@chino.kir.corp.google.com>
 <1282769729.1975.96.camel@laptop> <alpine.DEB.2.00.1008251406260.20253@chino.kir.corp.google.com> <1282771677.1975.138.camel@laptop> <alpine.DEB.2.00.1008251606450.31521@chino.kir.corp.google.com> <20100826001901.GL4453@thunk.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, Ted Ts'o wrote:

> > I'll repropose the patchset with __deprecated as you suggested.  Thanks!
> 
> And what Dave and I are saying is that we'll either need to do our on
> loop to avoid the deprecation warning, or the use of the deprecated
> function will probably be used forever...
> 

We certainly hope that nobody will reimplement the same function without 
the __deprecated warning, especially for order < PAGE_ALLOC_COSTLY_ORDER 
where there's no looping at a higher level.  So perhaps the best 
alternative is to implement the same _nofail() functions but do a 
WARN_ON(get_order(size) > PAGE_ALLOC_COSTLY_ORDER) instead?

I think it's really sad that the caller can't know what the upper bounds 
of its memory requirement are ahead of time or at least be able to 
implement a memory freeing function when kmalloc() returns NULL.
