Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0DZUPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:15:01 -0400
Received: from 007.netroom.de ([194.0.247.207]:11131 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab0DZUPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:15:00 -0400
Message-ID: <4BD5F43E.4090404@draisberghof.de>
Date: Mon, 26 Apr 2010 22:14:54 +0200
From: Josua Dietze <digidietze@draisberghof.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: =?UTF-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>,
       Daniel Mack <daniel@caiaq.de>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: USB gadget with drivers "on board"
References: <Pine.LNX.4.44L0.1004261531480.1764-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1004261531480.1764-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern schrieb:

> On Mon, 26 Apr 2010, Josua Dietze wrote:
>> These are the notorious mode switching devices. In Windows, they 
>> obviously install a special storage driver doing one specific action 
>> on each following plugging.
>> This action - some storage or control command - will "flip" the 
>> device, making it "disconnect" and returning as a completely different 
>> composite device.
>>
>> Storage commands used for this procedure range from "SCSI rezero" over 
>> "passthrough" to "SCSI eject", or involve vendor specific stuff.
> 
> I was going to say the same thing.  For ease of use, I recommend using
> a "SCSI eject" to trigger the mode change.  That way, Linux users who
> don't have the usb-modeswitch program installed can get the same effect
> by running eject.


Important for the Linux handling is that "mode 1" is clearly 
distinguishable from "mode 2", either by using a different product ID 
or by setting a different class for the device or interface 0 (will 
most likely be "8" for the install mode).

And it might be a good idea not to re-use any known ID for the install 
mode, like the 05c6:1000 which my Samsung phone and loads of other 
devices are using.
This makes switch handling complicated (though not impossible).


Josua Dietze
