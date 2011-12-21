Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1LUSwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:52:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34709 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1LUSwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:52:41 -0500
Date: Wed, 21 Dec 2011 10:52:37 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH for-3.3] mempool: clean up and document synchronization
 and memory barrier usage
Message-ID: <20111221185237.GI9213@google.com>
References: <20111220221818.GJ10752@google.com>
 <20111221145556.GA25657@redhat.com>
 <20111221163715.GS10752@google.com>
 <20111221174057.GA32347@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221174057.GA32347@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 21, 2011 at 06:40:58PM +0100, Oleg Nesterov wrote:
> > The first paragraph is saying that at that point full barrier (for
> > both stores and loads) is necessary at that point and the second
> > paragraph is a bit confusing but the last sentence seems to say that
> > only loads after the unlock can creep above unlock,
> 
> Probably, this is because the comment tries to explain the possible
> reordering with the subsequent "if (condition)" check, so it only
> mentions loads.

Ah, I see.

> > Anyways, yeah, you're right.  We need a smp_wmb() before returning but
> > I think the comment on top of prepare_to_wait() is misleading.
> 
> Hmm. I am not sure I understand... Although almost everything written
> in English looks misleading to me ;)

Amen. :) I missed the context there, so please forget about it.

> > Great, thanks.  I'll wait a bit for futher comments and repost w/
> > smp_wmb() added.
> 
> Well. This is almost off-topic, but perhaps we can add
> smp_mb__after_unlock() ? We already have smp_mb__after_lock.
> Afaics prepare_to_wait() could use it.
> 
> I am not talking about perfomance issues, just I think the code
> will be more understandable.

Hmmm... maybe.  I really don't know.

Thanks.

-- 
tejun
