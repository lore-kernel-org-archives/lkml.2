Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991Ab2ILXyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:54:38 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:38165 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270Ab2ILXye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:54:34 -0400
Date: Wed, 12 Sep 2012 16:53:54 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org, bhalevy@tonian.com, dhillf@gmail.com
Subject: Re: + mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch
 added to -mm tree
In-Reply-To: <alpine.DEB.2.00.1209121618520.12415@chino.kir.corp.google.com>
Message-ID: <alpine.LSU.2.00.1209121649430.15738@eggly.anvils>
References: <20120816200105.C14EA1E0048@wpzn4.hot.corp.google.com> <alpine.DEB.2.00.1209111054510.30962@chino.kir.corp.google.com> <alpine.LSU.2.00.1209111110330.2575@eggly.anvils> <alpine.DEB.2.00.1209111843010.19285@chino.kir.corp.google.com>
 <alpine.LSU.2.00.1209121133210.15274@eggly.anvils> <alpine.DEB.2.00.1209121618520.12415@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012, David Rientjes wrote:
> On Wed, 12 Sep 2012, Hugh Dickins wrote:
> > > that we can't fix it all up to use 
> > > uninitialized_var() so this is handled the proper way?
> > 
> > I do prefer to avoid it when we can, some reasons given below.
> 
> It's easily silenced with __maybe_unused.

I'm not necessarily against __maybe_unused, but I am surprised that it
should have an effect here: I think of that as a tool for a different
job, and would be misleading in this context.

> > Given David's preference for no warning, mine for no uninitialized_var,
> > and Linus's for renaming BUG() to I_AM_A_MORON() to discourage its use
> > in the first place: copy_vma() seems a prime candidate for returning
> > failure to mremap instead of crashing the system.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> 
> Tested-by: David Rientjes <rientjes@google.com>

Thanks!

Hugh
