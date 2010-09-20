Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab0ITP7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:59:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53434 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab0ITP7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:59:40 -0400
Subject: Re: [RFC][PATCH 0/2] PF_flags cleaups
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <AANLkTinjVNddRYDUBnVZ67QDEPGrpj4dmW5BMwq2+ozP@mail.gmail.com>
References: <20100920151334.569154707@chello.nl>
	 <AANLkTinjVNddRYDUBnVZ67QDEPGrpj4dmW5BMwq2+ozP@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Sep 2010 17:58:59 +0200
Message-ID: <1284998339.2275.738.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 08:40 -0700, Linus Torvalds wrote:
> On Mon, Sep 20, 2010 at 8:13 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Because we recently ran out of PF_flags, try and clean up.
> >
> > Patches are on top of -tip, which already includes the PF_ALIGNWARN
> > removal.
> 
> Looks ok by me conceptually, but I _really_ hate the naming of that
> second patch and the pointless churn.
> 

> and look how much straightforward it would have been had you just kept
> the same simple semantics with just a new field:
> 
> -       new_flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
> +       new_type &= ~(TT_SUPERPRIV | TT_WQ_WORKER);
> 
> and nobody could possibly have any objections to a straightforward
> "move the task type flags into a separate field" patch.

Sure, can do. Like said, my initial approach was to compress these type
bits into fewer bits by converting all these individual bits (PF_KSWAPD,
PF_WQ_WORKER, etc) into a linear range which spans less bits.

But indeed, if we're OK with adding a new field (which is I think the
biggest question, and your reply seems imply you don't mind at all),
then keeping the old structure and moving them over to a new field will
generate a much saner patch.

(I only left the helper functions in in case people would object to
adding another field and we'd need to really compress bits again).

One point though, I noticed we actually expose p->flags to userspace,
which basically makes PF_flags an ABI, do we care?
