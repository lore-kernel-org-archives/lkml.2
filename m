Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1I1Rv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:51:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:6167 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab1I1Rv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:51:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="57630176"
Message-ID: <4E835EBC.3080604@linux.intel.com>
Date: Wed, 28 Sep 2011 10:51:56 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
        Denis Turischev <denis@compulab.co.il>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: Serial issues with EG20T (Topcliff) PCH uarts
References: <4E820FA8.8050604@linux.intel.com> <20110927225722.54936878@lxorguk.ukuu.org.uk>
In-Reply-To: <20110927225722.54936878@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thanks for the suggestions. Still not working, details follow.

On 09/27/2011 02:57 PM, Alan Cox wrote:
>> Using the ti_usb_3410_5052 driver with modified vendor/product strings, I am
>> able to get ttyUSB0 on my host and open it in minicom:
>>
>> $ sudo modprobe ti_usb_3410_5052 vendor_3410=0x0451 product_3410=0x5053
>> $ minicom -D /dev/ttyUSB0
> 
> Please submit those idents to GregKH for the ti_usb driver.
> 

I will. I need to confirm this is something I can do now (if I can use
the product name, etc.).

>> Can anyone offer up some ideas on what I might try to get:
>>
>> 1) the getty working
>> 2) the earlier kernel messages to appear
>> 3) syslinux working
>>
>> over the serial port?
> 
> It may depend a lot on the port. If it boots in PCI D3 (power saved) then
> it's going to be fun. Otherwise forcing the address of the port ought to
> do the trick.
> 
> See	
> 	console=uart8250,io 0xb060,115200n8

I tried:

console=uart8250,io,0xb060,115200n8

With this I got 4 non-ascii chars

> 
> although it's polled so you may want to drop the speed a bit!

I switched all my terminal emulators, syslinux config, the getty, and
console redirection in the bios to use 9600n8. Then ran with:

console=uart8250,io,0xb060,9600n8

This printed several bursts of garbled non-ascii strings, but did so
very early! :)

With minicom on each end, I see the INT 18 count go up by 1 for every
char sent from the board and up by 3 for every char sent from my dev
box, as well as the irregular rx,fe increment mentioned originally.

> 
> netconsole might also be useful to debug the early serial problems !

I did give that a shot, it complained about eth0 not existing, despite
the driver being compiled in. Possibly an init race with netconsole and
pch_gbe? Similar posts sent to linux-next earlier this year.


> 
> No idea for syslinux.

Doesn't like 9600 either.

> 
> Alan

So I'm bugging the hardware/firmware guys, really looks like something
is bad under the covers to me.

Thanks Alan!

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
