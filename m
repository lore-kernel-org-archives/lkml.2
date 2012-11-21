Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab2KUHjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:39:41 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57663 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2KUHjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:39:40 -0500
MIME-Version: 1.0
In-Reply-To: <50ABBCD7.3000006@wwwdotorg.org>
References: <1353411953-27423-1-git-send-email-linus.walleij@stericsson.com>
	<50ABBCD7.3000006@wwwdotorg.org>
Date: Wed, 21 Nov 2012 08:39:39 +0100
Message-ID: <CACRpkdZmeCKxXaEkf1GPP9ivNZmGc4TNz4-k1pDBAGpnTxhJGA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: let gpiochip_add_pin_range() specify offset
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 6:24 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/20/2012 04:45 AM, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> Like with commit 3c739ad0df5eb41cd7adad879eda6aa09879eb76
>> it is not always enough to specify all the pins of a gpio_chip
>> from offset zero to be added to a pin map range, since the
>> mapping from GPIO to pin controller may not be linear at all,
>> but need to be broken into a few consecutive sub-ranges or
>> 1-pin entries for complicated cases. The ranges may also be
>> sparse.
>>
>> This alters the signature of the function to accept offsets
>> into both the GPIO-chip local pinspace and the pin controller
>> local pinspace.
>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
>
> Although perhaps rename the new "offset" parameter to "gpio_base" or
> "gpio_offset", just like the existing "pin_base" rather than
> pin/base/offset?

OK I'll rename it...

I've also made a fat notice that this isn't currently covered
by the OF GPIO range bindings as a follow-on patch.

Thanks,
Linus Walleij
