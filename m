Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1D1HQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:16:43 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62043 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1D1HQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:16:42 -0400
Message-ID: <CF1FC9DE1796407FB4D636189646927F@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        <nsekhar@ti.com>, "open list" <linux-kernel@vger.kernel.org>,
        <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201104271516.30951.arnd@arndb.de> <FED5DF6465AF41C58DBD4E0EEB200E60@subhasishg> <201104271605.09537.arnd@arndb.de>
In-Reply-To: <201104271605.09537.arnd@arndb.de>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Thu, 28 Apr 2011 12:47:21 +0530
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

Hi,

>> SG -- It depends upon how the firmware is implemented. If another
>>             firmware is downloaded on it, it will emulate another device.
>>             Also, if a firmware emulated on it supports switching between
>> devices,
>>             that too is possible. Its just a microcontroller, we can do
>> whatever we feel like
>>             with it. Both the PRUs have separate instruction/data ram, so
>> both can be used
>>             to implement two different devices.
>
> I see. So the problem that I see with the current code is that you
> force the system to provide a set of devices from the MFD, which
> then get passed to the individual drivers (uart and can) that load
> the firmware they need. Please correct me if I am reading your code
> wrong.
>
> What I suggest you do instead is to have the request_firmware
> call in the low-level MFD driver, so the user can provide the
> firmware that he/she wants to use, and then the MFD driver will
> create the devices that match the firmware loaded into the device.
>
> You can easily do that by adding a small header to the firmware
> format and interpret that header by the MFD driver. When the name
> of the subdevice is part of that header, the MFD driver does not
> need to understand the difference, it can simply pass that on
> when creating its child devices.

I don't understand why loading the firmware should be done at the MFD 
driver.
The user already specifies the device he/she wants to start on the PRU via 
modprobe.
A driver can be inserted, which can download a printer firmware on one PRU 
and a
scanner firmware on the other. This way both cores can be used for separate 
purposes.
I mean, say in a real MFD controller, that will also have two separate cores 
running on it,
just that, the firmware on it would not be downloaded runtime but fused in 
some non volatile memory. 

