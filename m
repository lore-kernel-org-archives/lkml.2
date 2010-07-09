Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab0GIPvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:51:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812Ab0GIPvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:51:20 -0400
Date: Fri, 9 Jul 2010 18:50:47 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v4 08/12] Inject asynchronous page fault into a guest
 if page is swapped out.
Message-ID: <20100709155047.GC11885@redhat.com>
References: <1278433500-29884-1-git-send-email-gleb@redhat.com>
 <1278433500-29884-9-git-send-email-gleb@redhat.com>
 <20100708155920.GA13855@amt.cnet>
 <20100708180525.GA11885@redhat.com>
 <1278612561.1900.170.camel@laptop>
 <1278612631.1900.171.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278612631.1900.171.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 08:10:31PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-07-08 at 20:09 +0200, Peter Zijlstra wrote:
> > On Thu, 2010-07-08 at 21:05 +0300, Gleb Natapov wrote:
> > > > > +   /* do alloc atomic since if we are going to sleep anyway we
> > > > > +      may as well sleep faulting in page */
> > > > > +   work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
> > > > > +   if (!work)
> > > > > +           return 0;
> > > > 
> > > > GFP_KERNEL is fine for this context.
> > > But it can sleep, no? The comment explains why I don't want to sleep
> > > here. 
> > 
> > In that case, use 0, no use wasting __GFP_HIGH on something that doesn't
> > actually need it.
> 
> Ah, I just saw we have GFP_NOWAIT for that.
Indeed. Will use GFP_NOWAIT.

--
			Gleb.
