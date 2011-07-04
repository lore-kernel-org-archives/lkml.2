Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1GDLFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 07:05:30 -0400
Received: from gate.eia.be ([194.78.71.18]:30457 "EHLO mail.eia.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab1GDLF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 07:05:28 -0400
Date: Mon, 4 Jul 2011 13:05:23 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Bill Gatliff <bgat@billgatliff.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Ryan Mallon <ryan@bluewatersys.com>, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
Message-ID: <20110704110523.GB316@e-circ.dyndns.org>
Mail-Followup-To: Ryan Mallon <rmallon@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Bill Gatliff <bgat@billgatliff.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-kernel@vger.kernel.org, Ryan Mallon <ryan@bluewatersys.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org
References: <201106301441.24493.arnd@arndb.de>
 <BANLkTin_htv2z3D9Bbf6N8Y7UKFRvPtvOg@mail.gmail.com>
 <20110630170229.GP6069@pengutronix.de>
 <4E0D0595.5070205@gmail.com>
 <20110701073755.GR6069@pengutronix.de>
 <4E0D8540.2020200@gmail.com>
 <20110701085414.GV6069@pengutronix.de>
 <4E0E6916.50406@gmail.com>
 <20110704075556.GD6069@pengutronix.de>
 <4E11994B.7070103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E11994B.7070103@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Jul 2011 11:05:26.0743 (UTC) FILETIME=[47683E70:01CC3A3A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 08:43:23PM +1000, Ryan Mallon wrote:
> On 04/07/11 17:55, Sascha Hauer wrote:
> 
> If we are going to introduce a new framework for pwms then we should
> create one which meets the needs of at least all of the in kernel
> drivers. This patch series provides no solution for either the atmel or
> ep93xx drivers, so it is not a complete solution. At some point the
> api/framework _must_ be changed. If we can introduce transition layers
> then we should do that now so they we can provide a common framework
> along with some forward thinking about how the other drivers are going
[...]
> 
> The pwm framework needs to incorporate at least the following:
>  - sysfs access (ep93xx driver)
>  - Multiple channels per device (atmel driver)

These are 2 very hardware dependant additions. Is this really the job
for a framework to incorporate this?
IMHO, the job of a framework is to _allow_ such things. Creating a framework
that does _all_ special things of _all_ vendors makes such thing
complicated.

With socketCAN, we encountered a similar problem. Every chip maker
tries to create added value by means of special options. You can't
support them all in the framework. Therefore, sysfs can be added
to configure special things.
> 
> The other nice things to have for the pwm framework are:
>  - More fine grained control of pwms: pwm_period_ns, period_duty_ns, etc
>  - Polarity control
>  - Synchronisation support for multi-channel devices
>  - Interrupt handler support
>  - Sleeping vs non-sleeping configuration api
> 
> The fine-grained control api could be added now. pwm_config could be
> left as is for the time being (the new api could be a wrapper around it
> to start with). Polarity control and interrupt handling apis could also
> be defined without affecting the drivers which don't need to implement

polarity control could be implemented by taking the complement of the duty?

> them. Multiple channels and the sleeping/non-sleeping api are the more
> difficult ones, but at least having some sort of indication about how
> these plan to be solved would be useful.
> 
> ~Ryan
Kurt
