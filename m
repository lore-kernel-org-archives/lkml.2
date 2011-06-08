Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1FHURc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:17:32 -0400
Received: from waste.org ([173.11.57.241]:53792 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab1FHURb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:17:31 -0400
Subject: Re: 3.0.0-rc2-git1 -- BUG: sleeping function called from invalid
 context at mm/slub.c:847
From: Matt Mackall <mpm@selenic.com>
To: David Rientjes <rientjes@google.com>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        John Johansen <john.johansen@canonical.com>
In-Reply-To: <alpine.DEB.2.00.1106081305430.10320@chino.kir.corp.google.com>
References: <BANLkTimq+h+WyboMbPGVH1uJuj64YuRLdw@mail.gmail.com>
	 <alpine.DEB.2.00.1106081305430.10320@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 15:17:28 -0500
Message-ID: <1307564248.4204.1013.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 13:09 -0700, David Rientjes wrote:
> On Wed, 8 Jun 2011, Miles Lane wrote:
> 
> > BUG: sleeping function called from invalid context at mm/slub.c:847
> >  in_atomic(): 1, irqs_disabled(): 0, pid: 1583, name: cupsd
> >  2 locks held by cupsd/1583:
> >   #0:  (tasklist_lock){.+.+.+}, at: [<ffffffff8104dafa>] do_prlimit+0x61/0x189
> >   #1:  (&(&p->alloc_lock)->rlock){+.+.+.}, at: [<ffffffff8104db2d>]
> > do_prlimit+0x94/0x189
> >  Pid: 1583, comm: cupsd Not tainted 3.0.0-rc2-git1 #7
> >  Call Trace:
> >   [<ffffffff8102ebf2>] __might_sleep+0x10d/0x112
> >   [<ffffffff810e6f46>] slab_pre_alloc_hook.isra.49+0x2d/0x33
> >   [<ffffffff810e7bc4>] kmem_cache_alloc+0x22/0x132
> >   [<ffffffff8105b6e6>] prepare_creds+0x35/0xe4
> >   [<ffffffff811c0675>] aa_replace_current_profile+0x35/0xb2
> >   [<ffffffff811c4d2d>] aa_current_profile+0x45/0x4c
> >   [<ffffffff811c4d4d>] apparmor_task_setrlimit+0x19/0x3a
> >   [<ffffffff811beaa5>] security_task_setrlimit+0x11/0x13
> >   [<ffffffff8104db6b>] do_prlimit+0xd2/0x189
> >   [<ffffffff8104dea9>] sys_setrlimit+0x3b/0x48
> >   [<ffffffff814062bb>] system_call_fastpath+0x16/0x1b
> > 
> 
> Not sure why this ever actually worked with apparmor if prepare_creds() 
> does an unconditional GFP_KERNEL allocation since this codepath hasn't 
> changed in at least a year and we're holding a spinlock from setrlimit.  
> John?

Probably a lack of people enabling (and using!) both apparmor and
might_sleep. I don't this would be caught by a randconfig boot test.

-- 
Mathematics is the supreme nostalgia of our time.


