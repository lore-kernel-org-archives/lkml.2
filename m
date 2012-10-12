Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946008Ab2JLRaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:30:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54354 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945929Ab2JLRaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:30:10 -0400
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>
CC: Paul Walmsley <paul@pwsan.com>, "Balbi, Felipe" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>
Subject: RE: [RFT/PATCH] serial: omap: prevent resume if device is not
	suspended.
Thread-Topic: [RFT/PATCH] serial: omap: prevent resume if device is not
	suspended.
Thread-Index: AQHNqJiMypEPhS/kwEGE7JP5lODSkZe16FHt
Date: Fri, 12 Oct 2012 17:29:55 +0000
Message-ID: <FEB1293C1A07484EA4E9721B32981131CC2362@DBDE01.ent.ti.com>
References: <20120925083029.GG31374@n2100.arm.linux.org.uk>
 <20120925083118.GI9137@arwen.pp.htv.fi>
 <20120925091228.GI31374@n2100.arm.linux.org.uk>
 <20120925091112.GK9137@arwen.pp.htv.fi>
 <20120925092118.GJ31374@n2100.arm.linux.org.uk>
 <CAKdam57bpTJ94Gn=mKVw1Fm-76fVPp3DGjFuNu_HfesybM1hPg@mail.gmail.com>
 <87ipas2y4h.fsf@deeprootsystems.com>
 <alpine.DEB.2.00.1210111748010.5736@utopia.booyaka.com>
 <50784458.9080806@ti.com>
 <877gqv7imt.fsf@deeprootsystems.com>,<20121012164202.GQ28061@n2100.arm.linux.org.uk>
In-Reply-To: <20121012164202.GQ28061@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.52]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,
________________________________________
From: Russell King - ARM Linux [linux@arm.linux.org.uk]
Sent: Friday, October 12, 2012 10:12 PM
To: Kevin Hilman
Cc: Poddar, Sourav; Paul Walmsley; Balbi, Felipe; gregkh@linuxfoundation.org; tony@atomide.com; linux-kernel@vger.kernel.org; Shilimkar, Santosh; linux-serial@vger.kernel.org; linux-omap@vger.kernel.org; linux-arm-kernel@lists.infradead.org; alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not  suspended.

On Fri, Oct 12, 2012 at 09:35:54AM -0700, Kevin Hilman wrote:
> Sourav <sourav.poddar@ti.com> writes:
> > diff --git a/drivers/tty/serial/omap-serial.c
> > b/drivers/tty/serial/omap-serial.c
> > index 6ede6fd..3fbc7f7 100644
> > --- a/drivers/tty/serial/omap-serial.c
> > +++ b/drivers/tty/serial/omap-serial.c
> > @@ -1414,6 +1414,7 @@ static int __devinit serial_omap_probe(struct
> > platform_device *pdev)
> >         INIT_WORK(&up->qos_work, serial_omap_uart_qos_work);
> >
> >         platform_set_drvdata(pdev, up);
> > +       pm_runtime_set_active(&pdev->dev);
>
> NAK.
>
> This will obviously break platforms where the UARTs are not active
> before driver loads.

I thought I had proposed a solution for this issue, which was this
sequence:

        omap_device_enable(dev);
        pm_runtime_set_active(dev);
        pm_runtime_enable(dev);

Yes, I can understand people not liking the omap_device_enable()
there, but I also notice that the email suggesting that never got a
reply either - not even a "I tried this and it doesn't work" or "it
does work".

Sorry for the late reply on this. I tried this sequence and it worked perfectly fine on
panda and beagle. 

As such, it seems this issue isn't making any progress as we had
already established that merely doing a "pm_runtime_set_active()"
before "pm_runtime_enable()" was going to break other platforms.

 I was  trying to analyse your explanations on this and since omap_device_enable is not generally 
recommended,  I was trying to see if anything else can be done to get around this.

I send this patch for N800 testing so  as to see how it behaves. (We are suspecting that there might be
mux setting issue also with N800).   

~Sourav
