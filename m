Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2EGFZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:25:40 -0400
Received: from ozlabs.org ([203.10.76.45]:54430 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab2EGFYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:24:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] brlocks/lglocks: turn into functions
In-Reply-To: <20120420112149.GH25458@amd.local0.net>
References: <87ehtf3lqh.fsf@rustcorp.com.au> <20120227155338.7b5110cd.akpm@linux-foundation.org> <20120228112422.GC11324@alboin.amr.corp.intel.com> <87ipijzfwn.fsf@rustcorp.com.au> <20120420112149.GH25458@amd.local0.net>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 07 May 2012 13:09:04 +0930
Message-ID: <87sjfcfynb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012 21:21:49 +1000, Nick Piggin <npiggin@kernel.dk> wrote:
> This still not merged?

No, I've been away.  I've put it in -next for tomorrow, though I'm not
sure what the best way to get it to Linus next merge window.

> There is a reason, which is performance. Extra function call, but also
> IIRC the percpu accessor was not so fast doing it this way. Maybe
> that's improved...
> 
> So what's the performance difference?

What benchmarks you usually run?  Feel free to try it out and report
back; I only have small hardware here.

> > 
> > Since there are at least two users it makes sense to share this code in a
> > library.  This is also easier maintainable than a macro forest.
> > 
> > This will also make it later possible to dynamically allocate lglocks and
> > also use them in modules (this would both still need some additional, but
> > now straightforward, code)
> 
> Yes, but let's not do either of those things :)
> 
> I was slightly crazy when committing that patch to the kernel, I'll
> admit. So if performance isn't significantly affected, then definitely.
> If it is... well, it's much easier to gain 1% performance by maintaining
> 100 self contained lines of hilarious code like this than to actually
> use your brain to improve somewhere else!

Cheers,
Rusty.
