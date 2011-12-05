Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab1LEP41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 10:56:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37712 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374Ab1LEP40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:56:26 -0500
Date: Mon, 5 Dec 2011 16:54:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH repost] mm,x86: remove debug_pagealloc_enabled
Message-ID: <20111205155434.GD30287@elte.hu>
References: <1322582711-14571-1-git-send-email-sgruszka@redhat.com>
 <20111205110656.GA22259@elte.hu>
 <20111205150019.GA5434@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205150019.GA5434@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> On Mon, Dec 05, 2011 at 12:06:56PM +0100, Ingo Molnar wrote:
> > 
> > * Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > 
> > > When (no)bootmem finish operation, it pass pages to buddy allocator.
> > > Since debug_pagealloc_enabled is not set, we will do not protect pages,
> > > what is not what we want with CONFIG_DEBUG_PAGEALLOC=y.
> > > 
> > > To fix remove debug_pagealloc_enabled. That variable was introduced by
> > > commit 12d6f21e "x86: do not PSE on CONFIG_DEBUG_PAGEALLOC=y" to get
> > > more CPA (change page attribude) code testing. But currently we have
> > > CONFIG_CPA_DEBUG, which test CPA.
> > > 
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > > Acked-by: Mel Gorman <mgorman@suse.de>
> > > ---
> > >  arch/x86/mm/pageattr.c |    6 ------
> > >  include/linux/mm.h     |   10 ----------
> > >  init/main.c            |    5 -----
> > >  mm/debug-pagealloc.c   |    3 ---
> > >  4 files changed, 0 insertions(+), 24 deletions(-)
> > 
> > I'm getting this boot crash with the patch applied:
> 
> I'm sorry for breaking the boot. I tried to reproduce problem 
> on my laptop, but failed. I plan to test patch with your 
> config on some other machines.
> 
> On the meantime can you test attached incremental patch and 
> see if it workaround the crash? I suspect memblock reuse pages 
> that it passed already to buddy allocator.

That will take some time - so if you could try my config on 
another box that would be great. There isnt anything special 
about that box.

Thanks,

	Ingo
