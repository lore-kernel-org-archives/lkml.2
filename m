Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab2HSPNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:13:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab2HSPNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:13:48 -0400
Message-ID: <50310279.8070409@redhat.com>
Date: Sun, 19 Aug 2012 18:12:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, JBeulich@suse.com,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 37/74] lto, KVM: Don't assume asm statements end up in
 the same assembler file
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-38-git-send-email-andi@firstfloor.org> <5030AB00.3090908@redhat.com> <20120819150951.GR11413@one.firstfloor.org>
In-Reply-To: <20120819150951.GR11413@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2012 06:09 PM, Andi Kleen wrote:
>> The reason we use a local label is so that we the function isn't split
>> into two from the profiler's point of view.  See cd2276a795b013d1.
> 
> Hmm that commit message is not very enlightening.
> 
> The goal was to force a compiler error?

No, the goal was to avoid a global label in the middle of a function.
The profiler interprets it as a new function.  After your patch,
profiles will show a function named kvm_vmx_return taking a few percent
cpu, although there is no such function.

> 
> With LTO there is no way to force two functions be in the same assembler
> file. The partitioner is always allowed to split.

I'm not trying to force two functions to be in the same assembler file.

> 
>> 
>> One way to fix this is to have a .data variable initialized to point to
>> .Lkvm_vmx_return (this can be done from the same asm statement in
>> vmx_vcpu_run), and reference that variable in
>> vmx_set_constant_host_state().  If no one comes up with a better idea,
>> I'll write a patch doing this.
> 
> I'm not clear how that is better than my patch.

My patch will not generate the artifact with kvm_vmx_return.

-- 
error compiling committee.c: too many arguments to function
