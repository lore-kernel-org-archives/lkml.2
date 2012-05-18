Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab2ERPs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:48:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59481 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841Ab2ERPs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:48:27 -0400
Message-ID: <4FB66F47.8010306@wwwdotorg.org>
Date: Fri, 18 May 2012 09:48:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: Re: [PATCH RFC 1/1] pinctrl: improve gpio support for dt
References: <1337090839-21224-1-git-send-email-b29396@freescale.com> <4FB55A35.1010902@wwwdotorg.org> <20120518072613.GJ10347@shlinux2.ap.freescale.net>
In-Reply-To: <20120518072613.GJ10347@shlinux2.ap.freescale.net>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 01:26 AM, Dong Aisheng wrote:
> On Fri, May 18, 2012 at 04:06:13AM +0800, Stephen Warren wrote:
>> On 05/15/2012 08:07 AM, Dong Aisheng wrote:
>>> For dt, the gpio base may be dynamically allocated, thus the original
>>> implementation of gpio support based on static gpio number and pin id
...
>> For example, Tegra might have:
>>
>> gpio-controllers = <&tegra_gpio>; // there's just 1
>>
>> i.MX23 might have:
>>
>> gpio-controllers = <&gpio0 &gpio1 &gpio2 &gpio3>; // it has 4 banks
>>
>> whereas pinctrl-simple/pinctrl-generic might want to put the entire
>> range table in this property, so might do something like:
>>
>> gpio-ranges =	<&gpio0 $gpio_offset $pin_offset $count>
>> 		<&gpio1 $gpio_offset $pin_offset $count> ...;
>>
>> and hence set cellskip to 3. the pinctrl-simple/pinctrl-generic code
>> would need to parse the other 3 cells itself.
>
> I like this way. :-)
> You made me come up a few more thoughts on it.
> Why shouldn't we use this format as a standard binding way for gpio ranges
> in pinctrl core and let core handle it totally for creating the range table?

Yes, that's probably reasonable.

Typically I'd argue that since the pinctrl driver probably knows this
information, and it's static, it should be in the driver not DT.
However, since the data is very small, and half of it needs to be in DT
anyway to provide the ability to look up the gpio_chip, it seems
reasonable to just put the whole thing in DT..

> The only concern is i'm not sure if any other SoC needs more cells for
> this format since we want this to be a standard bind format.
> But for now i did not see any need, people may raise it if any.

There's still the open question re: how to look up the gpio_chip from
the DT node, since there may be multiple gpio_chips for a single DT node
(banked controllers). Still, I hope that's just an implementation detail
rather than anything that conceptually breaks this idea.
