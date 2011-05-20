Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935363Ab1ETFi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:38:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60610 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935321Ab1ETFi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:38:27 -0400
Message-ID: <8B16A22172EC4753AD4E163CBD64C60F@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Arnd Bergmann" <arnd@arndb.de>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Fri, 20 May 2011 11:08:58 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Anything regarding this.

>>> > My whole point has been that you register them from the main pruss 
>>> > driver
>>> > based on run-time data instead of compile-time pre-configured stuff in 
>>> > the
>>> > board file.
>>>
>>> I'm not so sure - if the usage is fixed as a result of the pins on the
>>> device being wired a CAN bus then it seems reasonable to tell the system
>>> about that so it'll stop the user trying to run SPI or something against
>>> it at runtime.
>>
>> I'm mostly worried about the case where the pins are not hardwired for
>> some specific function -- Subhasish was mentioning that these may be
>> implemented using a pluggable extension board and I want to make sure
>> that you are not required to recompile the kernel when changing the
>> extension board.
>>
>> However, you made a good point that in many cases it will be hardwired
>> so it may be valuable to preconfigure this in a way that does not require
>> scripts to set up variables in sysfs when you already know what is there.
>>
>> Note that my suggestion to put the device name into the firmware file
>> covers this case, because you can then simply ship a firmware blob that
>> matches the hardware configuration. Thinking about the future device
>> tree setup, you can even put the firmware blob itself into a property
>> in the device tree file.
>>
>
> I earlier had an implementation where I used a pruss_devices structure
> in the board file.
>
> http://linux.omap.com/pipermail/davinci-linux-open-source/
> 2011-March/022339.html.
>
> We can use this implementation along with the sysfs to load the devices
> runtime. The configs that I have in the board_file for the devices 
> structure, are fixed for a board. To swap the boards, we do not need to
> re-compile the kernel.
>
>
> 
