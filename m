Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab0CWWf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 18:35:29 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:53351 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab0CWWf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 18:35:27 -0400
MIME-Version: 1.0
In-Reply-To: <4BA913FB.1000508@synaptics.com>
References: <1269310058-10894-1-git-send-email-cheiny@synaptics.com>
	 <d6200be21003222004g2e2a1000ja65fc3f80f9fad78@mail.gmail.com>
	 <4BA913FB.1000508@synaptics.com>
Date: Tue, 23 Mar 2010 15:35:27 -0700
Message-ID: <d6200be21003231535w3cf9ff30w316f3447f3631689@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] input/touchscreen: Synaptics Touchscreen Driver
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Input <linux-input@vger.kernel.org>,
       Allie Xiong <axiong@synaptics.com>,
       William Manson <WManson@synaptics.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/23 Christopher Heiny <cheiny@synaptics.com>:
> On 03/22/2010 08:04 PM, Arve Hjønnevåg wrote:
>>
>> On Mon, Mar 22, 2010 at 7:07 PM, Christopher Heiny<cheiny@synaptics.com>
>>  wrote:
>> ...
>>>
>>> There are two existing drivers for similar Synaptics devices in the
>>> current kernel tree (excluding the PS/2 touchpad driver).  These are:
>>>
>>> ./linux-2.6/drivers/input/mouse/synaptics_i2c.c
>>>      A driver for the Exeda 15mm touchpad, written by Mike Rapoport
>>>      <mike@compulab.co.il>  and Igor Grinberg<grinberg@compulab.co.il>
>>>
>>> ./linux-2.6/drivers/staging/dream/synaptics_i2c_rmi.c
>>>      A driver for the HTC Dream ClearPad, written by Arve Hjønnevåg
>>>      <arve@android.com>
>>>
>>> We have not extended these drivers for a couple of reasons.  First, the
>>> two drivers are specific to particular Synaptics products, and it is our
>>> desire to produce a general solution that takes advantage of the 'self
>>> describing' features of products that use the RMI protocol.
>>>
>>
>> Do you plan to add platform data to align the reported touchscreen
>> data with the screen behind it, or do the new hardware allow the the
>> firmware handle this? In the past we even needed separate parameters
>> for different firmware versions (seen in
>> drivers/staging/dream/synaptics_i2c_rmi.h).
>
> Hi Arve,
>
> RMI4 touchscreens allow adjustment of the reported coordinate range (see the
> F11_2D_Ctrl6..9 registers, page 48 of the current version of the spec at
> http://www.synaptics.com/developers/manuals).  Using this feature, the
> device can be configured to report the same number of positions on each axis
> as there are pixels on the display.
>

This does not help aligning the touchscreen values with the screen
behind it. It just moves the linear scaling from userspace (which can
use fixed or floating point values to preserve subpixel precision) to
the firmware.

> We plan to make these settings accessible via sysfs, so that it can be
> dynamically tweaked if the user changes the display resolution (not likely
> on a phone, probable on a tablet/slate/ereader type device). Assuming there
> are no significant issues with our current patch, we plan to include that in
> the next one.  We're holding off that implementation because we're still
> finding our feet on the submission process, and wanted to keep the initial
> submits small so changes would be more manageable.

You could also post a patch series instead of one patch.

>
> Coordinate rotation/reflection settings will be handled at the driver level,
> again via sysfs.
>
Do you also have a plan to let the userspace know that touchscreen
coordinate x1,y1 correspond to screen coordinate 0,0 and x2,y2
correspond to screen coordinate xmax,ymax? The android driver sets
absmin/max to the values reported when touching the display edges (not
the actual min and max that the touchscreen can report), but other
solutions are also possible.

> These features should be independent of the touchscreen firmware level.

In the past they have depended on the firmware version for two
reasons. On one product, firmware changes to improve the edges of the
screen completely changed the relationship between values reported and
the physical touch location. On another product, the physical size of
the sensor changed, and the firmware version was used to detect this.
If all RMI4 based product allow field updates of the firmware the
first case it less important, but we still need to cover the second
case.

>  Initial settings for these features should probably be done at the platform
> level.
>
>                                        Chris
>



-- 
Arve Hjønnevåg
