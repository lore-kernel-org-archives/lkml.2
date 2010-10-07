Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0JGTT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 15:19:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58468 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab0JGTTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 15:19:25 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jiri Slaby <jirislaby@gmail.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Fri, 8 Oct 2010 00:49:07 +0530
Subject: RE: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Thread-Topic: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Thread-Index: ActmU40DQyG/7dB4R/C9+7Q35F8XPAAABnTA
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21D23B@dbde02.ent.ti.com>
References: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com>
	<1286381895-11329-2-git-send-email-pavan_savoy@ti.com>
	<4CACD234.7020900@gmail.com>
	<19F8576C6E063C45BE387C64729E739404AA21CEA1@dbde02.ent.ti.com>
	<4CACF5A7.3010601@gmail.com>
	<19F8576C6E063C45BE387C64729E739404AA21CEC6@dbde02.ent.ti.com>
	<4CAD7DAB.8030209@gmail.com>
	<19F8576C6E063C45BE387C64729E739404AA21D193@dbde02.ent.ti.com>
	<4CAE10C0.9000106@gmail.com>
	<19F8576C6E063C45BE387C64729E739404AA21D220@dbde02.ent.ti.com>
 <20101007203801.1c55a1d3@lxorguk.ukuu.org.uk>
In-Reply-To: <20101007203801.1c55a1d3@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan,
 

> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Thursday, October 07, 2010 2:38 PM
> To: Savoy, Pavan
> Cc: Jiri Slaby; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@driverdev.osuosl.org
> Subject: Re: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
> 
> > The situation here was to access the UART from a kernel driver. Say we have
> > a V4L2 FM radio over the UART, How can I write a v4L2 driver? I has to be a
> > line discipline driver correct?
> 
> Why would you want to ? you can just control it from user space. If you
> did want to drive it from the kernel then an ldisc would be one way to do
> it I guess.

ldisc is the ONLY way to do it, isn't it? Do I have any other option?

The situation was something similar here.
What I was trying to get to is how we can have a per-device context if a driver is just a line discipline driver?

Few months ago, something similar was discussed....
I have 3 sub-devices if you will on a device which is interfaced over UART,
One of them is Bluetooth which requires any UART Bluetooth device to have its
Own line discipline - N_HCI.

Another is FM, which needs to be a V4L2 device.
Now being V4L2 device, I need to access the UART from kernel, but I cannot
since BT would be using it via the N_HCI ldisc.

Coming to what Jiri, was commenting was about the ldisc_ops structure, which
Just needs to be static and not really kmalloc-ed in heap.
I did it because, I imagined some day TTY ldisc drivers had capability to have
It's own per-device context/private_data (in addition to) tty driver_data or
Something like tty ldisc_data would be good.





> Alan
