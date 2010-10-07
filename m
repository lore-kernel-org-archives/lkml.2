Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0JGSgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:36:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33396 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab0JGSgF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:36:05 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Jiri Slaby <jirislaby@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Date: Fri, 8 Oct 2010 00:05:41 +0530
Subject: RE: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Thread-Topic: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
Thread-Index: ActmTSCN/kwXv02PQp6PbTNSnxRaSAAAGQQw
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21D220@dbde02.ent.ti.com>
References: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com>
 <1286381895-11329-2-git-send-email-pavan_savoy@ti.com>
 <4CACD234.7020900@gmail.com>
 <19F8576C6E063C45BE387C64729E739404AA21CEA1@dbde02.ent.ti.com>
 <4CACF5A7.3010601@gmail.com>
 <19F8576C6E063C45BE387C64729E739404AA21CEC6@dbde02.ent.ti.com>
 <4CAD7DAB.8030209@gmail.com>
 <19F8576C6E063C45BE387C64729E739404AA21D193@dbde02.ent.ti.com>
 <4CAE10C0.9000106@gmail.com>
In-Reply-To: <4CAE10C0.9000106@gmail.com>
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
> Sent: Thursday, October 07, 2010 1:26 PM
> To: Savoy, Pavan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org;
> alan@lxorguk.ukuu.org.uk
> Subject: Re: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
> 
> On 10/07/2010 04:52 PM, Savoy, Pavan wrote:
> > Per-system? I don't understand this.
> > There can be ldisc for each individual TTY, so doesn't that make it per
> device?
> 
> No, you can have only up to NR_LDISCS ldiscs in the system and you have
> to choose one of them to "handle" a particular tty.

Agree.

> IOW, you register an ldisc which is available for everybody then. And it
> cannot have ->private_data since everybody would share this single

However, I would only register a ldisc for a TTY. I agree TTY was not meant
to used in such a way, But it is highly unlike i2c or SPI where the adapter
and the client drivers are separate.
So in that case, since the tty ldisc register required something to pass onto
the tty's open function which is called when the line discipline is actually accessed (i.e ioctl TIOCSETD) and not when /dev/ttyS* is opened.


> ->private_data. Instead everybody comes with their devices as ttys which
> have ->private_data for everybody's data and ->disc_data for you to note
> anything about the (tty) device.
> 
> Am I missing something?

The situation here was to access the UART from a kernel driver. Say we have
a V4L2 FM radio over the UART, How can I write a v4L2 driver? I has to be a 
line discipline driver correct?

Also, I agree on the comment you made that the line discipline ops are singleton
and need not be kmalloc-ed, I am just mentioning what I wished for from the TTY.

> regards,
> --
> js
