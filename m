Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2EJRF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:05:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53921 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2EJRF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:05:26 -0400
Message-ID: <4FABF553.20601@wwwdotorg.org>
Date: Thu, 10 May 2012 11:05:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that supports
 omap2+ padconf
References: <20120503065131.GA3738@game.jcrosoft.org> <20120503152708.GC5140@atomide.com> <4FA30805.5050804@wwwdotorg.org> <20120504044305.GD7788@game.jcrosoft.org> <20120504150342.GI5140@atomide.com> <20120504153251.GE7788@game.jcrosoft.org> <20120504163420.GA5613@atomide.com> <4FA42631.6060304@wwwdotorg.org> <20120504220809.GW5613@atomide.com> <4FAAD141.3090306@wwwdotorg.org> <20120509204925.GV5088@atomide.com>
In-Reply-To: <20120509204925.GV5088@atomide.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 02:49 PM, Tony Lindgren wrote:
> * Stephen Warren <swarren@wwwdotorg.org> [120509 13:22]:
>> On 05/04/2012 04:08 PM, Tony Lindgren wrote:
>>> * Stephen Warren <swarren@wwwdotorg.org> [120504 11:59]:
>>>> On 05/04/2012 10:34 AM, Tony Lindgren wrote:
>>>>> * Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> [120504 08:58]:
>>>>>> On 08:03 Fri 04 May     , Tony Lindgren wrote:
>>>>>>>>
>>>>>>>> so I was thinking to do like on gpio
>>>>>>>>
>>>>>>>> uart {
>>>>>>>> 	pin = < &pioA 12 {pararms} >
>>>>>>>>
>>>>>>>> }
>>>>>>>
>>>>>>> Hmm I assume the "12" above the gpio number?
>>>>>> no pin number in the bank because it could not be gpio
>>>>>
>>>>> Yes OK, but pin number 12 in the gpio bank, not in the mux register.
>>>>> Got it.
>>>>
>>>> I'd prefer to avoid any references to GPIOs here; not all muxable pins
>>>> are GPIOs and not all GPIOs are muxable pins. Lets keep the two concepts
>>>> independent.
>>>
>>> And it seems that &pioA 12 is not always enough information for the pinctrl
>>> driver to request a GPIO. So it's best to specify it separately.
>>
>> Why would a pinctrl driver "request a GPIO"?
> 
> Hmm what would pinctrl_request_gpio do if the GPIO driver is separate driver?

Well, that's a GPIO driver requesting a GPIO from the pinctrl system,
rather than the pinctrl driver requesting a GPIO (sorry to be picky).

It wasn't at all obvious to me from your binding proposal that you
intended the pinctrl-simple driver to support the GPIO operations at
all. If you do want this, I think you'd need some properties (perhaps
some kind of explicit table) in order to set up the GPIO ID -> pinctrl
pin ID mapping. I don't recall seeing those; did I just miss them? I
think we'd want this to be explicit because:

a) It may well be the case that not all users of pinctrl-simple actually
mux/control GPIOs at all. It's certainly possible to only mux "special
functions", and have dedicated pins for a GPIO controller.

b) Even when GPIOs do come into the picture, it may be that only some of
the pins are available as GPIOs.

Also, were you intending pinctrl-simple to actually be the GPIO
controller itself? That'd be another case that one might consider fairly
simple, but then extends to being gpio-simple as well as pinctrl-simple...
