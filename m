Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2BTJou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 04:44:50 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46429 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995Ab2BTJot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 04:44:49 -0500
Date: Mon, 20 Feb 2012 09:44:14 +0000
From: Will Deacon <will.deacon@arm.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        David Long <dave.long@linaro.org>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "mans@mansr.com" <mans@mansr.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: oprofile and ARM A9 hardware counter
Message-ID: <20120220094414.GA13115@mudshark.cambridge.arm.com>
References: <1329323900.2293.150.camel@twins>
 <CACVXFVPce0A3LfL=mFo3UbN-Om7xLOo_d-LfKXDjdN5dFQdhiA@mail.gmail.com>
 <20120216150004.GE2641@mudshark.cambridge.arm.com>
 <CACVXFVM472hz+na7o2wJr1CPq-W=YB7i0UwtrsUf62+ryzWp8A@mail.gmail.com>
 <1329409183.2293.245.camel@twins>
 <CACVXFVOygObWqPMLjg6uOB6inBkvvUjsQncNW0fbmpa4Xspw0Q@mail.gmail.com>
 <20120216180841.GC31977@mudshark.cambridge.arm.com>
 <CACVXFVO4eexVK-S5TdRk2T6pyKRzpW1HxBQxo0Yfk_ziaO_U4Q@mail.gmail.com>
 <20120217102643.GA17909@mudshark.cambridge.arm.com>
 <CACVXFVOzoUYrn0SuqwBJ6rTmTNN1MxoR-45dv-owH2rcnQYLWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOzoUYrn0SuqwBJ6rTmTNN1MxoR-45dv-owH2rcnQYLWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 03:19:02AM +0000, Ming Lei wrote:
> On Fri, Feb 17, 2012 at 6:26 PM, Will Deacon <will.deacon@arm.com> wrote:
> > Not sure I follow. If the frequency is 10000, then we write 0xffffd8f0 to
> > the counter. That means we have a 0xffffd8f0 event window to read the
> 
> The frequency I described is the 'freq' from '-F freq'. On OMAP4, when
> the 'freq'
> is 10000 and the interval for one samle is 100us, the observed counter
> ('left' variable in armpmu_event_set_period) is about 90000, so the written
> value to the hw counter is 0xFFFEA06F, looks the window is wide enough,
> and we may not consider the issue in a737823d for sample-based profiling.

My mistake - I thought you were referring to a period of 10000, but similar
logic follows.

> > There's a trade off between allowing the counter to wrap back around past
> > its previous value or being able to handle overflow on a non-interrupt path.
> 
> I agree, it is not easy to read overflow flag and counter accurately
> from hardware
> directly on a non-interrupt path.
> 
> So do you need me to prepare a new patch, or you will do it by yourself?

If the last one I posted is alright to you (seems that it is), then I'll
update it with the removal of the overflow flag and post it to the list with
you on CC.

I also need to get to the bottom of those warnings.

Thanks,

Will
