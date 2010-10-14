Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0JNRSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 13:18:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41434 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146Ab0JNRSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 13:18:53 -0400
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Catalin Marinas <catalin.marinas@arm.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <AANLkTinsQVvoxeNGO6ToyKnFTdA=GfjdoY2yEQ3adHVA@mail.gmail.com>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	 <20101007192245.GC26435@n2100.arm.linux.org.uk>
	 <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	 <20101008175308.GA10975@n2100.arm.linux.org.uk>
	 <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com>
	 <20101008230451.GB10975@n2100.arm.linux.org.uk>
	 <20101008232539.GA28697@kroah.com>
	 <20101008234448.GD10975@n2100.arm.linux.org.uk>
	 <20101009000046.GA30616@kroah.com>
	 <20101009002546.GB14675@n2100.arm.linux.org.uk>
	 <alpine.LFD.2.00.1010082210150.3107@xanadu.home>
	 <1286791544.19739.31.camel@e102109-lin.cambridge.arm.com>
	 <AANLkTinMuKDpbL9ka61QhUFJfze_HWWHxjUbAqbz2_vi@mail.gmail.com>
	 <1286796187.19739.52.camel@e102109-lin.cambridge.arm.com>
	 <AANLkTinHZ-w6=0RvVp39MnvpRC7RW1CYNSbzi2f1OvaQ@mail.gmail.com>
	 <1286800232.19739.96.camel@e102109-lin.cambridge.arm.com>
	 <AANLkTinsQVvoxeNGO6ToyKnFTdA=GfjdoY2yEQ3adHVA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 14 Oct 2010 18:18:27 +0100
Message-ID: <1287076707.8749.12.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Oct 2010 17:18:27.0640 (UTC) FILETIME=[D0D1DB80:01CB6BC3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 16:02 +0100, Felipe Contreras wrote:
> On Mon, Oct 11, 2010 at 3:30 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > Well, even if you allow Device memory via ioremap in Linux and the
> > hardware behaviour is not "unpredictable", it is not guaranteed to act
> > as a Device memory. You get speculative accesses via the Normal alias
> > and you may also get dirty cache lines evicted at random from the Normal
> > mapping (unless you invalidated the cache before). The dirty eviction is
> > valid even for pre-ARMv6 processors.
> 
> I'm not familiar with device memory, but anyway, IIUC you are saying
> the normal mapping (original) might not work as expected... That's ok,
> because the only alias that uses after the ioremap() is the second
> one.

No, I say that the Device memory that you are using may not work as
expected (i.e. Device memory). The other Normal mapping may be fine but
you don't care about it anyway.

> > It may be just theoretical but architecture licensees implement the
> > hardware according to the ARM ARM. If it says "unpredictable", they
> > don't need to care much about this scenario as it is not allowed in
> > software and the hardware can be further optimised (well, I think
> > "unpredictable" doesn't allow hardware deadlocking or security
> > implications, so the memory corruption cannot be that random, possibly
> > just restricted to that memory range). It is probably ok on current
> > hardware but I cannot guarantee, you would have to check on a
> > case-by-case basis (CPU implementation).
> 
> Exactly, so it's not the end of the world if this is still allowed one
> more release.

Would there be any incentive for driver maintainers to fix the drivers
after one more release? AFAICT, this is a violation of the ioremap API
already.

But I don't have a strong opinion, only that if we allow ioremap for one
more cycle it would at least be better to use the ioremap_wc() hack I
posted to avoid memory type aliasing (cacheability attributes aliasing
would still be present but that's not that bad).

-- 
Catalin

