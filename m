Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935849Ab2JaSJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:09:41 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:27841 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933519Ab2JaSJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:09:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/GB8maWMtOSx37OHelttL5
Date: Wed, 31 Oct 2012 11:09:36 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, "Cousson, Benoit" <b-cousson@ti.com>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121031180935.GL12739@atomide.com>
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com>
 <20121031175219.GH12739@atomide.com>
 <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pantelis Antoniou <panto@antoniou-consulting.com> [121031 11:05]:
> Hi Tony,
> 
> On Oct 31, 2012, at 7:52 PM, Tony Lindgren wrote:
> 
> > * Pantelis Antoniou <panto@antoniou-consulting.com> [121031 10:26]:
> >> It is painless to move the adapter DT devices to arch/arm/mach-omap2
> >> 
> >> However I got bit by the __init at omap_build_device family functions.
> >> If you don't remove it, crashes every time you instantiate a device
> >> at runtime, or you load the cape driver as a module.
> > 
> > Hmm I think you misunderstood me. You only need to create the
> > platform_device under arch/arm/mach-omap2. The device creation
> > happens only at __init, so omap_build_device can stay as __init.
> > The driver itself should be under drivers.
> > 
> > But is this bus on non-device-tree omaps? If not, just make it
> > device tree only.
> > 
> 
> I'm afraid that's not the case. The whole notion of capebus is that
> instantiation of the devices doesn't just happen early at the boot
> sequence.
> 
> It is perfectly valid for a cape to be instantiated via loading
> a module, or by making an override by writing a sysfs file.
> 
> When having the __init there, the function has been long removed
> and you get a crash by calling into the weeds.
> 
> So the sequence is:
> 
> <early boot>       Register the adapter driver.

OK this is always there for the hardware, and done during
the __init and this one should have an omap_device..
 
> <user>             insmod bone-geiger-cape
> <cape-is-matched>  call omap_build_device
> 
> Please look into the capebus patches for the details. 

..but it seems that the devices connected to capebus should
not have anything to do with omap_device and hwmod?

They should only need to use capebus, just like USB devices
use the USB bus and are registered as USB devices.

Anyways, please sort it out with Benoit, Kevin and Paul,
I've added them to cc. Maybe I'm missing something here.

Regards,

Tony
