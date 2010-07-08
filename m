Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab0GHSJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 14:09:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37088 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab0GHSJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 14:09:49 -0400
Subject: Re: [PATCH v4 08/12] Inject asynchronous page fault into a guest
 if page is swapped out.
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
       cl@linux-foundation.org
In-Reply-To: <20100708180525.GA11885@redhat.com>
References: <1278433500-29884-1-git-send-email-gleb@redhat.com>
	 <1278433500-29884-9-git-send-email-gleb@redhat.com>
	 <20100708155920.GA13855@amt.cnet>  <20100708180525.GA11885@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 20:09:21 +0200
Message-ID: <1278612561.1900.170.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 21:05 +0300, Gleb Natapov wrote:
> > > +   /* do alloc atomic since if we are going to sleep anyway we
> > > +      may as well sleep faulting in page */
> > > +   work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
> > > +   if (!work)
> > > +           return 0;
> > 
> > GFP_KERNEL is fine for this context.
> But it can sleep, no? The comment explains why I don't want to sleep
> here. 

In that case, use 0, no use wasting __GFP_HIGH on something that doesn't
actually need it.
