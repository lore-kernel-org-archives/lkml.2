Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab1CWRyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:54:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56694 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab1CWRy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:54:29 -0400
Message-ID: <4D8A33BA.6020501@ti.com>
Date: Wed, 23 Mar 2011 12:54:02 -0500
From: David Anders <x0132446@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <greg@kroah.com>, "andy.green@linaro.org" <andy.green@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "roger.quadros@nokia.com" <roger.quadros@nokia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [RFC] usbnet: use eth%d name for known ethernet devices
References: <4D79F068.2080009@linaro.org> <20110323162251.GA9367@kroah.com> <201103231756.39849.arnd@arndb.de> <201103231813.41776.arnd@arndb.de>
In-Reply-To: <201103231813.41776.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 12:13 PM, Arnd Bergmann wrote:
> On Wednesday 23 March 2011, Arnd Bergmann wrote:
>    
>> --- a/drivers/net/usb/smsc75xx.c
>> +++ b/drivers/net/usb/smsc75xx.c
>> @@ -1244,7 +1244,7 @@ static const struct driver_info smsc75xx_info = {
>>          .rx_fixup       = smsc75xx_rx_fixup,
>>          .tx_fixup       = smsc75xx_tx_fixup,
>>          .status         = smsc75xx_status,
>> -       .flags          = FLAG_ETHER | FLAG_SEND_ZLP,
>> +       .flags          = FLAG_ETHER | FLAG_SEND_ZLP | FLAG_REALLY_ETHER,
>>   };
>>
>>   static const struct usb_device_id products[] = {
>> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
>> index bc86f4b..c98d3a7 100644
>> --- a/drivers/net/usb/smsc95xx.c
>> +++ b/drivers/net/usb/smsc95xx.c
>> @@ -1231,7 +1231,7 @@ static const struct driver_info smsc95xx_info = {
>>          .rx_fixup       = smsc95xx_rx_fixup,
>>          .tx_fixup       = smsc95xx_tx_fixup,
>>          .status         = smsc95xx_status,
>> -       .flags          = FLAG_ETHER | FLAG_SEND_ZLP,
>> +       .flags          = FLAG_ETHER | FLAG_SEND_ZLP | FLAG_REALLY_ETHER,
>>   };
>>
>>      
> These two hunks are from an earlier version of the patch and should not
> be there, they break compilation. I'll wait for more comments and
> then send a fixed version.
>
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>    

tested with 2.6.38 using omap2plus_defconfig with EHCI and smsc95xx 
turned on minus the FLAG_REALLY_ETHER. appears to work properly, assigns 
as eth0.

i ran some basic net tests with no issues.


Dave Anders



