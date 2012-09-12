Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2ILXZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:25:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50078 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2ILXZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:25:27 -0400
Date: Wed, 12 Sep 2012 16:25:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hugh Dickins <hughd@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org, bhalevy@tonian.com, dhillf@gmail.com
Subject: Re: + mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch
 added to -mm tree
In-Reply-To: <alpine.LSU.2.00.1209121133210.15274@eggly.anvils>
Message-ID: <alpine.DEB.2.00.1209121618520.12415@chino.kir.corp.google.com>
References: <20120816200105.C14EA1E0048@wpzn4.hot.corp.google.com> <alpine.DEB.2.00.1209111054510.30962@chino.kir.corp.google.com> <alpine.LSU.2.00.1209111110330.2575@eggly.anvils> <alpine.DEB.2.00.1209111843010.19285@chino.kir.corp.google.com>
 <alpine.LSU.2.00.1209121133210.15274@eggly.anvils>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012, Hugh Dickins wrote:

> > that we can't fix it all up to use 
> > uninitialized_var() so this is handled the proper way?
> 
> I do prefer to avoid it when we can, some reasons given below.
> 

It's easily silenced with __maybe_unused.  I advocated for using that 
attribute for unusued labels in mm/slab_common.c as well where we now do 
things like

	#ifdef CONFIG_DEBUG_SLAB
	out:
	#endif

repeatedly, but others felt this was better than simply doing

	out: __maybe_unused

Not sure what your preferences are for just adding __maybe_unused to the 
declaration.

> > If CONFIG_BUG exists, then we should support it, right?
> 
> Up to a point, yes: we don't encourage switching it off ("Just say Y").
> I'm reluctant to add a notation just for this discouraged case, but how
> how about this patch - does it actually fix the warning you see, David?
> 
> 
> [PATCH mmotm] mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links fix
> 
> Strangely, I can no longer get an uninitialized variable warning out of
> copy_vma(), with or without the BUG() there; but David Rientjes gets it
> when he builds with CONFIG_BUG off, which is understandable.
> 
> uninitialized_var() can be a useful tool, but I do prefer to avoid it:
> partly because it might hide future errors, partly because I misspell
> it, but mainly because the need for it comes and goes so mysteriously.
> 
> Given David's preference for no warning, mine for no uninitialized_var,
> and Linus's for renaming BUG() to I_AM_A_MORON() to discourage its use
> in the first place: copy_vma() seems a prime candidate for returning
> failure to mremap instead of crashing the system.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Tested-by: David Rientjes <rientjes@google.com>
