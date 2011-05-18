Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1ERXfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:35:51 -0400
Received: from ozlabs.org ([203.10.76.45]:39088 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849Ab1ERXfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:35:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <greg@kroah.com>, Alessio Igor Bogani <abogani@kernel.org>
Cc: Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Dirk Behme <dirk.behme@googlemail.com>
Subject: Re: [PATCH] module: Use binary search in lookup_symbol()
In-Reply-To: <20110517232241.GA19140@kroah.com>
References: <BANLkTinPG100vbVAN1RZWb3h9Xuu6SKJ0Q@mail.gmail.com> <1305665763-3988-1-git-send-email-abogani@kernel.org> <20110517232241.GA19140@kroah.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Wed, 18 May 2011 10:37:52 +0930
Message-ID: <87liy4n7dj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011 16:22:41 -0700, Greg KH <greg@kroah.com> wrote:
> On Tue, May 17, 2011 at 10:56:03PM +0200, Alessio Igor Bogani wrote:
> > This work was supported by a hardware donation from the CE Linux Forum.
> > 
> > Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
> > ---
> 
> That's nice, but _why_ do this change?  What does it buy us?
> 
> Please explain why you make a change, not just who sponsored the change,
> that's not very interesting to developers.

I was going to let this pass, but since Greg flagged it...

It's sufficient given the context (it's the tail end of a series of
patches), but it's preferable to allude to the other patches in a case
like this.  For example:

        Now we have sorted symbols, we can use binary search for
        kallsyms lookups as well.

(1) "Now we have sorted symbols" indicates to the reader that this has
    just recently become possible.
(2) "as well." indicates that this was not the main justification for
    sorting the symbols.
 
Ideally you would add some numbers, like so:

        On my machine 'cat /proc/kallsyms' only takes 0.02 seconds, but
        this halves it to 0.01 seconds.

(That's my results under kvm, which is a poor way to do timing, but you
get the idea).

Thanks,
Rusty.
