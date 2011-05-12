Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab1ELOIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:08:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50288 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab1ELOIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:08:40 -0400
Date: Thu, 12 May 2011 16:08:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Milton Miller <miltonm@bga.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@kernel.dk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] seqlock: don't smp_rmb in seqlock reader spin loop
Message-ID: <20110512140832.GK6008@one.firstfloor.org>
References: <1304703767.3066.211.camel@edumazet-laptop> <20110506175051.GL11636@one.firstfloor.org> <1304710003.2821.0.camel@edumazet-laptop> <1304712267.2821.29.camel@edumazet-laptop> <1304713443.20980.124.camel@work-vm> <1304721004.2821.148.camel@edumazet-laptop> <1304722000.20980.130.camel@work-vm> <1304722835.2821.192.camel@edumazet-laptop> <1304724519.20980.139.camel@work-vm> <seqlock-rmb@mdm.bga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <seqlock-rmb@mdm.bga.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 04:13:54AM -0500, Milton Miller wrote:
> 
> Move the smp_rmb after cpu_relax loop in read_seqlock and add
> ACCESS_ONCE to make sure the test and return are consistent.
> 
> A multi-threaded core in the lab didn't like the update

Which core was that?

-Andi
