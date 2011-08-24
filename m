Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab1HXXFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:05:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54862 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab1HXXFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:05:19 -0400
Message-ID: <4E558380.7060304@zytor.com>
Date: Wed, 24 Aug 2011 16:04:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1108231355380.26421@router.home> <4E540548.4080402@goop.org> <4E541154.6090805@zytor.com> <4E542681.2090703@goop.org> <alpine.DEB.2.00.1108240852370.24118@router.home> <4E5527C2.8000801@goop.org> <alpine.DEB.2.00.1108241408310.30776@router.home> <4E555FBB.3020906@zytor.com> <4E556150.8030100@goop.org>
In-Reply-To: <4E556150.8030100@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 01:38 PM, Jeremy Fitzhardinge wrote:
> On 08/24/2011 01:31 PM, H. Peter Anvin wrote:
>> The sete is actually more expensive than the compare for the single-word
>> case.  The double-word case is a different matter.
> 
> Hm, setcc has a longer latency but a higher throughput, is that
> correct?  Still, its recommended where you can use it to avoid a branch.

Yes, but you don't know when that is (the compiler does, of course.)

> I was also thinking that using it reduces register pressure, since you
> don't need to keep the "old" value around, so it dies sooner.

... but you burn a register for the intermediate flag value, so you're
just as bad off.

	-hpa
