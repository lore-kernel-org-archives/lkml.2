Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1HWVEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:04:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45061 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab1HWVEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:04:48 -0400
Message-ID: <4E5415BA.5000301@zytor.com>
Date: Tue, 23 Aug 2011 14:03:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>, "H.J. Lu" <hjl.tools@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1108231355380.26421@router.home> <4E53FDDA.4020304@zytor.com> <alpine.DEB.2.00.1108231450130.28350@router.home>
In-Reply-To: <alpine.DEB.2.00.1108231450130.28350@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 12:52 PM, Christoph Lameter wrote:
> 
> Should be relatively straightforward if you make the processor flag a
> builtin variable.
> 
> i.e. __processor_flag_zero, __processor_flag__gt etc.
> 
> Then the inline cmpxchg functions could simply do a
> 
> 	return __processor_flag_zero;
> 
> The code generator then needs to realize from the expression that we are
> referring to the zero flag and insert the correct jxx instruction.
>

The right thing is probably to have not the *flags* but the *conditions*
(exposed as variables):

bool __builtin_x86_s,  __builtin_x86_ns;
bool __builtin_x86_pe, __builtin_x86_po;
...


Or perhaps even

register bool x86_s asm("s");?

H.J. thoughts/ideas?

	-hpa
