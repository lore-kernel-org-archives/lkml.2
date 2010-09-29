Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0I2Wgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 18:36:50 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34880 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab0I2Wgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 18:36:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=crvuI5hF8t8JEizZleYmxgWxH/KQHHidiGX9SZXOjAAo6AZbRfK+d5xN1sYvHofRvO
         gb1Gmj3656BL+wPvol2IrpOAHmYTn2n0HQHaMWY1F2mGkze0z7hu0YbfKzrOS5M7F7mq
         zWt/tOXfHdev3vehT8eT4OgEEmE4RhDXCSfBU=
MIME-Version: 1.0
In-Reply-To: <AANLkTimBvtwnHmWeT_uEo+ScZtYePKnZYkFEJyOVD5DO@mail.gmail.com>
References: <1285657392-28937-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTimBvtwnHmWeT_uEo+ScZtYePKnZYkFEJyOVD5DO@mail.gmail.com>
Date: Thu, 30 Sep 2010 00:36:48 +0200
Message-ID: <AANLkTins=SXOf_aeokFWwXX0KU1mhUBnPtbznb9xj+4v@mail.gmail.com>
Subject: Re: [PATCH 1/2] DMAENGINE: define a dummy filter function for coh901318
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/29 Dan Williams <dan.j.williams@intel.com>:
> On Tue, Sep 28, 2010 at 12:03 AM, Linus Walleij <linus.walleij@stericsson.com> wrote:
>> All platform data has to be made conditional on
>> as to avoid cluttering the code with other #ifdef:s.
>>
>
> The filter id function assumes that the channel passed in is a
> coh901318 which requires that you are in a mach-u300 build and that no
> other dma driver will ever appear on this platform.  Which may be
> true,

It is... I promise, the platform only has COH901318 and is not being
refined into future derivates with any multi-DMA-engine variants.

Feels a bit over-engineered to take that aspect into account.
Can't we handle it the day we have a platform available with
two or more diverse DMA controllers?

> but it would be safer to look at
> chan->device->dev->platform_data and deduce that it is indeed a
> coh901318 channel before de-referencing private fields.

I read it like you want a patch also patching the filter function to
do this check or am I misreading it?

Right now it atleast has the other theoretical upside (as compared to
having another totally different DMA block): it can support
multiple instances of COH901318:s, handling each a subset of
channels. In this case the filter function will locate the right channel
on the right instance -> elegant.

> Taken further
> if you rewrite the filter_id function in terms of platform_data then
> it could live purely in the arch code and not depend on the driver.
> ...or did you already try this route and hit a snag?

Nah can probably be done, it just feels more elegant to check
the channel ID (in this case a simple number) against the thing
that's actually registered in the driver.

It will be a bigger patch fixing a sort of different problem though,
this will just fix my problem of compiling the platform without
DMA support, which is currently not possible without a lot of
#ifdefs in the platform code.

Yours,
Linus Walleij
