Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2JOWzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:55:50 -0400
Received: from antcom.de ([188.40.178.216]:60548 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab2JOWzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:55:49 -0400
Message-ID: <507C9458.1080803@antcom.de>
Date: Tue, 16 Oct 2012 00:55:20 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC 1/6 v3] gpio: Add a block GPIO API to gpiolib
References: <1350069085-13283-1-git-send-email-stigge@antcom.de> <1350069085-13283-2-git-send-email-stigge@antcom.de> <507B9D05.1000204@gmail.com> <507C45EF.7080203@antcom.de> <507C888C.7040903@gmail.com>
In-Reply-To: <507C888C.7040903@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 16/10/12 00:05, Ryan Mallon wrote:
>>> This looks broken. If gbc was re-alloced above (index < 0) then
>>> gbc->remap == NULL and this will oops?
>>
>> No, because I took care that even though index can be < 0, the resulting
>> pointer is never dereferenced for -1.
> 
> Ah, I see. I think its a bit non-obvious and flaky though, since it
> looks like you are both dereferencing a potentially NULL pointer, and
> indexing an array with -1.
> 
> Even changing it to this I think makes it a bit more clear:
> 
> 	if (gbc->remap == 0 ||
>             bit - i != gbc->remap[gbc->nremap - 1].offset)
> 		gbc->nremap++;
> 		gbc->remap = krealloc(...);
> 		...
> 
> If you want to keep your way, at the very least I think it deserves a
> comment, since it is easy to misread.

Yes, commenting it now.

Note that it's rather out-of-bounds than NULL pointer. (But with similar
results, though. ;-) )

>> For this, the current API is working fine, even enabling userland access
>> via sysfs.
> 
> Fair enough. I didn't see the first round of patches. You probably can
> still use for_each_set_bit though (maybe convert the mask to unsigned
> long first to match the bitops API):
> 
> 	for_each_set_bit(j, &gbc->mask, BITS_PER_LONG)
> 		...

Thanks for the hint! Useful.

Roland
