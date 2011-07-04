Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab1GDNDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 09:03:12 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:46809 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab1GDNDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 09:03:11 -0400
Message-ID: <4E11B9F7.5080606@atmel.com>
Date: Mon, 04 Jul 2011 15:02:47 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        hong.xu@atmel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] MTD: atmel_nand: optimize read/write buffer	functions
References: <1309261856-27402-1-git-send-email-nicolas.ferre@atmel.com> <20110628111043.GH6588@pengutronix.de> <20110628145937.GG21898@n2100.arm.linux.org.uk> <4E0B2427.9020202@atmel.com> <20110629133124.GO21898@n2100.arm.linux.org.uk>
In-Reply-To: <20110629133124.GO21898@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 29/06/2011 15:31, Russell King - ARM Linux :
> On Wed, Jun 29, 2011 at 03:09:59PM +0200, Nicolas Ferre wrote:
>> Le 28/06/2011 16:59, Russell King - ARM Linux :
>>> I think you need to read Documentation/bus-virt-phys-mapping.txt,
>>> particularly the part after "NOTE NOTE NOTE".
>>>
>>> Dereferencing ioremap'd memory is not permitted.  That includes passing
>>> it to memcpy.  Even with a cast.
>>
>> So that means that I should use memcpy_fromio() even if the code if far
>> less optimized.
>>
>> Shouldn't I re-implement some kind of IO copying function to deal with
>> this IO memory so that I could take advantage of 8 words bursts?
> 
> You could improve the IO memcpy/set etc implementations, which are
> currently mostly unloved - I think that's a catch-22 which really needs
> solving.  They're not efficient because no one has taken the time to use
> them, and everyone's avoiding them because they're not very efficient.
> So, as no one's using them no one's motivated to improve them.

Ok, so I use them in my following patch.

And as a long-term exercise, I will try to have a look at those IO
memcpy/set functions for ARM...

Thanks for you advices, best regards,
-- 
Nicolas Ferre

