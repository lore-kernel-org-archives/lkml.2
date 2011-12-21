Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1LUPCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:02:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab1LUPCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:02:42 -0500
Date: Wed, 21 Dec 2011 15:57:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-3.3] mempool: clean up and document synchronization
	and memory barrier usage
Message-ID: <20111221145714.GB25657@redhat.com>
References: <20111220221818.GJ10752@google.com> <20111221145556.GA25657@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221145556.GA25657@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Oleg Nesterov wrote:
>
> On 12/20, Tejun Heo wrote:
> >
> > Furthermore, mempool_alloc() is already holding pool->lock when it
> > decides that it needs to wait.  There is no reason to do unlock - add
> > waitqueue - test condition again.  It can simply add itself to
> > waitqueue while holding pool->lock and then unlock and sleep.
>
> Confused. I agree, we can hold pool->lock until schedule(). But, at
> the same time, why should we hold it?

Ah, I see.

> Or I missed the reason why we must not unlock before prepare_to_wait?

I didn't notice that this removes another "if (!pool->curr_nr)" check.

Oleg.

