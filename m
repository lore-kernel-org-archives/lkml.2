Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0FPBQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 21:16:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49438
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873Ab0FPBQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 21:16:48 -0400
Date: Tue, 15 Jun 2010 18:16:59 -0700 (PDT)
Message-Id: <20100615.181659.58428840.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: alexander.h.duyck@intel.com, jeffrey.t.kirsher@intel.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gospo@redhat.com
Subject: Re: [PATCH net-next-2.6] net: NET_SKB_PAD should depend on
 L1_CACHE_BYTES
From: David Miller <davem@davemloft.net>
In-Reply-To: <1276520234.2478.82.camel@edumazet-laptop>
References: <80769D7B14936844A23C0C43D9FBCF0F2562CD2555@orsmsx501.amr.corp.intel.com>
	<20100610.222006.242136751.davem@davemloft.net>
	<1276520234.2478.82.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 14 Jun 2010 14:57:14 +0200

> [PATCH net-next-2.6] net: NET_SKB_PAD should depend on L1_CACHE_BYTES
> 
> In old kernels, NET_SKB_PAD was defined to 16.
> 
> Then commit d6301d3dd1c2 (net: Increase default NET_SKB_PAD to 32), and
> commit 18e8c134f4e9 (net: Increase NET_SKB_PAD to 64 bytes) increased it
> to 64.
> 
> While first patch was governed by network stack needs, second was more
> driven by performance issues on current hardware. Real intent was to
> align data on a cache line boundary.
> 
> So use max(32, L1_CACHE_BYTES) instead of 64, to be more generic.
> 
> Remove microblaze and powerpc own NET_SKB_PAD definitions.
> 
> Thanks to Alexander Duyck and David Miller for their comments.
> 
> Suggested-by: David Miller <davem@davemloft.net>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks Eric.
