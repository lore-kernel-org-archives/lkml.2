Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab2KBX0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:26:02 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50539 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab2KBXZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:25:59 -0400
Date: Fri, 2 Nov 2012 16:26:03 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Dave Jones <davej@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: shmem_getpage_gfp VM_BUG_ON triggered. [3.7rc2]
In-Reply-To: <20121102014336.GA1727@redhat.com>
Message-ID: <alpine.LNX.2.00.1211021606580.11106@eggly.anvils>
References: <20121025023738.GA27001@redhat.com> <alpine.LNX.2.00.1210242121410.1697@eggly.anvils> <20121101191052.GA5884@redhat.com> <alpine.LNX.2.00.1211011546090.19377@eggly.anvils> <20121101232030.GA25519@redhat.com> <alpine.LNX.2.00.1211011627120.19567@eggly.anvils>
 <20121102014336.GA1727@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012, Dave Jones wrote:
> On Thu, Nov 01, 2012 at 04:48:41PM -0700, Hugh Dickins wrote:
>  > 
>  > Fedora turns on CONFIG_DEBUG_VM?
> 
> Yes.
>  
>  > All mm developers should thank you for the wider testing exposure;
>  > but I'm not so sure that Fedora users should thank you for turning
>  > it on - really it's for mm developers to wrap around !assertions or
>  > more expensive checks (e.g. checking calls) in their development.
> 
> The last time I did some benchmarking the impact wasn't as ridiculous
> as say lockdep, or spinlock debug.

I think you're safe to assume that (outside of an individual developer's
private tree) it will never be nearly as heavy as lockdep or debug
pagealloc.  I hadn't thought of spinlock debug as a heavy one, but
yes, I guess it would be heavier than almost all VM_BUG_ON()s.

> Maybe the benchmarks I was using
> weren't pushing the VM very hard, but it seemed to me that the value
> in getting info in potential problems early was higher than a small
> performance increase.

We thank you.  I may have been over-estimating how much we put inside
those VM_BUG_ON()s, sorry.  Just so long as you're aware that there's
a danger that one day we might slip something heavier in there.

Those few explicit #ifdef CONFIG_DEBUG_VMs sometimes found in mm/
are probably the worst: you might want to check on the current crop.

> 
>  > Or did I read a few months ago that some change had been made to
>  > such definitions, and VM_BUG_ON(contents) are evaluated even when
>  > the config option is off?  I do hope I'm mistaken on that.
> 
> Pretty sure that isn't the case. I remember Andrew chastising people
> a few times for putting checks in VM_BUG_ON's that needed to stay around 
> even when the config option was off. Perhaps you were thinking of one
> of those incidents ?

Avoiding side-effects in BUG_ON and VM_BUG_ON.  Yes, that comes up
from time to time, and I'm a believer on that.  I think the discussion
I'm mis/remembering sprung out of one of those: someone was surprised
by the disassembly they found when it was configured off.

The correct answer is to try it for myself and see.  Not today.

Hugh
