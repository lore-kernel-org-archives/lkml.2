Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab2JKIu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:50:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54979 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab2JKIuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:50:52 -0400
Message-ID: <50768850.7030607@ti.com>
Date: Thu, 11 Oct 2012 14:20:24 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <hs@denx.de>, "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        Constantine Shulyupin <const@MakeLinux.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, Sergei Shtylyov <sshtylyov@mvista.com>,
        Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH] usb: remove CONFIG_USB_MUSB_HOST etc
References: <A73F36158E33644199EB82C5EC81C7BC3E9CA495@DBDE01.ent.ti.com> <507668C3.6080908@denx.de>
In-Reply-To: <507668C3.6080908@denx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 12:05 PM, Heiko Schocher wrote:
> Hello Manjunathappa
> 
> On 11.10.2012 07:42, Manjunathappa, Prakash wrote:
>> Hi,
>> On Mon, Oct 08, 2012 at 18:47:07, Constantine Shulyupin wrote:
>>> From: Constantine Shulyupin<const@MakeLinux.com>
>>>
>>> Remove USB configuration in arch/arm/mach-davinci/usb.c accordingly
>>> CONFIG_USB_MUSB_OTG CONFIG_USB_MUSB_PERIPHERAL CONFIG_USB_MUSB_HOST
>>> and set MUSB_OTG configuration by default
>>> because this configuration options are removed from Kconfig.
>>>
>>> Signed-off-by: Constantine Shulyupin<const@MakeLinux.com>
>>>
>>> ---
>>>   arch/arm/mach-davinci/usb.c |    6 ------
>>>   1 file changed, 6 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
>>> index f77b953..34509ff 100644
>>> --- a/arch/arm/mach-davinci/usb.c
>>> +++ b/arch/arm/mach-davinci/usb.c
>>> @@ -42,14 +42,8 @@ static struct musb_hdrc_config musb_config = {
>>>   };
>>>
>>>   static struct musb_hdrc_platform_data usb_data = {
>>> -#if defined(CONFIG_USB_MUSB_OTG)
>>>       /* OTG requires a Mini-AB connector */
>>>       .mode           = MUSB_OTG,
>>> -#elif defined(CONFIG_USB_MUSB_PERIPHERAL)
>>> -    .mode           = MUSB_PERIPHERAL,
>>> -#elif defined(CONFIG_USB_MUSB_HOST)
>>> -    .mode           = MUSB_HOST,
>>> -#endif
>>>       .clock        = "usb",
>>>       .config        =&musb_config,
>>>   };
>>
>> Tested it on DM6446-EVM for host mode with MSC thumb drive and gadget
>> mode with g-ether. It works.
>>
>> Acked-by: Manjunathappa, Prakash<prakash.pm@ti.com>
> 
> I sent a similiar patch here:
> 
> http://comments.gmane.org/gmane.linux.usb.general/54512
> 
> If the issues, mentioned from Sergei for my patch, nullified I add my:

The last outstanding issue from Sergei seems to be additional comments
describing why MUSB_OTG is OK to use.

Prakash/Constantine,

Did you have to make any hardware changes when testing host/gadget on
DM6446 EVM? Or change in kernel configuration?

It appears that there is no way to choose any of the config option
affecting the mode setting. Right now it seems to be just defaulting to
MUSB_UNDEFINED. Setting it to MUSB_OTG would be better than that.

Thanks,
Sekhar
