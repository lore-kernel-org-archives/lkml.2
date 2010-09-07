Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0IGNdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:33:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40168 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab0IGNdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KeIJYPbhXRLKGdS+G8SS96mzHQc9HUMyjyhpIxlezIRdvo+9DDxSXZkQUvbJH+QCmS
         1gY+6RCqIf/g3Jp65vA6K9yaMsJTbOkWmxA75hR4sGjKlI6/CCT3YhLhKCv9vYPdg2bt
         Uvgh2oUUcAVNnWLqYjD9MKUv1avr9EhCDH8gA=
MIME-Version: 1.0
In-Reply-To: <AANLkTinnHiCodvHrSxiMCAQXAETczRiZ+sDu2aQXSeG0@mail.gmail.com>
References: <AANLkTinnHiCodvHrSxiMCAQXAETczRiZ+sDu2aQXSeG0@mail.gmail.com>
Date: Tue, 7 Sep 2010 21:24:44 +0800
Message-ID: <AANLkTiksb1AudCzs8-TWdXb11T-QcPx1G_qu6eUtJ74C@mail.gmail.com>
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
> Dear USB experts,
>
>  Is the same fix valid for omap3430 + 2.6.32 Kernel?
>
>  I have been facing mp3 playback idle current consumption 20mA more
> after booting without USB cable connected
>  but If USB cable detach and attach happen, then able to hit proper
> values otherwise irrespective of cold/warm reset
>  the current values increases to 20mA.
>
>  with cable,
>      OTG_SYSCONFIG standby mode of operation - SMART idle
>      HSOTGUSB_STANDBY - SMART standby
>
>  without cable,
>        OTG_SYSCONFIG standby mode of operation - SMART idle
>        HSOTGUSB_STANDBY - Active
>
>  Even i have applied  patch but still the same issue.

Are you applying the patch below?

         http://marc.info/?l=linux-omap&m=128378686221264&w=2

The patch(USB: otg: twl4030: fix phy initialization(v1)) above is against
2.6.36-rc3, I don't think you can apply it directly on 2.6.32. And the patch
is introduced to fix the problems caused by

          commit 461c317705eca5cac09a360f488715927fd0a927.

which change is committed into mainline 2.6.36-rc3.

>
>  If i use __twl4030_phy_power(twl, 0) at the end of USB LDO initialization,

If you apply this patch against 2.6.36-rc3, you will find
__twl4030_phy_power(twl, 0)  is always called from .probe
if you don't connect musb with PC via cable when powering on.

>  then able to hit proper values but USB ADC values are getting in correct
>  with Travel adapter (Charger power supply) which means temperature
>  shows 84 instead of 26~30 degrees.
>
>  Queries,
>  -----------
>   - Is Errata 1.164 fix : OTG idle will work on 3430?

No such errata found in ti wetsite, could you give a link?

>   - USBOTG_SUSPEND is enabled in Kernel 32, will it give any impact?

Kernel does not have USBOTG_SUSPEND config option. Do you
mean USB_SUSPEND? If so, it is nothing to do with your issue since
it is only valid for host driver. Also for your case, musb works at
b-idle state.

>   - Is there anything missed from Power management idle path (or)
>    USB OTG controller/Transreceiver driver part?

Maybe with transreceiver part, musb doesn't support runtime pm now.

>
>  Could you please provide the best approach to solve my issue?

Sorry, this patch is not for your issue, as said above.


-- 
Lei Ming
