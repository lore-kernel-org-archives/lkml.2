Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab1LFHzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:55:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932414Ab1LFHzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:55:21 -0500
Date: Tue, 6 Dec 2011 08:55:31 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH repost] mm,x86: remove debug_pagealloc_enabled
Message-ID: <20111206075530.GA3105@redhat.com>
References: <1322582711-14571-1-git-send-email-sgruszka@redhat.com>
 <20111205110656.GA22259@elte.hu>
 <20111205150019.GA5434@redhat.com>
 <20111205155434.GD30287@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205155434.GD30287@elte.hu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 04:54:34PM +0100, Ingo Molnar wrote:
> 
> * Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 
> > On Mon, Dec 05, 2011 at 12:06:56PM +0100, Ingo Molnar wrote:
> > > 
> > > * Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > > 
> > > > When (no)bootmem finish operation, it pass pages to buddy allocator.
> > > > Since debug_pagealloc_enabled is not set, we will do not protect pages,
> > > > what is not what we want with CONFIG_DEBUG_PAGEALLOC=y.
> > > > 
> > > > To fix remove debug_pagealloc_enabled. That variable was introduced by
> > > > commit 12d6f21e "x86: do not PSE on CONFIG_DEBUG_PAGEALLOC=y" to get
> > > > more CPA (change page attribude) code testing. But currently we have
> > > > CONFIG_CPA_DEBUG, which test CPA.
> > > > 
> > > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > > > Acked-by: Mel Gorman <mgorman@suse.de>
> > > > ---
> > > >  arch/x86/mm/pageattr.c |    6 ------
> > > >  include/linux/mm.h     |   10 ----------
> > > >  init/main.c            |    5 -----
> > > >  mm/debug-pagealloc.c   |    3 ---
> > > >  4 files changed, 0 insertions(+), 24 deletions(-)
> > > 
> > > I'm getting this boot crash with the patch applied:
> > 
> > I'm sorry for breaking the boot. I tried to reproduce problem 
> > on my laptop, but failed. I plan to test patch with your 
> > config on some other machines.
> > 
> > On the meantime can you test attached incremental patch and 
> > see if it workaround the crash? I suspect memblock reuse pages 
> > that it passed already to buddy allocator.
> 
> That will take some time - so if you could try my config on 
> another box that would be great. There isnt anything special 
> about that box.

I reproduced with limiting memory via mem=1G and increase
find_range_array count argument, what caused "struct range"
array was bigger and needed more memory. With that I can
confirm that previous patch fixes the problem. I think
it's the simplest possible fix, I'll post patch with 
changelog and comment in the next email.

Stanislaw 
