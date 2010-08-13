Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0HMV5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:57:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55295 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab0HMV5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:57:33 -0400
Message-ID: <4C65BF90.6000302@zytor.com>
Date: Fri, 13 Aug 2010 14:56:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Borislav Petkov <petkovbb@googlemail.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] core/hweight changes for v2.6.35
References: <20100517212138.GA21629@elte.hu> <AANLkTikvJna6vnc73RVhVAJZ8mERJoFk=V6Nwq-3HHWz@mail.gmail.com>
In-Reply-To: <AANLkTikvJna6vnc73RVhVAJZ8mERJoFk=V6Nwq-3HHWz@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2010 02:42 PM, Mike Frysinger wrote:
> On Mon, May 17, 2010 at 17:21, Ingo Molnar wrote:
>>  arch/alpha/include/asm/bitops.h            |   18 +++++----
>>  arch/ia64/include/asm/bitops.h             |   11 +++--
>>  arch/sparc/include/asm/bitops_64.h         |   11 +++--
>>  arch/x86/include/asm/bitops.h              |    4 +-
>>  include/asm-generic/bitops/arch_hweight.h  |   25 ++++++++++++
>>  include/asm-generic/bitops/const_hweight.h |   42 ++++++++++++++++++++
>>  include/asm-generic/bitops/hweight.h       |    8 +---
> 
> did this miss Blackfin because the original patch was against the
> 2.6.34 tree ?  just wondering why it now build fails ...
> 
> doing a simple grep shows that the new "tile" arch may also be broken
> as it uses "hweight32" ...
> 
> considering __sw_hweightX only exist when the generic hweight is in
> play, wouldnt it make sense to have
> include/asm-generic/bitops/arch_hweight.h not always define things ?
> then most arches can simply pull in
> include/asm-generic/bitops/hweight.h without having to worry about the
> random inner details of hweight cruft.
> 

__sw_hweightX can exist even when generic hweight isn't in use per se,
because the arch implementation can wrapper the software implementation.
 This is the case on x86, for example -- most x86 CPUs don't have popcnt
yet, so on those the x86 implementation end up calling the
__sw_hweight*() implementations.

	-hpa
