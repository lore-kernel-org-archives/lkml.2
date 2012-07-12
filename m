Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934137Ab2GLQyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:54:55 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:55630 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934114Ab2GLQyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:54:52 -0400
Date: Thu, 12 Jul 2012 09:54:18 -0700
From: Mike Turquette <mturquette@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Ulf Hansson <ulf.hansson@stericsson.com>
Subject: Re: [PATCH] clk: allow clocks without parents to change rate
Message-ID: <20120712165418.GJ2772@gmail.com>
References: <1341439772-649-1-git-send-email-linus.walleij@linaro.org>
 <20120711234229.GF2772@gmail.com>
 <CACRpkdZOgquPF1FXo7LBeFOYhheqx+_ENTn6w4qcKGBqeHnvFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZOgquPF1FXo7LBeFOYhheqx+_ENTn6w4qcKGBqeHnvFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120712-12:50, Linus Walleij wrote:
> On Thu, Jul 12, 2012 at 1:42 AM, Mike Turquette <mturquette@ti.com> wrote:
> 
> > This has been fixed in Pawell's patch, "clk: Check parent for NULL in
> > clk_change_rate".
> 
> Yes, that'll probably work.
> 
> A small nitpick though:
> 
> I have slightly different semantics, Pawel's patch assigns zero if
> parent is NULL, then use that as fallback, whereas I check for the
> parent being NULL all the way. I was worried that the old sematics
> could change like this:
> 
> So here it takes that:
> 
> +       if (clk->parent)
> +               best_parent_rate = clk->parent->rate;
> +
> 
> And I was cautious that if this changes the parent rate:
> 
> +               clk->ops->set_rate(clk->hw, clk->new_rate, best_parent_rate);
> 
> Then this passes the old parent rate to the recalc function:
> 
> +               clk->rate = clk->ops->recalc_rate(clk->hw, best_parent_rate);
> 
> It has no side-effects on my system but I worried about
> others, so I just left the behaviour to re-read the rate from the parent
> every time if possible.
> 

Thanks for looking into it.  I think for now let's keep what we have and
we'll patch it up if bugs are reported.

Thanks again,
Mike

> Yours,
> Linus Walleij
