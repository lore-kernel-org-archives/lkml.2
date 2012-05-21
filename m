Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab2EURL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:11:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54394 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab2EURL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:11:27 -0400
Message-ID: <4FBA773D.4050200@wwwdotorg.org>
Date: Mon, 21 May 2012 11:11:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>
Subject: Re: [PATCH RFC v2 2/2] pinctrl: add pinctrl gpio binding support
References: <1337346755-8761-1-git-send-email-b29396@freescale.com> <1337346755-8761-2-git-send-email-b29396@freescale.com> <4FB6AB9A.4080006@wwwdotorg.org> <20120521123929.GA27055@shlinux2.ap.freescale.net>
In-Reply-To: <20120521123929.GA27055@shlinux2.ap.freescale.net>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 06:39 AM, Dong Aisheng wrote:
> On Sat, May 19, 2012 at 04:05:46AM +0800, Stephen Warren wrote:
>> On 05/18/2012 07:12 AM, Dong Aisheng wrote:
>>> The gpio ranges standard dt binding format is
>>> <&gpio $gpio_offset $pin_offset $npin>
>>>
>>> The core will parse and register the pinctrl gpio ranges
>>> from device tree.
...
>> Do you need to xxx_get(ranges[i].gc) to prevent it going away, and put()
>> it when removing the ranges?
>
> How would you suggest to implement xxx_get(ranges[i].gc)?
> Since the parameter is a struct gpiochip, my first sense is that it may be
> provided by gpio subsystem, but i did not find such a function.
> Looking at gpio subsystem, i also can't see it should provide such function.
> 
> I wonder if we need to implement it, if gpiochip is gone way,
> the error will be detected in the higher gpio layer and will not pass
> down to pinctrl.

Yes, it looks like we should add new APIs for this; we need to
try_module_get() on the module containing the GPIO chip so it doesn't
disappear, similar to what gpio_request() does.
