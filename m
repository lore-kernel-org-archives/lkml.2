Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab1JQQed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:34:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34188 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab1JQQea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:34:30 -0400
Message-ID: <4E9C58D6.9010103@zytor.com>
Date: Mon, 17 Oct 2011 09:33:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC V5 00/11] Paravirtualized ticketlocks
References: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com> <1318503245.24856.12.camel@twins> <4E971580.6030300@goop.org>
In-Reply-To: <4E971580.6030300@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 09:44 AM, Jeremy Fitzhardinge wrote:
> 
> Yeah, that's a good question.  There are three mechanisms with somewhat
> overlapping concerns:
> 
>   * alternative()
>   * pvops patching
>   * jump_labels
> 
> Alternative() is for low-level instruction substitution, and really only
> makes sense at the assembler level with one or two instructions.
> 
> pvops is basically a collection of ordinary _ops structures full of
> function pointers, but it has a layer of patching to help optimise it. 
> In the common case, this just replaces an indirect call with a direct
> one, but in some special cases it can inline code.  This is used for
> small, extremely performance-critical things like cli/sti, but it
> awkward to use in general because you have to specify the inlined code
> as a parameterless asm.
> 
> Jump_labels is basically an efficient way of doing conditionals
> predicated on rarely-changed booleans - so it's similar to pvops in that
> it is effectively a very ordinary C construct optimised by dynamic code
> patching.

Then there is static_cpu_has(), which is basically jump labels
implemented using the alternatives mechanism.

If nothing else it would be good to:

1. Make more general use of ops patching;
2. Merge mechanisms where practical.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

