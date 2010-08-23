Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0HWUJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:09:05 -0400
Received: from smtp-out.google.com ([74.125.121.35]:1472 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab0HWUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:09:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nHEzsBnLtAxnoOBw8O7zSF65yv5voTsMW9C/wK2vhtUhF3R9Pjrqb65Rncxhij7EG
	oCJ+IZ8bgQ/x8pfOH80Lg==
Date: Mon, 23 Aug 2010 13:08:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
In-Reply-To: <20100823130109.6da43a58.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1008231303410.17716@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com> <alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com> <20100823122606.47524cef.akpm@linux-foundation.org> <alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
 <20100823130109.6da43a58.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Andrew Morton wrote:

> Hows about you add a helper function
> 
> 	void *[kmalloc|alloc_page]_retrying_forever_because_i_suck(lots of args)
> 
> then convert the callsites to use that, then nuke __GFP_NOFAIL?
> 

That would only serve as documentation of a caller that could potentially 
loop forever waiting for memory (which I did by adding "/* FIXME: this may 
potentially loop forever */") since all of the allocations in this 
patchset never loop in the code that was added, they already loop forever 
in the page allocator doing the same thing.  The hope is that kswapd will 
eventually be able to free memory since direct reclaim will usually fail 
for GFP_NOFS and we simply need to wait long enough for there to be 
memory.
