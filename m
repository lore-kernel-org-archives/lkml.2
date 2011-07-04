Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1GDJXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 05:23:31 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:25782 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab1GDJXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 05:23:31 -0400
Message-ID: <4E118679.4090908@atmel.com>
Date: Mon, 04 Jul 2011 11:23:05 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, balbi@ti.com
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        plagnioj@jcrosoft.com, avictor.za@gmail.com
Subject: Re: [PATCH] AT91: add AT91SAM9X5 dummy configuration variable
References: <1309260927-11411-1-git-send-email-nicolas.ferre@atmel.com> <20110628122650.GK2612@legolas.emea.dhcp.ti.com> <4E0B43BA.803@atmel.com> <201107021149.41703.arnd@arndb.de>
In-Reply-To: <201107021149.41703.arnd@arndb.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/07/2011 11:49, Arnd Bergmann :
> On Wednesday 29 June 2011 17:24:42 Nicolas Ferre wrote:
>>> Here are a few questions:
>>> i) The drivers you're willing to send, are those for Atmel's IPs or are
>>>       the IPs sourced from some other company ?
>>> ii) Even if they are Atmel-specific, do you see the possibility of Atmel
>>>       licensing them ?
>>> iii) Does your driver current depend on asm/ or mach/ headers ?
>>> iv) Is there a generic header which you could use instead of asm/ mach/ ?
>>
>> I just want to hide drivers that are not relevant for others: I have the feeling
>> that it is a good practice. This tiny patch will ease this during my publication
>> flow. Do you seriously care?
> 
> I think Felipe is right on this one, but both views are common in the kernel
> today: Some people want dependencies to mean "you cannot build this driver
> unless the dependencies are fulfilled", others like them more broadly to
> mean "there is no point to ever enable this driver because I know you won't
> need it".
> 
> Both views are understandable, but I favor the first one because
> 
> * it's the more common view these days and we should be consistent
> 
> * it exposes drivers to more build testing. If something changes in
>   the kernel that exposes new warnings in your driver or causes a
>   build error, that is more likely to get fixed when more people
>   find it by doing allyesconfig or randconfig builds.
> 
> * If there is an actual build dependency between the driver and the
>   platform that causes you to need the explicit Kconfig depends, that
>   is in many cases a hint that the driver author is doing something
>   wrong, like hardcoding MMIO addresses or referencing custom
>   symbols exported by the platform.
> 
> I don't think anyone really objects your patch to introduce the extra
> Kconfig symbol, but I'd hope that we can eventually get a consensus
> on the idea that you shouldn't use Kconfig dependencies based on
> whether a driver is relevant or not.

Arnd, Felipe,

You have convinced me.
But I will have to remove the other dependencies that I mentioned before
in the thread.

We can drop this patch.

Bye,
-- 
Nicolas Ferre

