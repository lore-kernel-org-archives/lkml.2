Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab0HJAMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 20:12:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36064 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab0HJAMi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 20:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=A7OaV6VQMrg72Vfd52naV/NeBTOGoFz0RIYeHH219XfE7RMAFMprIDDtfyep4zklXn
         PLTdq/KDDNe9T3AOFPKbbAE44+8bherZ1LPczQpSAv0g9TmyOtRze5/yqoKkfTaO6PIl
         FZOmCIdpzPM5g28+qwdcL2KxFcOC4Of26Ua3g=
MIME-Version: 1.0
In-Reply-To: <20100809170709.9c16c756.akpm@linux-foundation.org>
References: <AANLkTikjeQ=b7c85R0-yVzSOiMKWbWksnBRiz0wmOaN2@mail.gmail.com> 
	<20100809170709.9c16c756.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 9 Aug 2010 20:12:17 -0400
Message-ID: <AANLkTin-CZx1sX7jPcVmW9TrTEKceZSEKrrL-hDt2CEH@mail.gmail.com>
Subject: Re: gpio-addr-flash warnings on x86/highmem (Re: i386 allmodconfig, 
	current mainline)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 20:07, Andrew Morton wrote:
> On Mon, 9 Aug 2010 19:52:35 -0400 Mike Frysinger wrote:
>> On Mon, Aug 9, 2010 at 19:43, Andrew Morton wrote:
>> > Guys. __What's goin' on out there?
>> >
>> > drivers/mtd/maps/gpio-addr-flash.c: In function 'gpio_flash_probe':
>> > drivers/mtd/maps/gpio-addr-flash.c:212: warning: cast to pointer from integer of different size
>> > drivers/mtd/maps/gpio-addr-flash.c:224: warning: cast to pointer from integer of different size
>>
>> i did get a bug report about this in the past, but honestly i havent
>> gotten around to fixing the issues.  it's been low priority as my
>> understanding is that the warning shows up in configurations where the
>> driver isnt realistically usable.  not making excuses, just laying out
>> the reality of things.
>
> Casting a resource_size_t to a kernel pointer is plain naughty.

i agree now, but when i wrote the driver, i wasnt aware of these
subtleties when dealing with highmem

> I guess an acceptable "fix" would be to disable to offending combinations
> in Kconfig and add a
>
>        BUILD_BUG_ON(sizeof(gpios->start) != sizeof(void *))
>
> to catch stragglers.

if someone wanted to throw that in now, i wouldnt have a problem with it

> But please do fix warnings, if only because the warning storm from
> allmodconfig causes people to miss important warnings in all the noise.

i try to be proactive with warnings that show up for my arch
(Blackfin), but admittedly i can get a little lazy when i'm not
directly affected

i think i should be able to find time before 2.6.36 to send out a
patch for the issue
-mike
