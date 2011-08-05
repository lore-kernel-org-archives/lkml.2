Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab1HEOKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 10:10:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40360 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab1HEOKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 10:10:20 -0400
Subject: Re: Getting notification of PS/2 mouse packages
From: Michael Thayer <michael.thayer@oracle.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110805123605.GA5464@nautilus.holoscopio.com>
References: <1312544155.2426.49.camel@michael-latitude-e6410>
	 <20110805123605.GA5464@nautilus.holoscopio.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ORACLE Deutschland B.V. & Co. KG
Date: Fri, 05 Aug 2011 16:10:07 +0200
Message-ID: <1312553407.2426.62.camel@michael-latitude-e6410>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4E3BF9CB.0078,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-05 at 09:36 -0300, Thadeu Lima de Souza Cascardo wrote:
> On Fri, Aug 05, 2011 at 01:35:55PM +0200, Michael Thayer wrote:
> > I am looking at writing a driver (it is to be open source, but not for
> > mainstream kernel inclusion) for a virtual machine-specific input
> > device.  Unfortunately one of the versions of the device I have to
> > support signals that it has new data available by sending a fake package
> > to the PS/2 mouse, so I need to be able to get notification of that
> > somehow.  Looking at the kernel source, I see that the i8042 driver
> > requests IRQ 12 as IRQF_SHARED, and that the kernel always notifies all
> > registered interrupt handlers of an interrupt, even if one of them
> > returns IRQ_HANDLED.  So it looks like I can just request my own shared
> > handler for IRQ 12 and always return IRQ_NONE, but still update my data.
> > However I am not sure whether this is something I can count on to keep
> > working in future kernel releases.  Does anyone on this list know more
> > about this, or can someone suggest a cleaner way to get the
> > notifications I need?
> [...]
> My advice is: send it for mainline inclusion!
> 
> You more likely get your code reviewed, and it what you do is
> acceptable, it will get included and that's a "OK" for your solution.
> Then, if it turns out it's not OK anymore, it's much more likely people
> will go and fix it for you. At least, that's certainly not going to
> happen if it's not published somehow, but out-of-tree drivers or patches
> do not usually have the attention of Linux developers.
> 
> So, what is it that you consider your work not worth of mainline
> inclusion?

Hello Thadeu,

I suppose that the main reason is that the usual upgrade cycle of new
hardware, new kernel doesn't quite fit to virtual machines, given that
one of their main purposes is to run legacy software.  My driver should
ideally work with any 2.6.x (and now 3.x) kernel, and obviously I can no
longer get it into mainline for say the 2.6.9 kernel shipped with Fedora
Core 3.  Having it in mainline also complicates matters slightly if we
wanted to add new features to the hardware and the driver (we might want
multi-touch sometime) but the kernel in question already ships with an
older version.  I realise that that is not a show-stopper, but it brings
additional complications for relatively little gain.

Obviously we are used to the trade-off of having to put in more
maintenance work, though it isn't as bad as you might think,
particularly compared to the effort of ensuring that new features work
on any random 2.6 kernel (until recently 2.4 as well), including various
hacked distribution kernels.  And these days we often get patches from
users to support new kernel (pre-)releases before we even notice that
something is broken.

Regards,

Michael
-- 
ORACLE Deutschland B.V. & Co. KG   Michael Thayer
Werkstrasse 24                     VirtualBox engineering
71384 Weinstadt, Germany           mailto:michael.thayer@oracle.com

Hauptverwaltung: Riesstr. 25, D-80992 München
Registergericht: Amtsgericht München, HRA 95603

Komplementärin: ORACLE Deutschland Verwaltung B.V.
Hertogswetering 163/167, 3543 AS Utrecht, Niederlande
Handelsregister der Handelskammer Midden-Niederlande, Nr. 30143697
Geschäftsführer: Jürgen Kunz, Marcel van de Molen, Alexander van der Ven

