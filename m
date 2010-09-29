Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab0I2WvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 18:51:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34504 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0I2WvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 18:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SyJZWVLlb1nj/luYUwQ3GYyBdIAQHJ36rvYtGE1BGpqB2GMBMsCpiSkqs50q5OuWVi
         VCXvr59OUdUYYrUERRoyIFwTw19fJ3wUCS4oVR1J3ON9LbRghTYD8lXg9IdXIj6cinbr
         yqbjUiZUHeQX0Nd/WFgap3ydO8eZvxN0D6klY=
MIME-Version: 1.0
In-Reply-To: <AANLkTins=SXOf_aeokFWwXX0KU1mhUBnPtbznb9xj+4v@mail.gmail.com>
References: <1285657392-28937-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTimBvtwnHmWeT_uEo+ScZtYePKnZYkFEJyOVD5DO@mail.gmail.com>
	<AANLkTins=SXOf_aeokFWwXX0KU1mhUBnPtbznb9xj+4v@mail.gmail.com>
Date: Wed, 29 Sep 2010 15:51:17 -0700
X-Google-Sender-Auth: tydDKBuvOCooPuJuOw2SQt9MyKU
Message-ID: <AANLkTinfwtR5MYe5DTnU_bRvVKPt4U-DuYczBW_sX9Yp@mail.gmail.com>
Subject: Re: [PATCH 1/2] DMAENGINE: define a dummy filter function for coh901318
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 3:36 PM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/9/29 Dan Williams <dan.j.williams@intel.com>:
>> On Tue, Sep 28, 2010 at 12:03 AM, Linus Walleij <linus.walleij@stericsson.com> wrote:
>>> All platform data has to be made conditional on
>>> as to avoid cluttering the code with other #ifdef:s.
>>>
>>
>> The filter id function assumes that the channel passed in is a
>> coh901318 which requires that you are in a mach-u300 build and that no
>> other dma driver will ever appear on this platform.  Which may be
>> true,
>
> It is... I promise, the platform only has COH901318 and is not being
> refined into future derivates with any multi-DMA-engine variants.
>
> Feels a bit over-engineered to take that aspect into account.
> Can't we handle it the day we have a platform available with
> two or more diverse DMA controllers?

Yeah, no rush to change it now.

>
>> but it would be safer to look at
>> chan->device->dev->platform_data and deduce that it is indeed a
>> coh901318 channel before de-referencing private fields.
>
> I read it like you want a patch also patching the filter function to
> do this check or am I misreading it?

Yes.

>
> Right now it atleast has the other theoretical upside (as compared to
> having another totally different DMA block): it can support
> multiple instances of COH901318:s, handling each a subset of
> channels. In this case the filter function will locate the right channel
> on the right instance -> elegant.
>
>> Taken further
>> if you rewrite the filter_id function in terms of platform_data then
>> it could live purely in the arch code and not depend on the driver.
>> ...or did you already try this route and hit a snag?
>
> Nah can probably be done, it just feels more elegant to check
> the channel ID (in this case a simple number) against the thing
> that's actually registered in the driver.
>
> It will be a bigger patch fixing a sort of different problem though,
> this will just fix my problem of compiling the platform without
> DMA support, which is currently not possible without a lot of
> #ifdefs in the platform code.

You can add my acked-by to this one and take it through the arch tree.

...but an eventual patch killing a driver specific export and making
the filter function intrinsically safe (i.e. without needing to know
it is a config bool, or that no other dma blocks will show up on this
machine) would be readily accepted.

--
Dan
