Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab0IGPlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:41:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42267 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476Ab0IGPlu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:41:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CI4zMYJFJdwjm5yvGG116SQ53a/Jk/0PLeH53aM+tz9ratTUqkpiL4ebgjGviNXtN6
         Hk49a0+xXDxl4yKdO/tKg1B3h7euhBTTCPS+X4ksOyNdtrya6/HSdFUmvgqWhIx2yQQG
         ft/J670SI2w3Clu6yAIeFg+kL2Eu4zbKzFymM=
MIME-Version: 1.0
In-Reply-To: <AANLkTin7eVyosgK4XhuB_yqR2ao=YJGVidHB1x2802cr@mail.gmail.com>
References: <AANLkTinnHiCodvHrSxiMCAQXAETczRiZ+sDu2aQXSeG0@mail.gmail.com>
	<AANLkTiksb1AudCzs8-TWdXb11T-QcPx1G_qu6eUtJ74C@mail.gmail.com>
	<AANLkTin7eVyosgK4XhuB_yqR2ao=YJGVidHB1x2802cr@mail.gmail.com>
Date: Tue, 7 Sep 2010 23:40:55 +0800
Message-ID: <AANLkTinrecJXH+uDxtBsskFLpBCz0VSZMtSiWGFW9YCr@mail.gmail.com>
Subject: Re: [PATCH] USB: otg: twl4030: fix phy initialization(v1)
From: Ming Lei <tom.leiming@gmail.com>
To: venki kaps <venkiece2005@gmail.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <me@felipebalbi.com>, Anand Gadiyar <gadiyar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/7 venki kaps <venkiece2005@gmail.com>:
> thanks for your good response.
>
> Venkii,
>
> On Tue, Sep 7, 2010 at 6:54 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>> 2010/9/7 venki kaps <venkiece2005@gmail.com>:
>>> Dear USB experts,
>>>
>>>  Is the same fix valid for omap3430 + 2.6.32 Kernel?
>>>
>>>  I have been facing mp3 playback idle current consumption 20mA more
>>> after booting without USB cable connected
>>>  but If USB cable detach and attach happen, then able to hit proper
>>> values otherwise irrespective of cold/warm reset
>>>  the current values increases to 20mA.
>>>
>>>  with cable,
>>>      OTG_SYSCONFIG standby mode of operation - SMART idle
>>>      HSOTGUSB_STANDBY - SMART standby
>>>
>>>  without cable,
>>>        OTG_SYSCONFIG standby mode of operation - SMART idle
>>>        HSOTGUSB_STANDBY - Active
>>>
>>>  Even i have applied  patch but still the same issue.
>>
>> Are you applying the patch below?
>>
>>         http://marc.info/?l=linux-omap&m=128378686221264&w=2
>>
>> The patch(USB: otg: twl4030: fix phy initialization(v1)) above is against
>> 2.6.36-rc3, I don't think you can apply it directly on 2.6.32. And the patch
>> is introduced to fix the problems caused by
>>
>>          commit 461c317705eca5cac09a360f488715927fd0a927.
>>
>> which change is committed into mainline 2.6.36-rc3.
>  >>> Yes, this patch i have applied.

If you applied the patch, I guess you may see __twl4030_phy_power(twl, 0)
is called from .probe.

If called,  seems your description a little contradictory since you observed
__twl4030_phy_power(twl, 0) may hit proper values, right?

If not called, could you trace the return value of twl4030_usb_linkstat in
twl4030_usb_phy_init?

thanks,

-- 
Lei Ming
