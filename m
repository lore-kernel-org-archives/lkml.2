Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934564Ab0EEQEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:04:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59366 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933497Ab0EEQET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:04:19 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: greg <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 5 May 2010 21:34:03 +0530
Subject: RE: [PATCH] drivers: staging: GPS protocol driver for wl128x
Thread-Topic: [PATCH] drivers: staging: GPS protocol driver for wl128x
Thread-Index: AcrsQuYqavZ2mmVdT0WLFH0NSGIRxwAKTFew
Message-ID: <19F8576C6E063C45BE387C64729E7394044E351AA7@dbde02.ent.ti.com>
References: <114054.49943.qm@web94916.mail.in2.yahoo.com>
 <20100505121131.298e9445@lxorguk.ukuu.org.uk>
In-Reply-To: <20100505121131.298e9445@lxorguk.ukuu.org.uk>
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

 
----------------
Thanks & Regards,
Pavan Savoy | x0099669
 
> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Wednesday, May 05, 2010 6:12 AM
> To: Savoy, Pavan
> Cc: greg; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] drivers: staging: GPS protocol driver for wl128x
> 
> On Tue, 4 May 2010 21:55:43 +0530 (IST)
> Pavan Savoy <pavan_savoy@ti.com> wrote:
> 
> > Greg, Alan,
> >
> > Just to complete the circle on N_TI_WL, find below the GPS driver which makes use of the shared transport
> line discipline.
> >
> > This driver provides a TTY line character device to application/middle-ware running on host, as if the
> device is directly connected over UART to a GPS chip.
> 
> This doesn't appear to be a tty device ?

A typo here, I meant "TTY like" character device, and it not certainly a character device.

> 
> > Almost all actions that can be done on a /dev/ttySx can be done on this /dev/tigps device.
> 
> Hardly true. A tty driver has a very precisely defined set of behaviours
> and a lot of ioctls and interfaces your driver doesn't. Our gps
> interfaces are only tty drivers because historically they were plugged
> into serial ports so I'm not sure the 'not a tty' bit actually matters.

Yes. I agree, and hence mentioned almost all.

> Codewise its the same as all the rest - only one instance possible and
> poking around in globals with no visible or documented locking.

Yes, and this is the reason, I posted this patch.
BT and GPS had to communicate over a single UART, and this is the reason the N_TI_WL line discipline exists.
With this sort of architecture, how can I accommodate multi-device support? To avoid this single device limits?

Also, what is that you are exactly looking for regarding locking.
Please suggest.

Thanks.

