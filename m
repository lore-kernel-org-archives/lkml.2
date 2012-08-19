Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2HSPVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:21:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58365 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2HSPU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:20:59 -0400
Date: Sun, 19 Aug 2012 17:20:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 37/74] lto, KVM: Don't assume asm statements end up in the same assembler file
Message-ID: <20120819152058.GU11413@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-38-git-send-email-andi@firstfloor.org> <5030AB00.3090908@redhat.com> <20120819150951.GR11413@one.firstfloor.org> <50310279.8070409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50310279.8070409@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 06:12:57PM +0300, Avi Kivity wrote:
> On 08/19/2012 06:09 PM, Andi Kleen wrote:
> >> The reason we use a local label is so that we the function isn't split
> >> into two from the profiler's point of view.  See cd2276a795b013d1.
> > 
> > Hmm that commit message is not very enlightening.
> > 
> > The goal was to force a compiler error?
> 
> No, the goal was to avoid a global label in the middle of a function.
> The profiler interprets it as a new function.  After your patch,

Ah got it now. I always used to have the same problem with sys_call_return.`

I wonder if there shouldn't be a way to tell perf to ignore a symbol.

> >> 
> >> One way to fix this is to have a .data variable initialized to point to
> >> .Lkvm_vmx_return (this can be done from the same asm statement in
> >> vmx_vcpu_run), and reference that variable in
> >> vmx_set_constant_host_state().  If no one comes up with a better idea,
> >> I'll write a patch doing this.
> > 
> > I'm not clear how that is better than my patch.
> 
> My patch will not generate the artifact with kvm_vmx_return.

Ok fine for me. I'll keep this patch for now, until you have
something better.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
