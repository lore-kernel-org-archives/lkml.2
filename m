Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0ELXG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:06:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36396 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab0ELXGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:06:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] mm,migration: Avoid race between shift_arg_pages() and rmap_walk() during migration by not migrating temporary stacks
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20100512205150.GL24989@csn.ul.ie>
References: <20100512125427.d1b170ba.akpm@linux-foundation.org> <20100512205150.GL24989@csn.ul.ie>
Message-Id: <20100513080600.2139.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 13 May 2010 08:06:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, May 12, 2010 at 12:54:27PM -0700, Andrew Morton wrote:
> > On Wed, 12 May 2010 09:23:44 +0900 (JST)
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > > diff --git a/fs/exec.c b/fs/exec.c
> > > > index 725d7ef..13f8e7f 100644
> > > > --- a/fs/exec.c
> > > > +++ b/fs/exec.c
> > > > @@ -242,9 +242,10 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
> > > >  	 * use STACK_TOP because that can depend on attributes which aren't
> > > >  	 * configured yet.
> > > >  	 */
> > > > +	BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
> > > 
> > > Can we use BUILD_BUG_ON()? 
> > 
> > That's vastly preferable - I made that change.
> 
> I will be surprised if it works. On x86, that is
> 
> #define VM_STACK_FLAGS  (VM_GROWSDOWN | VM_STACK_DEFAULT_FLAGS | VM_ACCOUNT)
> #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
> #define VM_DATA_DEFAULT_FLAGS \
>         (((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
>          VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
> 
> so VM_STACK_FLAGS is depending on the value of current->personality
> which we don't know at build time.

Argh, yes right you are.

sorry for the noise.


