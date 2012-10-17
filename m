Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab2JQBtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 21:49:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56180 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab2JQBtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 21:49:04 -0400
Date: Tue, 16 Oct 2012 18:49:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, bhutchings@solarflare.com,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch for-3.7] mm, mempolicy: fix printing stack contents in
 numa_maps
In-Reply-To: <CAHGf_=qSy63-H0ZgdYBtUmdDpxacmAcK=L7X+Ajgr8Yboztqig@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1210161847060.20503@chino.kir.corp.google.com>
References: <20121008150949.GA15130@redhat.com> <CAHGf_=pr1AYeWZhaC2MKN-XjiWB7=hs92V0sH-zVw3i00X-e=A@mail.gmail.com> <alpine.DEB.2.00.1210152055150.5400@chino.kir.corp.google.com> <CAHGf_=rLjQbtWQLDcbsaq5=zcZgjdveaOVdGtBgBwZFt78py4Q@mail.gmail.com>
 <alpine.DEB.2.00.1210152306320.9480@chino.kir.corp.google.com> <CAHGf_=pemT6rcbu=dBVSJE7GuGWwVFP+Wn-mwkcsZ_gBGfaOsg@mail.gmail.com> <alpine.DEB.2.00.1210161657220.14014@chino.kir.corp.google.com> <alpine.DEB.2.00.1210161714110.17278@chino.kir.corp.google.com>
 <CAHGf_=qSy63-H0ZgdYBtUmdDpxacmAcK=L7X+Ajgr8Yboztqig@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, KOSAKI Motohiro wrote:

> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 0b78fb9..d04a8a5 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1536,9 +1536,8 @@ asmlinkage long compat_sys_mbind(compat_ulong_t start, compat_ulong_t len,
> >   *
> >   * Returns effective policy for a VMA at specified address.
> >   * Falls back to @task or system default policy, as necessary.
> > - * Current or other task's task mempolicy and non-shared vma policies
> > - * are protected by the task's mmap_sem, which must be held for read by
> > - * the caller.
> > + * Current or other task's task mempolicy and non-shared vma policies must be
> > + * protected by task_lock(task) by the caller.
> 
> This is not correct. mmap_sem is needed for protecting vma. task_lock()
> is needed to close vs exit race only when task != current. In other word,
> caller must held both mmap_sem and task_lock if task != current.
> 

The comment is specifically addressing non-shared vma policies, you do not 
need to hold mmap_sem to access another thread's mempolicy.
