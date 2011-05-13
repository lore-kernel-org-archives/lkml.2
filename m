Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab1EMKzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:55:44 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:57965 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492Ab1EMKzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:55:43 -0400
Message-ID: <EAA964D5CCD94B4A9544B294E0CF5099@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Arnd Bergmann" <arnd@arndb.de>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201105102344.58598.arnd@arndb.de> <82D549BB195345A1A189D569952B387C@subhasishg> <201105112203.54838.arnd@arndb.de>
In-Reply-To: <201105112203.54838.arnd@arndb.de>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Fri, 13 May 2011 16:25:56 +0530
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

>>
>> Ok, thanks for the clarification.
>> Instead of passing the device name, will it be ok to pass the mfd_id.
>> The benefit will be that I can use the ID directly as an array
>> index for the mfd_cell entries.
>
> I think a device name would be clearer here, especially in order
> to avoid conflicts when the list gets extended in different ways
> depending on which kernel runs.
>
> We had a little discussion at the Linaro Developer Summit about your
> driver and mfd drivers in general. There was a general feeling among
> some people (including me) that by the point you dynamically create
> the subdevices, MFD is probably not the right abstraction any more,
> as it does not provide any service that you need.
>
> Instead, maybe you can simply call platform_device_register
> at that stage to create the children and not use MFD at all.
>
> Samuel, can you comment on this as well? Do you still see pruss
> as an MFD driver when the uses are completely dynamic and determined
> by the firmware loaded into it?
>

Hi Arnd,

But in that case, where do I fit my driver.
It's a microcontroller inside of a processor, guess that's unique for Linux.
Will a misc device be a better choice.

In that case I can remove the MFD cell from the board_file and add an array
of platform_device for the UART & CAN.

Regarding device register, I will have to implement something similar to
mfd_add_devices and mark the dev->parent.

Did I miss something or will that be fine.



 

