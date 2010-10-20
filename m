Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059Ab0JTIxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 04:53:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46048 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab0JTIxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 04:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PNkBpBKy78wszKkyB6LpiEEixzVi3nTQP5fog9lYFsZFDRSrm1vSlUc6EIC5WebnV4
         8IKVwuhLNMKkfga+bMqIzT5PuTF9XhcvOA7NKGGHbGwxIjFO3qYqqDDT0ADfkmgoSQCk
         bFooHgOzRA1NWUVMTf3+xcSPikLlCRL0q8Ebg=
MIME-Version: 1.0
In-Reply-To: <4CBE9E69.6060803@nokia.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
	<1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
	<4CBD9FD5.506@nokia.com>
	<AANLkTinRRyrXzqEu=u+CCYkmSNGm03SSo1tVG=5_wdpo@mail.gmail.com>
	<4CBE9E69.6060803@nokia.com>
Date: Wed, 20 Oct 2010 11:53:15 +0300
Message-ID: <AANLkTinOYDBMVZ3ibG3Md7jdOuOC6NkGWaugvHwT6uqF@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
From: "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>
To: Roger Quadros <roger.quadros@nokia.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 10:46 AM, Roger Quadros <roger.quadros@nokia.com> wrote:
> On 10/19/2010 05:33 PM, ext Felipe Contreras wrote:
>> On Tue, Oct 19, 2010 at 4:40 PM, Roger Quadros<roger.quadros@nokia.com>
>>  wrote:
>>>>
>>>> @@ -843,6 +841,7 @@ config USB_CDC_COMPOSITE
>>>>  config USB_G_NOKIA
>>>>        tristate "Nokia composite gadget"
>>>>        depends on PHONET
>>>> +       depends on USB_GADGET_MUSB_HDRC
>>>
>>> This is wrong. Is there a build problem or run-time problem without this?
>>
>> Try:
>> CONFIG_USB_G_NOKIA=y
>> CONFIG_USB_GADGET_MUSB_HDRC=n
>>
>> At least g_nokia doesn't seem to work correctly on my N900.
>>
> It won't work on N900 because N900 has MUSB USB gadget controller and it
> needs to be selected somehow while building for N900.
>
> You should set CONFIG_USB_GADGET_MUSB_HDRC to y somewhere else while
> building for N900 and not here because g_nokia is not MUSB specific.

How do you expect people to know that? The Kconfig should define what
USB_G_NOKIA needs to work, so that people can enable those things
without go Googling hunting for a workable defconfig. Right now people
can build g_nokia modules that don't work, and that shouldn't be
allowed by the Kconfig.

-- 
Felipe Contreras
