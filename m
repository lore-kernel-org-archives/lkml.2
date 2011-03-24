Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569Ab1CXKpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 06:45:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56748 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1CXKpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 06:45:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=cbrGjU+YUZBTUdba5ZUMfKnzKysFJS793n5/setJOkvA/sFwQoZ58Fxs3sWhRSeP+Z
         +tDVxSX1IJV+BxMxmyc4P6THV7lkYJm0z3Vt+FzrboQ5M9x38xwmBCPYihHhjZuIgom3
         +SQXTKqM7Sa0OdTQxRmMEfzfx5LlhIIiKtlIA=
Message-ID: <4D8B20CE.5030101@linaro.org>
Date: Thu, 24 Mar 2011 10:45:34 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        grant.likely@secretlab.ca, netdev@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [RFC] usbnet: use eth%d name for known ethernet devices
References: <4D79F068.2080009@linaro.org> <201103231756.39849.arnd@arndb.de> <4D8A2830.6020706@linaro.org> <201103231811.54290.arnd@arndb.de>
In-Reply-To: <201103231811.54290.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 05:11 PM, Somebody in the thread at some point said:
> On Wednesday 23 March 2011, Andy Green wrote:
>>> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
>>> index bc86f4b..c98d3a7 100644
>>> --- a/drivers/net/usb/smsc95xx.c
>>> +++ b/drivers/net/usb/smsc95xx.c
>>> @@ -1231,7 +1231,7 @@ static const struct driver_info smsc95xx_info = {
>>
>>> -     .flags          = FLAG_ETHER | FLAG_SEND_ZLP,
>>> +     .flags          = FLAG_ETHER | FLAG_SEND_ZLP | FLAG_REALLY_ETHER,
>>
>>>                if ((dev->driver_info->flags&   FLAG_ETHER) != 0&&
>>> +                 ((dev->driver_info->flags&   FLAG_PTP) == 0 ||
>>> +                  (net->dev_addr [0]&   0x02) == 0))
>>>                        strcpy (net->name, "eth%d");
>>
>> So it just takes the approach that all smsc95xx are going to be eth%d?
>
> Right, and all other drivers that are obviously ethernet-only, including
> future drivers.

I moved my tree over to using this patch now, it's working fine on Panda 
/ smsc95xx as one would expect.  Guys with pluggable smsc95xx are going 
to find their device comes as eth%d not usb%d but that seems perfectly 
defensible as how it always should have been.

So, nice job.

-Andy
