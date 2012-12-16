Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab2LPNKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 08:10:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60638 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2LPNKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 08:10:03 -0500
Date: Sun, 16 Dec 2012 13:09:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Turquette <mturquette@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] CLK: uninline clk_prepare_enable() and
	clk_disable_unprepare()
Message-ID: <20121216130947.GQ14363@n2100.arm.linux.org.uk>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com> <1353403339-11679-3-git-send-email-dmitry.torokhov@gmail.com> <CAKohpomA=vSGuKfD-_zwiSnXGkqAQjtiVqxT2Po=D-LDA_FESg@mail.gmail.com> <20121216115756.GO14363@n2100.arm.linux.org.uk> <CAKohpok7Lh_ozuBFZdObpPRj0u_B-MNqgWjmaaSik3v4SmgJcw@mail.gmail.com> <20121216124013.GP14363@n2100.arm.linux.org.uk> <CAKohpom37Liqhz38YthaL9q+iFh4=iYHoUmrTOMq2=Ut-D0Dhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpom37Liqhz38YthaL9q+iFh4=iYHoUmrTOMq2=Ut-D0Dhg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 06:35:24PM +0530, Viresh Kumar wrote:
> On 16 December 2012 18:10, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > Well, there's my comment against patch 2 which never got a reply:
> >
> > "Again, what about stuff not using drivers/clk/clk.c ?"
> >
> > Has this been addressed?
> 
> Hmm.. I misread it and thought it is same as breaking other platforms
> because there are
> no dummy routines. But i was wrong :(
> 
> So, the problem is, platform not using common-clock framework uses
> this routine, and they
> don't want it to be dummy but call prepare & enable..
> 
> Because Dmirty requires this one to be non-inline, either he can move
> these routines to
> drivers/clk/clk-devres.c (which would be wrong) or can add wrappers
> over them in clk-devres
> file.

The point of the inlines in linux/clk.h is so that people using the clk
API have a way to transition to the new prepare+enable solution without
having their drivers break.  This patch series totally wrecks that by
making clk_prepare() private to the common clock framework.  All the
time that it does that, it's totally and utterly unsuitable for going
into mainline.

Is that strong enough language that my point is properly heard?
