Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab2EVBMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:12:37 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35425 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab2EVBMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:12:35 -0400
MIME-Version: 1.0
In-Reply-To: <4FBA773D.4050200@wwwdotorg.org>
References: <1337346755-8761-1-git-send-email-b29396@freescale.com>
	<1337346755-8761-2-git-send-email-b29396@freescale.com>
	<4FB6AB9A.4080006@wwwdotorg.org>
	<20120521123929.GA27055@shlinux2.ap.freescale.net>
	<4FBA773D.4050200@wwwdotorg.org>
Date: Tue, 22 May 2012 09:12:35 +0800
Message-ID: <CAA+hA=RzZYCHO6mgJFWqPg9Dg+u6GfeMEcaPyTpi0YzBMuY73g@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/2] pinctrl: add pinctrl gpio binding support
From: Dong Aisheng <dongas86@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Dong Aisheng <aisheng.dong@freescale.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 1:11 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/21/2012 06:39 AM, Dong Aisheng wrote:
>> On Sat, May 19, 2012 at 04:05:46AM +0800, Stephen Warren wrote:
>>> On 05/18/2012 07:12 AM, Dong Aisheng wrote:
>>>> The gpio ranges standard dt binding format is
>>>> <&gpio $gpio_offset $pin_offset $npin>
>>>>
>>>> The core will parse and register the pinctrl gpio ranges
>>>> from device tree.
> ...
>>> Do you need to xxx_get(ranges[i].gc) to prevent it going away, and put()
>>> it when removing the ranges?
>>
>> How would you suggest to implement xxx_get(ranges[i].gc)?
>> Since the parameter is a struct gpiochip, my first sense is that it may be
>> provided by gpio subsystem, but i did not find such a function.
>> Looking at gpio subsystem, i also can't see it should provide such function.
>>
>> I wonder if we need to implement it, if gpiochip is gone way,
>> the error will be detected in the higher gpio layer and will not pass
>> down to pinctrl.
>
> Yes, it looks like we should add new APIs for this; we need to
> try_module_get() on the module containing the GPIO chip so it doesn't
> disappear, similar to what gpio_request() does.
yes, i checked the gpio request code.
It looks to me try_module_get is just ok like:
if (!try_module_get(ranges[i].gc.owner))
    goto done;
Will add it.
Thanks for the info.

Regards
Dong Aisheng
