Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab0JBADS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 20:03:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363Ab0JBADR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 20:03:17 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=3hscMOo6Ho_RbCT82eUZ_Scz_e_9KGQAdKwAs@mail.gmail.com>
References: <1285909484-30958-1-git-send-email-walken@google.com>
 <1285909484-30958-3-git-send-email-walken@google.com> <AANLkTinGgZC7eHW_Q-aR5Vmur4yjv_kKSJ8z3MX60e-r@mail.gmail.com>
 <AANLkTi=3hscMOo6Ho_RbCT82eUZ_Scz_e_9KGQAdKwAs@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Oct 2010 17:02:43 -0700
Message-ID: <AANLkTinf6GKjw0AJjr7768eMU8+yzuE+UeEao2frsdmk@mail.gmail.com>
Subject: Re: [PATCH 2/2] Release mmap_sem when page fault blocks on disk transfer.
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 4:06 PM, Michel Lespinasse <walken@google.com> wrote:
>
> To be clear, is it about the helper function or about the comment
> location ? I think the code block is actually short and simple, so
> maybe if I just moved the comment up to the /* Lock the page */
> location it'd also look that way ?

I suspect that if the comment had been up-front rather than mixed deep
in the code, I wouldn't have reacted so much to it.

That said, if something can be cleanly abstracted out as a separate
operation, and a big function be split into smaller ones where the
helper functions do clearly defined things, I think that's generally a
good idea.

Personally, I tend to like comments in front of code - preferably at
the head of a function. If the function is so complex that it needs
comments inside of it, to me that's a sign that perhaps it should be
split up.

That's not _always_ true, of course. Sometimes some particular detail
in a function is what is really specific ("we don't need to use an
atomic instruction here, because xyz"). So it's not a hard rule, but
the "please explain the code _before_ it happens rather than as it
happens" is still a good guideline.

The thing I reacted to in your patch was that in both cases the
comment really explained the _conditional_, not the code inside the
conditional. So putting it inside the conditional was really at the
wrong level, and too late.

                     Linus
