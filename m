Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab2H0X7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:59:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59997 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755078Ab2H0X7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:59:47 -0400
Date: Tue, 28 Aug 2012 00:59:32 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        "shinya.kuribayashi.px@renesas.com" 
	<shinya.kuribayashi.px@renesas.com>
Subject: Re: [PATCH] ARM: MSM: Implement read_current_timer for msm timers
Message-ID: <20120827235932.GA8468@mudshark.cambridge.arm.com>
References: <1345817604-9004-2-git-send-email-will.deacon@arm.com>
 <1346102319-24497-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346102319-24497-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 10:18:39PM +0100, Stephen Boyd wrote:
> Setup the same timer used as the clocksource to be used as the
> read_current_timer implementation. This allows us to support a
> stable udelay implementation on MSMs where it's possible for the
> CPUs to scale speeds independently of one another.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> I have some patches to send that add DT support to the MSM timer that
> this conflicts with slightly. I'm not too concerned though, but we may
> want to decide what tree this goes through when I send out those patches.

Cheers Stephen, this looks good to me. After looking at this code some more
I think I'll change the read_current_timer function pointer type to be:

	unsigned long (*read_current_timer)(void);

since it doesn't make sense to return an error code from the platform
implementation (in fact, it will cause havoc in the delay loop).

I'll post a new patch -- rebasing your code should be trivial.

Cheers,

Will
