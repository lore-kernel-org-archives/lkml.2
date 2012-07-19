Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2GSMV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:21:57 -0400
Received: from 115-188-14-127.jetstream.xtra.co.nz ([115.188.14.127]:62599
	"EHLO SERVER.prisktech.co.nz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751171Ab2GSMVz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:21:55 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Alexey Charkov <alchark@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/1] Add Wondermedia Technologies (wmt) to
 docs/devicetree/vendor-bindings.txt
Thread-Topic: [PATCH 1/1] Add Wondermedia Technologies (wmt) to
 docs/devicetree/vendor-bindings.txt
Thread-Index: AQKYMMxC+/7sfLVv24SJcXAAzrg8wAJQSbLQAtZSvySVcT8RUP//oSgAgADM587//0K6gIAAybKN
Date: Thu, 19 Jul 2012 12:19:28 +0000
Message-ID: <76F764B079F92A4E843589C893D0A022C381202D@SERVER.prisktech.co.nz>
References: <76F764B079F92A4E843589C893D0A022C380F1D4@SERVER.prisktech.co.nz>
	<CABjd4Yyk6XR6RizgcpjCdi2N_+Z2EzTtezbkN9V7r4bAXXjhqA@mail.gmail.com>
	<76F764B079F92A4E843589C893D0A022C381059B@SERVER.prisktech.co.nz>
	<201207191116.27273.arnd@arndb.de>
	<76F764B079F92A4E843589C893D0A022C3811BFD@SERVER.prisktech.co.nz>,<CABjd4YyV6mrdRBXyixz_+ZDi1szNPJMSUNuT80FPySp+43FrTA@mail.gmail.com>
In-Reply-To: <CABjd4YyV6mrdRBXyixz_+ZDi1szNPJMSUNuT80FPySp+43FrTA@mail.gmail.com>
Accept-Language: en-GB, en-NZ, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Charkov [alchark@gmail.com]
Sent: 20 July 2012 00:12
To: Tony Prisk
Cc: Arnd Bergmann; vt8500-wm8505-linux-kernel@googlegroups.com; devicetree-discuss@lists.ozlabs.org; Russell King; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] Add Wondermedia Technologies (wmt) to docs/devicetree/vendor-bindings.txt

2012/7/19 Tony Prisk <linux@prisktech.co.nz>:
> From: Arnd Bergmann [arnd@arndb.de]
> Sent: 19 July 2012 23:16
> To: vt8500-wm8505-linux-kernel@googlegroups.com
> Cc: Tony Prisk; Alexey Charkov; devicetree-discuss@lists.ozlabs.org; Russell King; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH 1/1] Add Wondermedia Technologies (wmt) to docs/devicetree/vendor-bindings.txt
>
> On Thursday 19 July 2012, Tony Prisk wrote:
>> Given that there have been no replies to this thread, and the restart patch has
>> now been accepted using 'wmt' as the vendor namespace - would it be safe to
>> assume we should formalize this in the vendor-bindings.txt?
>>
>> I'd like to try and have basic device tree support added for the next merge
>> window (or this one if it all goes well :) ), but it relies on the vendor binding being
>> formalized.
>
> What about devices that come from via though? Anything that first showed up
> in vt8500 or earlier should probably get a prefix identifying VIA rather
> than WonderMedia.
>
>         Arnd
>
>
> I have no issue with that.
>
> I am mainly concerned with the Wondermedia products at the moment.
>
> Adding device tree support for WM8505 (and WM8650) is my main goal as the WM8650
> currently isn't supported and trying to get another board file added seems unlikely with
> everything moving to device tree. The VT8500 requires additional/different patches and
> as I don't have a vt8500 I can't test them.

I believe that Arnd's point was about the hardware that WonderMedia
chips have inherited from their VIA ancestors, like NAND, SD/MMC,
graphics engine, USB EHCI glue, PWM, PS/2 controller, parts of PMC
etc. Those would be more appropriately named with something
VIA-specific rather than WMT as the vendor prefix (this would apply
for the PWM and the raster engine, which are unchanged between VT8500
and WM8505, to my knowledge).

On the other hand, all of these parts might well be some kind of
licensed third-party design anyway, which makes this whole VIA vs. WMT
a bikeshed discussion mostly. I would personally not feel too guilty
about calling some device that first appeared in a VT8xxx chip 'wmt'
until there's technical reason for different 'compatible' strings
matching different chip versions (VIA age vs. WMT age). So far, we
don't have that need.

Best,
Alexey

-----

The problem is that we do have that need now - as I pointed out the PMC
on the VT8500 should not use the 'wmt,prizm-pmc' compatibility as it isn't
actually compatible. Any time you wanted to modify a bit-field you would
need to check whether you had a VT8500 or WM8xxx.

I appreciate that a lot of the devices are identical, but we do still need to
sort out those devices that aren't and what we're going to do with them.

The framebuffer is a good example - we have two separate drivers, one
for VT8500 and one for WM8xxx.

Regards,
Tony