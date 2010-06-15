Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0FOHZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:25:45 -0400
Received: from ozlabs.org ([203.10.76.45]:57064 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0FOHZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:25:44 -0400
Date: Tue, 15 Jun 2010 17:25:40 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tytso@mit.edu, Salman <sqazi@google.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tytso@google.com,
       torvalds@linux-foundation.org, walken@google.com,
       Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-ID: <20100615072540.GA2530@brick.ozlabs.ibm.com>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com>
 <20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
 <20100614165851.6bdfe485.akpm@linux-foundation.org>
 <20100615005619.GI6666@thunk.org>
 <20100614185556.afdc5304.akpm@linux-foundation.org>
 <20100615032608.GB30479@drongo>
 <20100614212150.4dcb1feb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614212150.4dcb1feb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 09:21:50PM -0700, Andrew Morton wrote:

> If that happens then the best fix is for those architectures to get
> themselves a cmpxchg64().  Unless for some reason it's simply
> unimplementable?  Worst case I guess one could use a global spinlock. 
> Second-worst-case: hashed spinlocks.

Spinlocks won't help as long as you can use cmpxchg64 on any old u64
that is also accessed directly.  UP can disable interrupts, of course,
but for SMP we would have to restrict cmpxchg64 to some type
(atomic64_t, maybe) for which you have to use an accessor function to
read it, so we can take the spinlock around the reads.

I suspect it isn't worth the trouble.  Note that I'm talking
specifically about cmpxchg64 here, not cmpxchg.

Paul.
