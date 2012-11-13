Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab2KMUXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:23:16 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:59032 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab2KMUXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:23:14 -0500
Message-ID: <50A2AC28.7050304@ahsoftware.de>
Date: Tue, 13 Nov 2012 21:23:04 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Till Harbaum <till@harbaum.org>
Subject: Re: [PATCH 1/2] i2c: Add possibility for user-defined (i2c-)devices
 for bus-drivers.
References: <1352829968-4908-1-git-send-email-holler@ahsoftware.de> <20121113195533.6db71716@endymion.delvare>
In-Reply-To: <20121113195533.6db71716@endymion.delvare>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.11.2012 19:55, schrieb Jean Delvare:
> On Tue, 13 Nov 2012 19:06:07 +0100, Alexander Holler wrote:
>> This makes it possible to define i2c-devices at the kernel command line
>> or as a module parameter for bus-drivers which want to offer such
>> an functionality.
>>
>> Drivers which are using it will have the a parameter named
>> devices with format devname1@addr1,devname2@addr2,...
>> e.g. devices=ds1307@0x68,pcf8563@0x51
>
> No, no, no. We did that 10 years ago, killed all the code 3 years ago
> [1], let's not do the same mistake again, please. We have a sysfs
> interface for instantiating clients dynamically from user-space, it's
> way more powerful and flexible than your proposal. Just try plugging two

So how do I define a device, e.g. an RTC which I want to have alive 
before userland starts? Currently imho not possible.

> different i2c-tiny-usb adapters on the same system and see the new code
> instantiate the wrong devices...

I know about that, but it probes and you don't have to use that 
parameter at all. I think some people can think for their self, 
especially those how would use such a parameter.

> [1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=7f508118b1c1f9856a1c899a2bd4867a962b0225

I think my patch looks nicier.

Alexander
