Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab0IIR2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:28:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40333 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab0IIR22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 13:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dAFfte39c2lhuKVWlEfQirW8H9EHqD5N1qMjgxWULUzwKxCuSBPJEcCj6sssyZ43Bb
         ljGYNRrewj3WvvplELRO0QFGY4hx9Hfa1CzeBKKXhIarjpycW5438NxfB5AXpYgWHIQg
         gDCIn7zNLKyG5B+zZx3+t9415i3n5d66DfNsw=
MIME-Version: 1.0
In-Reply-To: <20100909060110.GC9098@legolas.emea.dhcp.ti.com>
References: <AANLkTinnHiCodvHrSxiMCAQXAETczRiZ+sDu2aQXSeG0@mail.gmail.com>
	<AANLkTiksb1AudCzs8-TWdXb11T-QcPx1G_qu6eUtJ74C@mail.gmail.com>
	<AANLkTin7eVyosgK4XhuB_yqR2ao=YJGVidHB1x2802cr@mail.gmail.com>
	<AANLkTinrecJXH+uDxtBsskFLpBCz0VSZMtSiWGFW9YCr@mail.gmail.com>
	<AANLkTinkhY-y6Qv6HJnGbggksdEmULgQ9DTOrNmu1tLp@mail.gmail.com>
	<AANLkTikZK=8HCtXDR_2dSBce1E10xNfBtyXGOJqykV83@mail.gmail.com>
	<AANLkTin8bXvPqdkYQq++wf0iCK=ZAfZ2jnqbgL=xj8yq@mail.gmail.com>
	<AANLkTimwMiOfvCpUfeXPSF8zh3t3YsM_8nDZbuWFcKM4@mail.gmail.com>
	<AANLkTimBBRC7-kg_L7FpS1E5i63NPMi08g9rrG=jtWeD@mail.gmail.com>
	<20100909060110.GC9098@legolas.emea.dhcp.ti.com>
Date: Fri, 10 Sep 2010 02:28:27 +0900
Message-ID: <AANLkTin87OTkBrqvStrk61jj8=z75ARBszituZdOQqWE@mail.gmail.com>
Subject: Re: [PATCH] USB: otg: twl4030: fix phy initialization(v1)
From: venki kaps <venkiece2005@gmail.com>
To: balbi@ti.com
Cc: Ming Lei <tom.leiming@gmail.com>, "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <me@felipebalbi.com>, "Gadiyar, Anand" <gadiyar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venkii,

On Thu, Sep 9, 2010 at 3:01 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Sep 08, 2010 at 08:49:08PM -0500, Ming Lei wrote:
>>
>> 2010/9/8 venki kaps <venkiece2005@gmail.com>:
>>
>>>  To resolve the above issue, we have made "PHY power on" in battery
>>> adc on function
>>>  and "PHY power down" in battery adc off function.
>>
>> Good news, the temperature is bad value from battery adc if otg phy is
>> power
>> down. Maybe you only need to power on otg phy before reading battery adc,
>> then
>> power down otg phy after the reading if no usb calbe is connected with
>> musb
>> for decreasing power consumption. (I am not familiar with battery adc,
>> just
>> for your refrerence)
>
> I think you only need the usb3v1 regulator. And it can even be in sleep
> mode, it doens't have to be on. What I would suggest is that usb3v1
> never to be turned off, only .

If usb3v1 put in sleep mode, then
how about VUSB3V1 real activation?
I have tried to put in sleep by using
"twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 1, VUSB_DEDICATED2);"
but still, i have been facing the issue with battery.

one thing i have not understood, why it requires to power down when
the device is booted without
a USB cable?

I have not faced any issue with Kernel 2.6.29 + same hardware
+ the same driver but the problem is facing with Kernel 2.6.32.

I strongly suspecting the problem with PMIC regulator frame work/Power
Management
since in off mode, it is getting very good power results but if system
hits INACTIVE to RETENTION during playback then power numbers will be
more
when it is booted without USB cable.

After booting, just attach/detach the usb cable, then i have not seen
any issue with power numbers in off mode, RETENTION and active states.

> --
> balbi
>
