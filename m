Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab0KDVRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 17:17:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37835 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab0KDVQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 17:16:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6157"; a="60683984"
Subject: Re: [PATCHv2 2/3] ARM: Allow machines to override __delay()
From: Daniel Walker <dwalker@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Colin Cross <ccross@android.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nicolas Pitre <nico@fluxnic.net>
In-Reply-To: <4CD31E67.60107@codeaurora.org>
References: <1288300770-18350-1-git-send-email-sboyd@codeaurora.org>
	 <1288300770-18350-3-git-send-email-sboyd@codeaurora.org>
	 <1288899002.21823.3.camel@c-dwalke-linux.qualcomm.com>
	 <4CD31E67.60107@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 14:16:54 -0700
Message-ID: <1288905414.21823.12.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 13:58 -0700, Stephen Boyd wrote:
> On 11/04/2010 12:30 PM, Daniel Walker wrote:
> > On Thu, 2010-10-28 at 14:19 -0700, Stephen Boyd wrote:
> >> +
> >> +static void (*delay_fn)(unsigned long) = delay_loop;
> >> +
> >> +void set_delay_fn(void (*fn)(unsigned long))
> >> +{
> >> +       delay_fn = fn;
> >> +}
> >
> > This needs to be a static inline in the header file.
> 
> Wouldn't that mean delay_fn needs to be exposed in the header file too?
> I like the fact that it's static and scoped to this file.

Yeah you would need to make an extern for that. Why is it better to have
it static in this file?

If you make it inline you should have smaller code size since all your
doing is "delay_fn = fn;" and that's not expected to be used much (if at
all).

> >> +/*
> >> + * loops = usecs * HZ * loops_per_jiffy / 1000000
> >> + */
> >> +void __delay(unsigned long loops)
> >> +{
> >> +       delay_fn(loops);
> >> +}
> >>  EXPORT_SYMBOL(__delay);
> >
> > Can we make this static inline also? I'm sure about the module issues..
> 
> Do you mean in the header file or in this file?

header file.

> I think it won't work because there actually needs to be a __delay
> symbol and it can't just be inlined away at all the call sites.

It would be inlined into delay_fn(loops); . So it's calling a function.
I think you can export the delay_fn symbol and use it that way.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

