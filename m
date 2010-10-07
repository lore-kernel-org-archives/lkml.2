Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229Ab0JGOww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:52:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51658 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab0JGOwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 10:52:51 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Jiri Slaby <jirislaby@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Date: Thu, 7 Oct 2010 20:22:32 +0530
Subject: RE: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Thread-Topic: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Thread-Index: Actl9XXNVJVDBj74R+eQeI5zEXfoYwAOVbwQ
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21D193@dbde02.ent.ti.com>
References: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com>
 <1286381895-11329-2-git-send-email-pavan_savoy@ti.com>
 <4CACD234.7020900@gmail.com>
 <19F8576C6E063C45BE387C64729E739404AA21CEA1@dbde02.ent.ti.com>
 <4CACF5A7.3010601@gmail.com>
 <19F8576C6E063C45BE387C64729E739404AA21CEC6@dbde02.ent.ti.com>
 <4CAD7DAB.8030209@gmail.com>
In-Reply-To: <4CAD7DAB.8030209@gmail.com>
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




> -----Original Message-----
> From: Jiri Slaby [mailto:jirislaby@gmail.com]
> Sent: Thursday, October 07, 2010 2:59 AM
> To: Savoy, Pavan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org;
> alan@lxorguk.ukuu.org.uk
> Subject: Re: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
> 
> On 10/07/2010 12:36 AM, Savoy, Pavan wrote:
> >>>>> +int st_core_init(struct st_data_s **core_data)
> >>>>> +{
> >>>>> +	struct st_data_s *st_gdata;
> >>>>> +	long err;
> >>>>> +	static struct tty_ldisc_ops *st_ldisc_ops;
> >>>>> +
> >>>>> +	/* populate and register to TTY line discipline */
> >>>>> +	st_ldisc_ops = kzalloc(sizeof(*st_ldisc_ops), GFP_KERNEL);
> >>>>> +	if (!st_ldisc_ops) {
> >>>>> +		pr_err("no mem to allocate");
> >>>>> +		return -ENOMEM;
> >>>>> +	}
> >>>> This can be static structure, you don't need to allocate this on heap.
> >>>> It should be a singleton.
> >>>
> >>> Yes, I got this comment before, but is it just a style issue?
> >>> I want to keep this in heap because some day, I hope TTY ldics have their
> >> own
> >>> private_data, which I can pass around like the tty_struct's data.
> >>> and having them in heap, I plan to keep a reference to ops structure, so
> >> that I
> >>> can pass around and use ops->private_data everywhere ..
> >>
> >> I doubt ldisc ops will ever have ->private_data. What would you need it
> >> for? The ops generally work with ttys which have ->disc_data.
> >
> > Yes, But in this case, I required something which can be set during
> ldisc_register, and can be picked up during tty_open.
> 
> Why? ldiscs are per-system, singletons, not per-device. So you should
> not bind to them any device specific info.


Per-system? I don't understand this.
There can be ldisc for each individual TTY, so doesn't that make it per device?
Or to be even more specific, it makes it per-TTY which is mapped to a particular device, UART/a-set of usb-endpoints etc...

This driver in fact does just that, it is a driver which allows sharing of the TTY by many other drivers (I call it the protocol drivers).

> --
> js
