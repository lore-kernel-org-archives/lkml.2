Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab2APQbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:31:13 -0500
Received: from mail2.shareable.org ([80.68.89.115]:53554 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab2APQbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:31:11 -0500
Date: Mon, 16 Jan 2012 16:31:06 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org
Subject: Re: [PATCH] Mark thread stack correctly in proc/<pid>/maps
Message-ID: <20120116163106.GC7180@jl-vm1.vm.bytemark.co.uk>
References: <1326544511-6547-1-git-send-email-siddhesh.poyarekar@gmail.com>
 <20120116112802.GB7180@jl-vm1.vm.bytemark.co.uk>
 <CAAHN_R1u_btMuF+WhHu0G895EJ=mbOPNRp7NcXEgTKv3Vs-B1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAHN_R1u_btMuF+WhHu0G895EJ=mbOPNRp7NcXEgTKv3Vs-B1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Siddhesh Poyarekar wrote:
> On Mon, Jan 16, 2012 at 4:58 PM, Jamie Lokier <jamie@shareable.org> wrote:
> > Is there a reason the names aren't consistent - i.e. not vma_is_stack_guard()?
> 
> Ah, that was an error on my part; I did not notice the naming convention.
> 
> > How about simply calling it vma_is_guard(), return 1 if it's PROT_NONE
> > without checking vma_is_stack() or ->vm_next/prev, and annotate the
> > maps output like this:
> >
> >   is_stack              => "[stack]"
> >   is_guard & is_stack   => "[stack guard]"
> >   is_guard & !is_stack  => "[guard]"
> >
> > What do you think?
> 
> Thanks for the review. We're already marking permissions in the maps
> output to convey protection, so isn't marking those vmas as [guard]
> redundant?

Yes it's redundant, I just think it's a bit clearer at showing the
intent.  After all that's also the reason for "[stack]", "[heap]" etc.
It's not important though.

> Following that, we could just mark the thread stack guard as [stack]
> without any permissions. The process stack guard page probably
> deserves the [stack guard] label since it is marked differently from
> the thread stack guard and will otherwise have the permissions that
> the process stack has. Will that be good?

I don't have any strong opinions about what the test looks like; mainly I
was pointing out the ->vm_next/prev check seemed dubious, that Glibc's
layout shouldn't be assumed, and that hiding ranges from /maps may
mislead some programs.

Aesthetically I think if the main process stack has "[stack guard]",
it makes sense for the thread stack guards to be labelled the same.

One more technical thing: Now that you're using VM_STACK to change the
text, why not set that flag for the process stack vma as well, when
the stack is set up by exec, and get rid of the special case for
process stack in printing?

All the best,
-- Jamie
