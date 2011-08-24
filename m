Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab1HXWnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:43:35 -0400
Received: from claw.goop.org ([74.207.240.146]:53869 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab1HXWnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:43:35 -0400
Message-ID: <4E555BFA.3010801@goop.org>
Date: Wed, 24 Aug 2011 13:15:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
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
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1108231355380.26421@router.home> <4E540548.4080402@goop.org> <4E541154.6090805@zytor.com> <4E542681.2090703@goop.org> <alpine.DEB.2.00.1108240852370.24118@router.home> <4E5527C2.8000801@goop.org> <alpine.DEB.2.00.1108241408310.30776@router.home>
In-Reply-To: <alpine.DEB.2.00.1108241408310.30776@router.home>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 12:27 PM, Christoph Lameter wrote:
> On Wed, 24 Aug 2011, Jeremy Fitzhardinge wrote:
>
>> I only looked in arch/x86, but I didn't find any that were
>> straightforward candidates for cmpxchg_flag.
> Look at core code: mm/slub.c

These changes are currently only in arch/x86.  I haven't looked at
extending the cmpxchg API kernel-wide.

> But still the solution with the flags would save another instruction and
> the generated code would not be as ugly. For not only do you have an
> additional sete you will then also have to check the result again. This
> means at least two additional instruction.

Sure.  And the asm goto() variant avoids the sete and subsequent
gcc-generated test, but at the cost of generating a number of
unnecessary jumps - so it doesn't look like much of a win.  Perhaps a
hypothetical gcc extension to add "cc" as an output for asms would help,
but that's conjecture at this point.


    J
