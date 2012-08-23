Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab2HWDOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 23:14:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48981 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757341Ab2HWDOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 23:14:14 -0400
Message-ID: <50359FF8.7090609@zytor.com>
Date: Wed, 22 Aug 2012 20:14:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org
Subject: Re: [PATCH 74/74] lto, workaround: Mark do_futex noinline to prevent
 clobbering ebp
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-75-git-send-email-andi@firstfloor.org> <503576AB.5030208@zytor.com> <20120823022912.GC12707@tassilo.jf.intel.com>
In-Reply-To: <20120823022912.GC12707@tassilo.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 07:29 PM, Andi Kleen wrote:
> How about just use register arguments for the first three arguments.
> This should work for the syscalls at least (may be too risky for all
> other asm entry points)

Well, it's just an effort to convert each one in turn...

> And for syscalls with more than three generate a stub that saves on the stack
> explicitely.  This could be done using the new fancy SYSCALL definition macros
> (except that arch/x86 would need to start using them too in its own code)

I don't think there is any point.  Just push the six potential arguments 
to the stack and be done with it.

> Or is there some subtle reason with syscall restart and updated args
> that prevents it?
>
> Perhaps newer gcc can do regparm(X), X > 3 too, may be worth trying.

No, there is no such ABI defined.

> Don't have time to look into this currently though.

Always the problem.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

