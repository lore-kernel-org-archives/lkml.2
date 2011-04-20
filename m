Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1DTH34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 03:29:56 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49659 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1DTH3y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 03:29:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N75LWYD2olyfTxEFL+V6xeiBU0I3zs3dzZbCsBUrPkvo1bnwg799VXe2UomjW4Ka66
         arYlUyKtLR0AKPi9D8OAiV0yOir1Q2bNjsSEtPYl5UZtmlZIh9zUJyWXMqRchSo3pG8t
         7Hy9BetQ3ksKHygtuCqB+Xt39zwkia3WUK/bg=
MIME-Version: 1.0
In-Reply-To: <op.vt76hofg3ri7v4@arend-laptop>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
	<201104171938.12834.arnd@arndb.de>
	<op.vt6ufu1n3ri7v4@arend-laptop>
	<201104191635.40351.arnd@arndb.de>
	<op.vt76hofg3ri7v4@arend-laptop>
Date: Wed, 20 Apr 2011 09:29:53 +0200
Message-ID: <BANLkTinMe-KedeOAiQYES-LCC2O4BoE28w@mail.gmail.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>, George Kashperko <george@znau.edu.ua>,
        Hauke Mehrtens <hauke@hauke-m.de>, Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        Greg KH <greg@kroah.com>, Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/20 Arend van Spriel <arend@broadcom.com>:
> On Tue, 19 Apr 2011 16:35:40 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
>
>> On Tuesday 19 April 2011, Arend van Spriel wrote:
>>
>>> > A new bus_type really only makes sense if you expect a lot of devices
>>> > to use this and you want to have the probing in the bus. If you only
>>> > want to have a way to enumerate devices that get created by the
>>> > parent driver, you can also use platform devices.
>>>
>>> The main assumption of the (bcm)axi driver seems to be that each core can
>>> be considered as a device. Correct me if I am wrong, but I consider a
>>> device to be an entity providing a particular system function. So an
>>> ethernet device provides ethernet connectivity function, a mixer device
>>> provides sound mixing function, and so on. The cores within a chip are
>>> not
>>> always self-contained like this. To clarify let's say a system function
>>> is
>>> realized by programming core A, core B, and finally trigger core A to set
>>> the function in motion. This implies the need of coordination between the
>>> programming steps on those cores.
>>>
>>> Is my view on what is a device wrong? Does a platform device differ in
>>> this respect from a regular device?
>>
>> A platform device means something that cannot be probed, in every other
>> respect it is the same as other devices. From your explanation above,
>> it seems that you don't actually need to represent the cores on your
>> particular chips as struct device in Linux at all.
>>
>> If you wanted to use platform_device, the right way would probably
>> be an MFD device that creates multiple child devices (which end
>> up as platform_device, though you don't need to worry about that)
>> from the PCI driver. Then you could use the child devices completely
>> independent from one another.
>>
>> Since you say that the cores in this case are tightly coupled and
>> don't provide independent functionality to the system, there is
>> no need to represent them as devices.
>
> Hi Arnd,
>
> The case is a hypothetical one, but I consider it a likely one. The axi bus
> driver currently registers each detected core as a device in the linux
> device tree. My statement is that this implies loose or no coupling between
> those cores, which is not true. One (or two) exceptions have already been
> identified. I would expect your last line to read: ...to the system, those
> cores should not be represented as devices.

I do not register that exceptional devices in my code.

-- 
Rafał
