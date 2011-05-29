Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1E2SoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:44:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085Ab1E2SoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:44:06 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimqhkiBSArm7n0_9FD+LW6hWBWxFA@mail.gmail.com>
References: <20110529072256.GA20983@elte.hu> <BANLkTikHejgEyz9LfJ962Bu89vn1cBP+WQ@mail.gmail.com>
 <BANLkTimqhkiBSArm7n0_9FD+LW6hWBWxFA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 May 2011 11:43:23 -0700
Message-ID: <BANLkTin8yxh=Bjwf7AEyzPCoghnYO2brLQ@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix boot crash in mm_alloc()
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 10:19 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> STILL TOTALLY UNTESTED! The fixes were just from eyeballing it a bit
> more, not from any actual testing.

Ok, I eyeballed it some more, and tested both the OFFSTACK and ONSTACK
case, and decided that I had better commit it now rather than wait any
later since I'll do the -rc1 later today, and will be on an airplane
most of tomorrow.

The exact placement of the cpu_vm_mask_var is up for grabs. For
example, I started thinking that it might be better to put it *after*
the mm_context_t, since for the non-OFFSTACK case it's generally
touched at the beginning rather than the end.

And the actual change to make the mm_cachep kmem_cache_create() use a
variable-sized allocation for the OFFSTACK case is similarly left as
an exercise for the the reader. So effectively, this reverts a lot of
de03c72cfce5, but does so in a way that should make very it easy to
get back to where KOSAKI was aiming for.

Whatever. I was hoping to get comments on it, but I think I need to
rather push it out to get tested and public than wait any longer. The
patch *looks* fine, tests ok on my machine, and removes more lines
than it adds despite the new big comment.

                    Linus
