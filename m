Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab0IGSWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 14:22:12 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40377 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab0IGSWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 14:22:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wgLazvIl+7rAcudFbl0aApfXApqP3rz/sbF0UUHvXeR6b10wzLbT8cK7eu3shghPuY
         JEUOFAAO7M6bTJTEwPVUwA9H8rvRdJjjfZw4DR2bCPKjuAtklp+gJ5EN3kGkBTtuy9PM
         nQYupXaWhufl9LMl2LBnI6+DtfxmVYIkQpxF8=
MIME-Version: 1.0
In-Reply-To: <AANLkTikZK=8HCtXDR_2dSBce1E10xNfBtyXGOJqykV83@mail.gmail.com>
References: <AANLkTinnHiCodvHrSxiMCAQXAETczRiZ+sDu2aQXSeG0@mail.gmail.com>
	<AANLkTiksb1AudCzs8-TWdXb11T-QcPx1G_qu6eUtJ74C@mail.gmail.com>
	<AANLkTin7eVyosgK4XhuB_yqR2ao=YJGVidHB1x2802cr@mail.gmail.com>
	<AANLkTinrecJXH+uDxtBsskFLpBCz0VSZMtSiWGFW9YCr@mail.gmail.com>
	<AANLkTinkhY-y6Qv6HJnGbggksdEmULgQ9DTOrNmu1tLp@mail.gmail.com>
	<AANLkTikZK=8HCtXDR_2dSBce1E10xNfBtyXGOJqykV83@mail.gmail.com>
Date: Tue, 7 Sep 2010 23:52:09 +0530
Message-ID: <AANLkTin8bXvPqdkYQq++wf0iCK=ZAfZ2jnqbgL=xj8yq@mail.gmail.com>
Subject: Re: [PATCH] USB: otg: twl4030: fix phy initialization(v1)
From: venki kaps <venkiece2005@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <me@felipebalbi.com>, Anand Gadiyar <gadiyar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venkii,
On Tue, Sep 7, 2010 at 11:45 PM, venki kaps <venkiece2005@gmail.com> wrote:
> Venkii,
> On Tue, Sep 7, 2010 at 9:18 PM, venki kaps <venkiece2005@gmail.com> wrote:
>> Venkii,
>>
>> On Tue, Sep 7, 2010 at 9:10 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>>> 2010/9/7 venki kaps <venkiece2005@gmail.com>:
>>>> thanks for your good response.
>>>>
>>>> Venkii,
>>>>
>>>> On Tue, Sep 7, 2010 at 6:54 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>>>>> 2010/9/7 venki kaps <venkiece2005@gmail.com>:
>>>>>> Dear USB experts,
>>>>>>
>>>>>>  Is the same fix valid for omap3430 + 2.6.32 Kernel?
>>>>>>
>>>>>>  I have been facing mp3 playback idle current consumption 20mA more
>>>>>> after booting without USB cable connected
>>>>>>  but If USB cable detach and attach happen, then able to hit proper
>>>>>> values otherwise irrespective of cold/warm reset
>>>>>>  the current values increases to 20mA.
>>>>>>
>>>>>>  with cable,
>>>>>>      OTG_SYSCONFIG standby mode of operation - SMART idle
>>>>>>      HSOTGUSB_STANDBY - SMART standby
>>>>>>
>>>>>>  without cable,
>>>>>>        OTG_SYSCONFIG standby mode of operation - SMART idle
>>>>>>        HSOTGUSB_STANDBY - Active
>>>>>>
>>>>>>  Even i have applied  patch but still the same issue.
>>>>>
>>>>> Are you applying the patch below?
>>>>>
>>>>>         http://marc.info/?l=linux-omap&m=128378686221264&w=2
>>>>>
>>>>> The patch(USB: otg: twl4030: fix phy initialization(v1)) above is against
>>>>> 2.6.36-rc3, I don't think you can apply it directly on 2.6.32. And the patch
>>>>> is introduced to fix the problems caused by
>>>>>
>>>>>          commit 461c317705eca5cac09a360f488715927fd0a927.
>>>>>
>>>>> which change is committed into mainline 2.6.36-rc3.
>>>>  >>> Yes, this patch i have applied.
>>>
>>> If you applied the patch, I guess you may see __twl4030_phy_power(twl, 0)
>>> is called from .probe.
>>>
>>> If called,  seems your description a little contradictory since you observed
>>> __twl4030_phy_power(twl, 0) may hit proper values, right?
>>
>>  Yes, __twl4030_phy_power(twl, 0) -  the current values are getting
>> proper with or without cable.
>>>
>>> If not called, could you trace the return value of twl4030_usb_linkstat in
>>> twl4030_usb_phy_init?
>> ok, i can do that and update.
>     twl4030_usb_linkstat return value is zero (0) in both
> twl4030_usb_phy_init/twl4030_usb_irq.
 WIth twl4030_usb_phy_init, Everything is fine except battery temperature
 but surprisingly the temperature is fine with PC based usb cable charger and
 the problem is with travel adapter only.

>>> thanks,
>>>
>>> --
>>> Lei Ming
>>>
>>
>
