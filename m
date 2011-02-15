Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab1BOONk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:13:40 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35625 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1BOONi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:13:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Gu6QoqFr5o0TXb20UIs89mEwM1HMoOqe8MI+C5YUDFU6f1Z76Dps4ZQN2OFe4MvFBO
         KByIdc007MsTQNZHY6IhUEoZv9jjwa6s9DxaXQmLY00rIwG9tOuMLLcIZ5ZHx49gSsTY
         WxcWOKen84vIZQBn+Cwd7pCC5KetoXiwfOKMY=
Date: Tue, 15 Feb 2011 22:13:04 +0800
From: Richard Zhao <linuxzsc@gmail.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Message-ID: <20110215141304.GA1968@richard-laptop>
References: <1297233693.242364.862698430999.1.gpush@pororo>
 <201102151526.54280.jeremy.kerr@canonical.com>
 <20110215083759.GA4152@n2100.arm.linux.org.uk>
 <201102151733.30332.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102151733.30332.jeremy.kerr@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 05:33:29PM +0800, Jeremy Kerr wrote:
> Hi Russell,
> 
> > > Why is that? Consider two devices using one clock; one does some
> > > initialisation based on the return value of clk_get_rate(), the other
> > > calls clk_set_rate() some time later. Now the first device is
> > > incorrectly initialised.
> > 
> > What about a clock sourced from a PLL which provides the dotclock for a
> > framebuffer device?  On every mode set, should the clk have to be disabled,
> > unprepared, rate set, re-prepared and re-enabled?
> 
> Sounds heavy-handed, but I honestly have no idea if that's reasonable or not.
> 
> Other options are:
> 
>  * Require that the driver has called clk_prepare, and that prepare_count
>    is 1 during the set_rate call (indicating that this is the only user); or
> 
>  * Leave the set_rate and set_parent semantics as-is and assume that anything
>    calling either knows what it's doing (and that it won't affect other
>    devices)
I vote the second option. Two reasons:
1. Has any mach specific clock restricted clk_set_rate use? I don't hear any.
2. In my opinion, clk_set_rate is not called very often by drivers, especially
for the clock which has child clocks. Leaf clock are seldom shared. Even if it's
shared, we can let drivers handle it case by case .

Thanks
Richard
> 
> Are you OK if we address this separately to the API unification though?
> 
> Cheers,
> 
> 
> Jeremy
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
