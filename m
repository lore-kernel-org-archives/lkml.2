Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1HXQdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 12:33:13 -0400
Received: from claw.goop.org ([74.207.240.146]:52703 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab1HXQdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 12:33:09 -0400
Message-ID: <4E5527C2.8000801@goop.org>
Date: Wed, 24 Aug 2011 09:33:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1108231355380.26421@router.home> <4E540548.4080402@goop.org> <4E541154.6090805@zytor.com> <4E542681.2090703@goop.org> <alpine.DEB.2.00.1108240852370.24118@router.home>
In-Reply-To: <alpine.DEB.2.00.1108240852370.24118@router.home>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 06:53 AM, Christoph Lameter wrote:
> On Tue, 23 Aug 2011, Jeremy Fitzhardinge wrote:
>
>> However, having prototyped it, I dunno, it doesn't really seem like much
>> of a win for all the extra code it adds.  I just can't get too excited
>> about an extra test instruction adjacent to a monster like a locked
>> cmpxchg.  The jump variant avoids the test, but gcc still generates some
>> pretty bogus stuff:
> There are also unlocked cmpxchges in use.

I only looked in arch/x86, but I didn't find any that were
straightforward candidates for cmpxchg_flag.

>  And if the cmpxchg is a 16 byte
> cmpxchg (cmpxchg_double) then the comparison is getting more expensive.

We're talking about the difference between cmpxchg_flag()  - which does
a sete based on the flags set up cmpxchg - and a variant based on "asm
goto" which could, in principle, avoid the need for sete by allowing a
control flow statment to directly use the asm goto's conditional jump. 
The performance of both is invariant wrt the cmpxchg argument size.

    J
