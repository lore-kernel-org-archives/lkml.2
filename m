Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2GaCII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 22:08:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38139 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab2GaCHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 22:07:23 -0400
Date: Mon, 30 Jul 2012 19:07:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: shuah.khan@hp.com, cl@linux.com, glommer@parallels.com, js1304@gmail.com,
        shuahkhan@gmail.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
In-Reply-To: <CAOJsxLHw8G0ChnOeBv1nNr3tqNPPjdnkY=RStyo3rRqC1bdDAA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207301904520.24929@chino.kir.corp.google.com>
References: <1342221125.17464.8.camel@lorien2> <CAOJsxLGjnMxs9qERG5nCfGfcS3jy6Rr54Ac36WgVnOtP_pDYgQ@mail.gmail.com> <alpine.DEB.2.00.1207301255320.24196@chino.kir.corp.google.com> <CAOJsxLHw8G0ChnOeBv1nNr3tqNPPjdnkY=RStyo3rRqC1bdDAA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2012, Pekka Enberg wrote:

> > -Wunused-label is overridden in gcc for a label that is conditionally
> > referenced by using __maybe_unused in the kernel.  I'm not sure what's so
> > obscure about
> >
> > out: __maybe_unused
> >
> > Are label attributes really that obsecure?
> 
> I think they are.
> 
> The real problem, however, is that label attributes would just paper
> over the badly thought out control flow in the function and not make the
> code any better or easier to read.
> 

So much for compromise, I thought we had agreed that at least some of the 
checks for !name, in_interrupt() or bad size values should be moved out 
from under the #ifdef CONFIG_DEBUG_VM, but this wasn't done.  This 
discussion would be irrelevent if we actually did what we talked about.
