Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0G1KCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:02:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:42320 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641Ab0G1KCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:02:42 -0400
Subject: Re: [PATCH 31/31] memblock: Add memblock_find_in_range()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <4C4FC95F.6040806@kernel.org>
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>
	 <1279822864-17154-32-git-send-email-yinghai@kernel.org>
	 <1280295415.1970.245.camel@pasglop>  <4C4FC95F.6040806@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 19:27:55 +1000
Message-ID: <1280309275.1970.282.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-27 at 23:08 -0700, Yinghai Lu wrote:
> 
> for example: 
> high/low allocation, from first kernel to kexec second kernel, always
> work fine except system with Qlogic card.
> because Qlogic card is using main RAM as EFT etc for card's FW log
> trace. second kernel have not idea that those RAM
>  is used by first kernel for that purpose. that the CARD still use
> that between two kernels.
> second kernel could have crash it try to use those ram.
> 
> low/high allocation seems to be safe,  second kernel can slip to boot
> fine.

No, it works 'by chance'. You need kexec to somewhat mark those regions
as reserved. I don't know how x86 does those things, on architectures
using the flat device-tree, we have added a concept of "reserve map" to
the flat device tree blob to mark that kind of region.

Also, because you mark your new function as weak but not the one that's
actually used by memblock_alloc(), it will still end up being top-down,
so if you want to switch to bottom up, make the internal function weak,
not the wrapper.

Cheers,
Ben.
 

