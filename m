Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab0DPH5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 03:57:17 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:52373 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757030Ab0DPH5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 03:57:16 -0400
Message-ID: <4BC81859.2080706@ribosome.natur.cuni.cz>
Date: Fri, 16 Apr 2010 09:57:13 +0200
From: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SeaMonkey/2.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       USB list <linux-usb@vger.kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.1: USB camera hung_task_timeout_secs >120 seconds
References: <Pine.LNX.4.44L0.1004141619360.1716-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1004141619360.1716-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Wed, 14 Apr 2010, Maciej Rutecki wrote:
>
>> (Add CCs)
>>
>> Can you check, that eg. 2.6.30 and latest -RC works OK?
>>
>> On wtorek, 13 kwietnia 2010 o 22:07:20 Martin Mokrejs wrote:
>>> Hi,
>>>     I am not certain whether the stacktrace I received is just intentional
>>> to attract developer eyes or whether this is actually a false alarm:
>>> mounting USB mass storage device media always takes a long while.
>>> This is a P4-M laptop with Kouwell 7004 FW/USB2.0 PCMCIA card.
>>> Comments?
>>> Thanks,
>>> martin
>
> If 2.6.34-rc doesn't work, please post a usbmon trace showing what
> happens when the device is plugged in.  Instructions are in
> Documentation/usb/usbmon.txt.

I am unable to reproduce this with any version 2.6.30.10., 2.6.31.12,
2.6.33.1, 2.6.34-rc4-git2. I turned off the camera many times, removed the
PCMCIA card while the USB media was recognized through kernel (not mounted),
no luck. I do use it say once a week and the crash I swa for the first time,
so I am not much optimistic on reproducibility. :(

Could it be related tot he fact that because the laptop has USB1.1 onboard
it loads uhci_hcd first. Eventually when I plugin the PCMCIA card it loads
ehci_hcd and the kernel complains it should have been loaded before?
Is there a way to tell this in /etc/modules.d/somefile ? I fear I have to
compile them into the kernel statically, on this particular setup.

Martin
