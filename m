Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab2IXTSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:18:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33029 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757841Ab2IXTSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:18:01 -0400
Date: Mon, 24 Sep 2012 20:17:36 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Clear breakpoints before enabling
 monitor mode
Message-ID: <20120924191736.GA31118@mudshark.cambridge.arm.com>
References: <1348160260-19486-1-git-send-email-sboyd@codeaurora.org>
 <20120920173556.GQ4654@mudshark.cambridge.arm.com>
 <20120924171934.GE5522@mudshark.cambridge.arm.com>
 <5060A0C8.5040501@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5060A0C8.5040501@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 07:04:56PM +0100, Stephen Boyd wrote:
> On 09/24/12 10:19, Will Deacon wrote:
> > Ok, I've pushed a bunch of patches to my hw-breakpoint branch (head commit
> > 55cb726797c7). I'll post them to the list after the merge window, but please
> > do take them for a spin if you get a chance.
> >
> 
> Sure, I'll try them later today. I would say just send them out so
> people can add tested and reviewed tags. Otherwise we should all start
> planning week long vacations every 7 to 8 weeks to coincide with the
> merge window.

I like the idea of that! However, it's more that most people are worrying
about getting their trees into shape rather than reviewing new code at
the moment, so I suspect that posting it now will go largely un-noticed
and I don't think this is a critical fix (see below).

> Also, it would be nice if we could fix this in 3.7 or even 3.6. Booting
> on an MSM8660 is very fragile right now and this patch fixes it for me.

Whilst I appreciate that it solves your problem, I'm *really* wary about
changing this stuff without giving it a thorough airing beforehand. The
debug reset path is extremely error-prone and its behaviour is tangled
up with the state of various external signals into the core, meaning that
different platforms with the same CPU can take different paths at runtime.

I can definitely CC stable once we're happy with this, but I'd rather
avoid rushing the patches in before 3.8.

Cheers,

Will
