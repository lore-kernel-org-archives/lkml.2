Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab0GNUEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:04:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35014 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab0GNUEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:04:09 -0400
Date: Wed, 14 Jul 2010 21:03:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        David Brownell <david-b@pacbell.net>
Subject: Re: Meaning of clk_round_rate()?
Message-ID: <20100714200324.GA18138@n2100.arm.linux.org.uk>
References: <4C3DFC7A.8020002@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3DFC7A.8020002@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 11:05:46AM -0700, Stephen Boyd wrote:
>  What is the meaning of clk_round_rate() in the clk API  
> (include/linux/clk.h)? The function documentation says "adjust a rate to  
> the exact rate a clock can provide". That seems pretty vague. I'm lead  
> to believe that it rounds the rate to the closest rate supported. Is  
> that correct? Is there some sort of error margin where beyond that it's  
> no longer possible to be rounded? 0.5%? 1%?

clk_round_rate() returns the clock rate which will be set if you ask
clk_set_rate() to set that rate.  It provides a way to query from
the implementation exactly what rate you'll get if you use clk_set_rate()
with that same argument.

So essentially, clk_set_rate() should be:

static int clk_set_rate(struct clk *clk, unsigned long rate)
{
	rate = clk_round_rate(clk, rate);
	return set_actual_rate(clk, rate);
}
