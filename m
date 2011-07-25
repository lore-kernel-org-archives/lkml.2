Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab1GYLNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 07:13:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38018 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab1GYLNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 07:13:18 -0400
Date: Mon, 25 Jul 2011 13:12:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86 <x86@kernel.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 3.1?] x86: Remove useless stts/clts pair in __switch_to
Message-ID: <20110725111224.GP28787@elte.hu>
References: <CAObL_7EuFXbuxpz2bzKuEReyDHo+mBxDyJSf_rjBKpdnUmEzLQ@mail.gmail.com>
 <38f1d91a44c243a91e441a947fed4b076dcd4ca1.1311587947.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38f1d91a44c243a91e441a947fed4b076dcd4ca1.1311587947.git.luto@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@MIT.EDU> wrote:

> An stts/clts pair takes over 70 ns by itself on Sandy Bridge, and
> when other things are going on it's apparently even worse.  This
> saves 10% on context switches between threads that both use extended
> state.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Arjan van de Ven <arjan@infradead.org>, 
> Cc: Avi Kivity <avi@redhat.com>
> ---
> 
> This is not as well tested as it should be (especially on 32-bit, where
> I haven't actually tried compiling it), but I think this might be 3.1
> material so I want to get it out for review before it's even more
> unjustifiably late :)
> 
> Argument for inclusion in 3.1 (after a bit more testing):
>  - It's dead simple.
>  - It's a 10% speedup on context switching under the right conditions [1]
>  - It's unlikely to slow any workload down, since it doesn't add any work
>    anywwhere.
> 
> Argument against:
>  - It's late.

I think it's late.

Would be much better to stick it into the x86/xsave tree i pointed to 
and treat and debug it as a coherent unit. FPU bugs need a lot of 
time to surface so we definitely do not want to fast-track it. In 
fact if we want it in v3.2 we should start assembling the tree right 
now.

Also, if you are tempted by the prospect of possibly enabling vector 
instructions for the x86 kernel, we could try that too, and get 
multiple speedups for the price of having to debug the tree only once 
;-)

Thanks,

	Ingo
