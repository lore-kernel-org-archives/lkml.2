Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab0JTHpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 03:45:46 -0400
Received: from smtp.nokia.com ([192.100.122.230]:41804 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab0JTHpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 03:45:44 -0400
Message-ID: <4CBE9E69.6060803@nokia.com>
Date: Wed, 20 Oct 2010 10:46:49 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: ext Felipe Contreras <felipe.contreras@gmail.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>	<1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>	<4CBD9FD5.506@nokia.com> <AANLkTinRRyrXzqEu=u+CCYkmSNGm03SSo1tVG=5_wdpo@mail.gmail.com>
In-Reply-To: <AANLkTinRRyrXzqEu=u+CCYkmSNGm03SSo1tVG=5_wdpo@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2010 07:45:20.0515 (UTC) FILETIME=[BEF97D30:01CB702A]
X-Nokia-AV: Unscannable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 05:33 PM, ext Felipe Contreras wrote:
> Hi Roger,
>
> On Tue, Oct 19, 2010 at 4:40 PM, Roger Quadros<roger.quadros@nokia.com>  wrote:
>>> @@ -843,6 +841,7 @@ config USB_CDC_COMPOSITE
>>>   config USB_G_NOKIA
>>>         tristate "Nokia composite gadget"
>>>         depends on PHONET
>>> +       depends on USB_GADGET_MUSB_HDRC
>>
>> This is wrong. Is there a build problem or run-time problem without this?
>
> Try:
> CONFIG_USB_G_NOKIA=y
> CONFIG_USB_GADGET_MUSB_HDRC=n
>
> At least g_nokia doesn't seem to work correctly on my N900.
>
It won't work on N900 because N900 has MUSB USB gadget controller and it needs 
to be selected somehow while building for N900.

You should set CONFIG_USB_GADGET_MUSB_HDRC to y somewhere else while building 
for N900 and not here because g_nokia is not MUSB specific.

-- 
regards,
-roger
