Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab1FIAIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 20:08:47 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40907 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424Ab1FIAIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 20:08:35 -0400
X-Sasl-enc: z0P9X5pO1xezJD+F7GN4gWKA/9jAiknbzAXNirnXiPJZ 1307578114
Date: Wed, 8 Jun 2011 16:47:17 -0700
From: Greg KH <greg@kroah.com>
To: John Johansen <john.johansen@canonical.com>
Cc: David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org >> James Morris" <jmorris@namei.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        stable@kernel.org
Subject: Re: [stable] 3.0.0-rc2-git1 -- BUG: sleeping function called from
 invalid context at mm/slub.c:847
Message-ID: <20110608234717.GA22592@kroah.com>
References: <BANLkTimq+h+WyboMbPGVH1uJuj64YuRLdw@mail.gmail.com>
 <alpine.DEB.2.00.1106081305430.10320@chino.kir.corp.google.com>
 <4DEFF2B3.7080202@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEFF2B3.7080202@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 03:07:47PM -0700, John Johansen wrote:
> From: John Johansen <john.johansen@canonical.com>
> Date: Wed, 8 Jun 2011 15:03:58 -0700
> Subject: [PATCH] AppArmor: Fix sleep in invalid context from task_setrlimit
> 
> Affected kernels 2.6.36 - 3.0
> 
> AppArmor may do a GFP_KERNEL memory allocation with task_lock(tsk->group_leader);
> held when called from security_task_setrlimit.  This will only occur when the
> task's current policy has been replaced, and the task's creds have not been
> updated before entering the LSM security_task_setrlimit() hook.
> 
> As reported by Miles Lane
> 
> BUG: sleeping function called from invalid context at mm/slub.c:847
>  in_atomic(): 1, irqs_disabled(): 0, pid: 1583, name: cupsd
>  2 locks held by cupsd/1583:
>   #0:  (tasklist_lock){.+.+.+}, at: [<ffffffff8104dafa>] do_prlimit+0x61/0x189
>   #1:  (&(&p->alloc_lock)->rlock){+.+.+.}, at: [<ffffffff8104db2d>]
> do_prlimit+0x94/0x189
>  Pid: 1583, comm: cupsd Not tainted 3.0.0-rc2-git1 #7
>  Call Trace:
>   [<ffffffff8102ebf2>] __might_sleep+0x10d/0x112
>   [<ffffffff810e6f46>] slab_pre_alloc_hook.isra.49+0x2d/0x33
>   [<ffffffff810e7bc4>] kmem_cache_alloc+0x22/0x132
>   [<ffffffff8105b6e6>] prepare_creds+0x35/0xe4
>   [<ffffffff811c0675>] aa_replace_current_profile+0x35/0xb2
>   [<ffffffff811c4d2d>] aa_current_profile+0x45/0x4c
>   [<ffffffff811c4d4d>] apparmor_task_setrlimit+0x19/0x3a
>   [<ffffffff811beaa5>] security_task_setrlimit+0x11/0x13
>   [<ffffffff8104db6b>] do_prlimit+0xd2/0x189
>   [<ffffffff8104dea9>] sys_setrlimit+0x3b/0x48
>   [<ffffffff814062bb>] system_call_fastpath+0x16/0x1b
> 
> Signed-off-by: John Johansen <john.johansen@canonical.com>
> ---
>  security/apparmor/lsm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
