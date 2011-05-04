Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985Ab1EDHSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 03:18:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35895 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1EDHSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 03:18:46 -0400
Message-ID: <2543A75FDDB244D2A148C14BCAA5FD88@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        <nsekhar@ti.com>, "open list" <linux-kernel@vger.kernel.org>,
        <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201104271605.09537.arnd@arndb.de> <CF1FC9DE1796407FB4D636189646927F@subhasishg> <201104280935.38787.arnd@arndb.de>
In-Reply-To: <201104280935.38787.arnd@arndb.de>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Wed, 4 May 2011 12:48:43 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

How about just doing something like:

#> echo da8xx_pruss_uart >> firmware.bin

i.e  just append the device name (from the board file) into the firmware
file.

In the driver probe, we can parse from the bottom, when it reaches
"da8xx_pruss", the rest of the upper data is the firmware and from
the full name, we can determine if it's a CAN, UART or any other
peripheral.

So, based on the platform_data, which the MFD driver received,
it can find out which device to initialize.

Also, does the line wrapping look any better ?


> On Thursday 28 April 2011 09:17:21 Subhasish Ghosh wrote:
>> >
>> > You can easily do that by adding a small header to the firmware
>> > format and interpret that header by the MFD driver. When the name
>> > of the subdevice is part of that header, the MFD driver does not
>> > need to understand the difference, it can simply pass that on
>> > when creating its child devices.
>>
>> I don't understand why loading the firmware should be done at the MFD
>> driver.
>> The user already specifies the device he/she wants to start on the PRU
>> via
>> modprobe.
>> A driver can be inserted, which can download a printer firmware on one
>> PRU
>> and a
>> scanner firmware on the other. This way both cores can be used for
>> separate
>> purposes.
>> I mean, say in a real MFD controller, that will also have two separate
>> cores
>> running on it,
>> just that, the firmware on it would not be downloaded runtime but fused
>> in
>> some non volatile memory.
>
> Then I must be misreading what your code currently does, because it does
> not
> match your explanations. What I see in the platform code is that you
> create
> MFD cells for specific devices that get automatically created by the MFD
> driver. This will cause udev to load the drivers for these devices, which
> then load the firmware they need.
>
> Also, I cannot see how the method you describe would make it possible to
> the same driver into both units, e.g. when you want to have two serial
> ports. The reason is that you currently hardcode the PRU number in the
> driver and that you cannot load a single driver twice.
>
> Finally, I'm trying to make sure that whatever solution you come up with
> will still work when we migrate the code to using a flattened device tree.
> In that case, you would ideally put the device firmware into the device
> tree as a property that matches whatever you have connected on the
> specific
> board (at least as an option, you can still fall back to
> request_firmware).
> You definitely want automatic module loading in that case.
>
> Note that using module loading with specific parameters in order to
> match the hardware is not a recommended procedure any more. The code
> really needs to work the same way when all drivers are built into the
> kernel. It should not be hard to use the firmware loading mechanism
> in the MFD driver to both load the firmware and configure the devices
> appropriately so we always use the right driver for the currently
> active devices.
>
> Arnd
>
> BTW, something is wrong with your email client line wrapping. I've fixed
> this up manually before when replying, but please find a way to get this
> right in the future. 

