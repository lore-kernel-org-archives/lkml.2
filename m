Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab1DTH6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 03:58:04 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4192 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab1DTH6B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 03:58:01 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
To: "Arnd Bergmann" <arnd@arndb.de>
cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "George Kashperko" <george@znau.edu.ua>,
        "Hauke Mehrtens" <hauke@hauke-m.de>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Jonas Gorski" <jonas.gorski@gmail.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "Greg KH" <greg@kroah.com>, "Andy Botting" <andy@andybotting.com>,
        "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom
 bus?
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
 <201104191635.40351.arnd@arndb.de> <op.vt76hofg3ri7v4@arend-laptop>
 <201104200926.09110.arnd@arndb.de>
Date: Wed, 20 Apr 2011 09:57:40 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vt7787f43ri7v4@arend-laptop>
In-Reply-To: <201104200926.09110.arnd@arndb.de>
User-Agent: Opera Mail/11.10 (Linux)
X-WSS-ID: 61B04D393I814050948-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 09:26:08 +0200, Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 20 April 2011 09:16:26 Arend van Spriel wrote:
>> >
>> > A platform device means something that cannot be probed, in every  
>> other
>> > respect it is the same as other devices. From your explanation above,
>> > it seems that you don't actually need to represent the cores on your
>> > particular chips as struct device in Linux at all.
>> >
>> > If you wanted to use platform_device, the right way would probably
>> > be an MFD device that creates multiple child devices (which end
>> > up as platform_device, though you don't need to worry about that)
>> > from the PCI driver. Then you could use the child devices completely
>> > independent from one another.
>> >
>> > Since you say that the cores in this case are tightly coupled and
>> > don't provide independent functionality to the system, there is
>> > no need to represent them as devices.
>>
>> The case is a hypothetical one, but I consider it a likely one. The axi
>> bus driver currently registers each detected core as a device in the  
>> linux
>> device tree. My statement is that this implies loose or no coupling
>> between those cores, which is not true. One (or two) exceptions have
>> already been identified. I would expect your last line to read: ...to  
>> the
>> system, those cores should not be represented as devices.
>
> The important question is what is most practical here. If most of the
> cores of this type are standalone devices, it's probably best to  
> represent
> all of them as separate devices, and find ways to deal with the few  
> logical
> devices that are spread across multiple cores.
> It it's the exception and you typically have a significant number of IP
> blocks that need to be combined to make a single logical device, I would
> recommend not representing each of them as a struct device.
>
> We really need to figure out first what the requirements are given the
> hardware you want to support with this.

Very true. I have forwarded this email conversation to a colleague of mine  
to see whether my hypothesis is likely or rarely true at least for  
Broadcom chipsets. As we concluded that Broadcom seems to be the only one  
currently using this bus that input may be sufficient to determine the  
requirements.

Gr. AvS
-- 
"The world is indeed comic, but the joke is on mankind." — H.P. Lovecraft

