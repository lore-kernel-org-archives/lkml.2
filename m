Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab2JFR54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 13:57:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46096 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2JFR5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 13:57:53 -0400
Date: Sat, 6 Oct 2012 19:57:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, konrad.wilk@oracle.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, joerg.roedel@amd.com, bhelgaas@google.com,
        shuahkhan@gmail.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, x86@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 0/7] Improve swiotlb performance by using physical addresses
Message-ID: <20121006175751.GS16230@one.firstfloor.org>
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com> <m28vbkx3hw.fsf@firstfloor.org> <506F3670.4020202@intel.com> <20121005200245.GQ16230@one.firstfloor.org> <506F6BF2.8030500@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506F6BF2.8030500@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Inlining everything did speed things up a bit, but I still didn't reach
> the same speed I achieved using the patch set.  However I did notice the
> resulting swiotlb code was considerably larger.

Thanks. So your patch makes sense, but imho should pursue the inlining
in parallel for other call sites.

> assembly, is replaced with 8 lines of assembly and becomes inline.  In
> addition we drop the number of calls to __phys_addr from 9 to 2 by
> dropping them all from swiotlb.  By my math I am probably saving about
> 120 instructions per packet.  I suspect all of that would probably be
> cutting the number of instructions per packet enough to probably account
> for a 5% difference when you consider I am running at about 1.5Mpps per
> core on a 2.7Ghz processor.

Maybe it's just me, but that's somehow sad for one if() and a su
btraction

BTW __pa used to be a simple subtraction, the if () was just added to
handle the few call sites for x86-64 that do __pa(&text_symbol).
Maybe we should just go back to the old __pa_symbol() for those cases,
then __pa could be the simple subtraction it used to was again
and it could be inlined and everyone would be happy.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
