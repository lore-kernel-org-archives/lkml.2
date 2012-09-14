Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab2INPzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:55:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46734 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217Ab2INPzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:55:37 -0400
Message-ID: <50535375.4090606@wwwdotorg.org>
Date: Fri, 14 Sep 2012 09:55:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Subject: Re: [PATCH] pinctrl: document semantics vs GPIO
References: <1347519686-10170-1-git-send-email-linus.walleij@stericsson.com> <505205B1.4080708@wwwdotorg.org> <20120913221125.GA10032@glitch> <CACRpkdb+QC_iHOkoihqxDgC+b+PUij-qi6BiOKmnCB3vPnJTjw@mail.gmail.com> <20120914143056.GA25696@glitch>
In-Reply-To: <20120914143056.GA25696@glitch>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 08:30 AM, Domenico Andreoli wrote:
> On Fri, Sep 14, 2012 at 03:48:05PM +0200, Linus Walleij wrote:
>> On Fri, Sep 14, 2012 at 12:11 AM, Domenico Andreoli <cavokz@gmail.com> wrote:
>>> On Thu, Sep 13, 2012 at 10:11:29AM -0600, Stephen Warren wrote:
>>
>>>> I think it makes sense to more strongly recommend that for GPIO muxing,
>>>> the GPIO driver always call into the pinctrl subsystem (if needed by the
>>>> HW) to perform that muxing, so that standalone gpio_direction_*() always
>>>> work without any use of pinctrl; the interaction between the two should
>>>> only be required if pin configuration (not just pin muxing) is also
>>>> required.
>>>
>>> Don't know. Isn't possible to reach the same effect moving this kind
>>> of knowledge into higher level helper functions and remove this bridge
>>> across the subsystems?
>>
>> I'm not following, please elaborate on this.
>>
>> What are these higher level functions, and where will they be
>> located? In which subsystem, and using what symbols/signatures and
>> so on?
> 
> If the common case is requesting the pin and then the gpio, an helper
> like this would do the trick. So why those calls into pinctrl should be
> done by the GPIO driver itself?  Pinctrl and GPIO would be separated,
> ignoring each other.
> 
> static int request_muxed_gpio(int gpio, const char *label)

That would require the driver to know when to call gpio_request() as
opposed to request_muxed_gpio() wouldn't it. Whether that is needed or
not depends on the Soc/board the driver is running on. The whole idea of
the internal GPIO->pinctrl driver communication was to avoid that.

I suppose that if we were to mandate that ever device that uses GPIOs
also have at least some (possibly empty) pinctrl state defined, then
request_muxed_gpio() could always be used. However, that's quite a
strong requirement. An also, if we were to make that rule, then we might
as well just implement this inside the existing gpio_request(), so that
no driver changes were required.
