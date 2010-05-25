Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab0EYKCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 06:02:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14731 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab0EYKCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 06:02:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=XyRnrdZDQJRXSZrRmqeR1t+XMphFB7RKxC3HdUiqNnJgfUgsyOyvPbJsR+lsPjTaz
	hKMjFcPnDJ1he8Sgl3siA==
Date: Tue, 25 May 2010 03:02:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <cl@linux-foundation.org>,
       Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Matthew Wilcox <willy@linux.intel.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: [RFC V2 SLEB 00/14] The Enhanced(hopefully) Slab Allocator
In-Reply-To: <AANLkTimhTfz_mMWNh_r18yapNxSDjA7wRDnFM6L5aIdE@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1005250257100.8045@chino.kir.corp.google.com>
References: <20100521211452.659982351@quilx.com> <20100524070309.GU2516@laptop> <alpine.DEB.2.00.1005240852580.5045@router.home> <20100525020629.GA5087@laptop> <AANLkTik2O-_Fbh-dq0sSLFJyLU7PZi4DHm85lCo4sugS@mail.gmail.com> <20100525070734.GC5087@laptop>
 <AANLkTimhTfz_mMWNh_r18yapNxSDjA7wRDnFM6L5aIdE@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010, Pekka Enberg wrote:

> I wouldn't say it's a nightmare, but yes, it could be better. From my
> point of view SLUB is the base of whatever the future will be because
> the code is much cleaner and simpler than SLAB.

The code may be much cleaner and simpler than slab, but nobody (to date) 
has addressed the significant netperf TCP_RR regression that slub has, for 
example.  I worked on a patchset to do that for a while but it wasn't 
popular because it added some increments to the fastpath for tracking 
data.

I think it's great to have clean and simple code, but even considering its 
use is a non-starter when the entire kernel is significantly slower for 
certain networking loads.

> That's why I find
> Christoph's work on SLEB more interesting than SLQB, for example,
> because it's building on top of something that's mature and stable.
> 
> That said, are you proposing that even without further improvements to
> SLUB, we should go ahead and, for example, remove SLAB from Kconfig
> for v2.6.36 and see if we can just delete the whole thing from, say,
> v2.6.38?
> 

We use slab internally specifically because of the slub regressions.  
Removing it from the kernel at this point would be the equivalent of 
saying that Linux cares about certain workloads more than others since 
there are clearly benchmarks that show slub to be inferior in pure 
performance numbers.  I'd love for us to switch to slub but we can't take 
the performance hit.
