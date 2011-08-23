Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1HWTXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:23:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57495 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919Ab1HWTWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:22:55 -0400
Message-ID: <4E53FDDA.4020304@zytor.com>
Date: Tue, 23 Aug 2011 12:22:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1108231355380.26421@router.home>
In-Reply-To: <alpine.DEB.2.00.1108231355380.26421@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 12:01 PM, Christoph Lameter wrote:
> On Mon, 22 Aug 2011, Jeremy Fitzhardinge wrote:
> 
>> Most callers of cmpxchg() direcly compare RETURN with OLD to see if it was
>> successful.  This results in unnecessary conditional comparisons
>> and conditionals since the cmpxchg instruction directly sets the flags
>> to indicate success/failure.
> 
>> Add cmpxchg_flag() variants which return a boolean flag directly indicating
>> success.  Unfortunately an asm() statement can't directly export status
>> status flags, but sete isn't too bad.
> 
> And so what happens through this patch is that a cmp with a value that is
> likely in a register is replaced by a sete. Is there really a benefit?
> 
> What I wish we would have is the actual use of the processor flag.
> 
> if (cmpxchg_flags(....)) {
> }
> 
> where the cmpxchg is followed immediately by a jump. I tried in the past
> to pass a goto label to cmpxchg but that did not work.
> 

Yes; asm goto can't have output values :(

I keep meaning to write up a proposal for the gcc people to output
arithmetic flag status.

	-hpa

