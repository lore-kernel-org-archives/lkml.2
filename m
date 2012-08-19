Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2HSPJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:09:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58315 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2HSPJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:09:52 -0400
Date: Sun, 19 Aug 2012 17:09:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 37/74] lto, KVM: Don't assume asm statements end up in the same assembler file
Message-ID: <20120819150951.GR11413@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-38-git-send-email-andi@firstfloor.org> <5030AB00.3090908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5030AB00.3090908@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The reason we use a local label is so that we the function isn't split
> into two from the profiler's point of view.  See cd2276a795b013d1.

Hmm that commit message is not very enlightening.

The goal was to force a compiler error?

With LTO there is no way to force two functions be in the same assembler
file. The partitioner is always allowed to split.

> 
> One way to fix this is to have a .data variable initialized to point to
> .Lkvm_vmx_return (this can be done from the same asm statement in
> vmx_vcpu_run), and reference that variable in
> vmx_set_constant_host_state().  If no one comes up with a better idea,
> I'll write a patch doing this.

I'm not clear how that is better than my patch.

-andi

-- 
ak@linux.intel.com -- Speaking for myself only.
