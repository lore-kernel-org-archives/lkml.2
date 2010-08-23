Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab0HWWWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:22:40 -0400
Received: from smtp-out.google.com ([74.125.121.35]:60792 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab0HWWWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:22:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=VllpKPoPnJZ7/mOrQI0+MgYTOiD5t7PmunuC5b5Qy39y9PyqgjT7swMqSS59i6qBp
	9luzb4NTrWv6rAu2oh4+A==
Date: Mon, 23 Aug 2010 15:22:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] jbd: remove dependency on __GFP_NOFAIL
In-Reply-To: <20100823151129.433875d9.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1008231520170.19203@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com> <alpine.DEB.2.00.1008161956190.17924@chino.kir.corp.google.com> <20100817095103.GA3557@quack.suse.cz> <20100823122813.1ffa3f2e.akpm@linux-foundation.org> <20100823220347.GB3380@quack.suse.cz>
 <20100823151129.433875d9.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Andrew Morton wrote:

> > So do
> > you think that we should keep __GFP_NOFAIL as long as all callers are not
> > able to handle allocation failures in more reasonable way?
> 
> The concept should be encapsulated in _some_ centralised fashion.
> 
> Helper functions would work as well as __GFP_NOFAIL, and will move any
> runtime cost away from the good code and push it onto the bad code.
> 

There's no runtime cost on the bad code, the calls never loop since the 
page allocator already loops itself.  Regardless, I'll add a helper 
function to include/linux/gfp.h to do this with a WARN_ON_ONCE() inside 
the loop in case any order > PAGE_ALLOC_COSTLY_ORDER callers are ever 
added (and I really hope nobody merges those).
