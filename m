Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401Ab0GHSKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 14:10:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:57151 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab0GHSKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 14:10:43 -0400
Subject: Re: [PATCH v4 08/12] Inject asynchronous page fault into a guest
 if page is swapped out.
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
       cl@linux-foundation.org
In-Reply-To: <1278612561.1900.170.camel@laptop>
References: <1278433500-29884-1-git-send-email-gleb@redhat.com>
	 <1278433500-29884-9-git-send-email-gleb@redhat.com>
	 <20100708155920.GA13855@amt.cnet>  <20100708180525.GA11885@redhat.com>
	 <1278612561.1900.170.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 20:10:31 +0200
Message-ID: <1278612631.1900.171.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 20:09 +0200, Peter Zijlstra wrote:
> On Thu, 2010-07-08 at 21:05 +0300, Gleb Natapov wrote:
> > > > +   /* do alloc atomic since if we are going to sleep anyway we
> > > > +      may as well sleep faulting in page */
> > > > +   work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
> > > > +   if (!work)
> > > > +           return 0;
> > > 
> > > GFP_KERNEL is fine for this context.
> > But it can sleep, no? The comment explains why I don't want to sleep
> > here. 
> 
> In that case, use 0, no use wasting __GFP_HIGH on something that doesn't
> actually need it.

Ah, I just saw we have GFP_NOWAIT for that.
