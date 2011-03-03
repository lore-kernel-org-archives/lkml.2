Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab1CCQoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:44:21 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:52130 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab1CCQoU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:44:20 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikOhuTzgxxaTK__ZV0rdwTWZaLLrcZ=KTkOOY0=@mail.gmail.com>
References: <AANLkTikcC1o0zM5ChPhhvhbLPtCNzrtUJ7HCNHHGTcaU@mail.gmail.com>
 <AANLkTin121DDb7DNntYvBDNPjHoESpV9X9V5yYjRjtQt@mail.gmail.com> <AANLkTikOhuTzgxxaTK__ZV0rdwTWZaLLrcZ=KTkOOY0=@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 3 Mar 2011 09:43:59 -0700
X-Google-Sender-Auth: apk6jDkYlZEQ6gITEnQbz2T0mzg
Message-ID: <AANLkTimuNad_6n-=TKj1_6C2txu16nDAnrBz2vOe-d01@mail.gmail.com>
Subject: Re: problems with GPIO
To: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Murali K. Vemuri" <vemuri.muralikrishna@gmail.com> wrote:

>hi,
>I am doing a gpio_set_value() to ensure it is an input pin to OMAP.
>I tried my device with and without that, and no difference though.
>any pointers?

Please don't top post on lkml replies.  Put your reply below the text
you're replying to.  Also, don't forget to "reply-all".  You replied
to me personally instead of on-list.

gpio_set_value() is for setting gpio output value, not input.  It
won't have any usefulness for a pin configured for input.

I don't know anything about the specific gpio controller driver that
you're using.  You'll need to read up in the reference manual to
figure out if there is any other SoC configuration that you need to
do.

g.

>
>On Thu, Mar 3, 2011 at 3:24 PM, Grant Likely
><grant.likely@secretlab.ca> wrote:
>> On Thu, Feb 17, 2011 at 9:21 PM, Murali K. Vemuri
>> <vemuri.muralikrishna@gmail.com> wrote:
>>> Hi There,
>>>
>>> I am rather a novice with linux kernel and I have this problem.
>>> My board is  OMAP 3530 based and I use GPIO 21 to detect an external
>>> device plug-in.
>>> Now, when the board is just booted (after a complete power
>disconnect
>>> ), the GPIO is high, and when I plug in my external device, the GPIO
>>> goes low, and I am able to detect it.
>>> However, I see the voltage level still low after I remove the
>external
>>> plug-in, and any further plug-ins, remain un-detected.
>>> My H/W engineers say it is some config I am missing in Kernel.
>>> can someone point me?
>>>
>>> my code snippet is like:
>>>
>>>    omap_mux_init_gpio(MY_GPIO,  OMAP_PIN_INPUT_PULLDOWN  );
>>>    gpio_request(MY_GPIO,"CABLE IN");
>>>    gpio_direction_input(MY_GPIO);
>>>    gpio_set_value(MY_GPIO,1);
>>
>> It depends on the gpio controller driver, but gpio_set_value() is
>very
>> likely switching the GPIO pin from input to output.  Why are you
>> calling gpio_set_value()?
>>
>> g.
>>
