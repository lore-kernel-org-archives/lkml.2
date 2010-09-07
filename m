Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab0IGNuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:50:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63488 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab0IGNuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:50:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n+JjqExBtX81N/grH7W/Vy28SDlwAoX112NWCyBUmxUaE96gtqVBCkbI6prySovsjD
         mOWWkGOZVAzwWo/1OVCURqOpm/O8txiLwrUvdgyFpSeQjh34Rgr5inEWSR8UxBvu56Rs
         5UnP32qicE6GuXbnjASi5x5R2GAI8eEOY2PSI=
MIME-Version: 1.0
In-Reply-To: <AANLkTiksb1AudCzs8-TWdXb11T-QcPx1G_qu6eUtJ74C@mail.gmail.com>
References: <AANLkTinnHiCodvHrSxiMCAQXAETczRiZ+sDu2aQXSeG0@mail.gmail.com>
	<AANLkTiksb1AudCzs8-TWdXb11T-QcPx1G_qu6eUtJ74C@mail.gmail.com>
Date: Tue, 7 Sep 2010 19:20:06 +0530
Message-ID: <AANLkTin7eVyosgK4XhuB_yqR2ao=YJGVidHB1x2802cr@mail.gmail.com>
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

thanks for your good response.

Venkii,

On Tue, Sep 7, 2010 at 6:54 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> 2010/9/7 venki kaps <venkiece2005@gmail.com>:
>> Dear USB experts,
>>
>>  Is the same fix valid for omap3430 + 2.6.32 Kernel?
>>
>>  I have been facing mp3 playback idle current consumption 20mA more
>> after booting without USB cable connected
>>  but If USB cable detach and attach happen, then able to hit proper
>> values otherwise irrespective of cold/warm reset
>>  the current values increases to 20mA.
>>
>>  with cable,
>>      OTG_SYSCONFIG standby mode of operation - SMART idle
>>      HSOTGUSB_STANDBY - SMART standby
>>
>>  without cable,
>>        OTG_SYSCONFIG standby mode of operation - SMART idle
>>        HSOTGUSB_STANDBY - Active
>>
>>  Even i have applied  patch but still the same issue.
>
> Are you applying the patch below?
>
>         http://marc.info/?l=linux-omap&m=128378686221264&w=2
>
> The patch(USB: otg: twl4030: fix phy initialization(v1)) above is against
> 2.6.36-rc3, I don't think you can apply it directly on 2.6.32. And the patch
> is introduced to fix the problems caused by
>
>          commit 461c317705eca5cac09a360f488715927fd0a927.
>
> which change is committed into mainline 2.6.36-rc3.
  >>> Yes, this patch i have applied.

>>
>>  If i use __twl4030_phy_power(twl, 0) at the end of USB LDO initialization,
>
> If you apply this patch against 2.6.36-rc3, you will find
> __twl4030_phy_power(twl, 0)  is always called from .probe
> if you don't connect musb with PC via cable when powering on.
>
>>  then able to hit proper values but USB ADC values are getting in correct
>>  with Travel adapter (Charger power supply) which means temperature
>>  shows 84 instead of 26~30 degrees.
>>
>>  Queries,
>>  -----------
>>   - Is Errata 1.164 fix : OTG idle will work on 3430?
>
> No such errata found in ti wetsite, could you give a link?
   In Zoom3 git,pm34xx.c file
                        /*
                         * Errata 1.164 fix : OTG autoidle can prevent
                         * sleep. enable/disable iclk over OFF.
                         */
                        cm_rmw_mod_reg_bits(OMAP3430_EN_HSOTGUSB, 0x0,
                                                CORE_MOD, CM_ICLKEN1);

>
>>   - USBOTG_SUSPEND is enabled in Kernel 32, will it give any impact?
>
> Kernel does not have USBOTG_SUSPEND config option. Do you
> mean USB_SUSPEND? If so, it is nothing to do with your issue since
> it is only valid for host driver. Also for your case, musb works at
> b-idle state.
>
   Yes,CONFIG_USB_SUSPEND.

>>   - Is there anything missed from Power management idle path (or)
>>    USB OTG controller/Transreceiver driver part?
>
> Maybe with transreceiver part, musb doesn't support runtime pm now.
>
>>
>>  Could you please provide the best approach to solve my issue?
>
> Sorry, this patch is not for your issue, as said above.
>
>
> --
> Lei Ming
>
