Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1CYVQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:16:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab1CYVQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:16:00 -0400
Date: Fri, 25 Mar 2011 14:12:46 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        vapier@gentoo.org
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Message-ID: <20110325211246.GA8741@suse.de>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <1300980071-24645-2-git-send-email-jamie@jamieiles.com>
 <201103252112.22520.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103252112.22520.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 09:12:22PM +0100, Arnd Bergmann wrote:
> On Thursday 24 March 2011 16:21:08 Jamie Iles wrote:
> > OTP memory is typically found in some embedded devices and can be
> > used for storing boot code, cryptographic keys and other persistent
> > information onchip.  This patch adds a generic layer that devices can
> > register OTP with and allows access through a set of character
> > device nodes.
> 
> Looks very nice overall, but I have a few minor comments.
> 
> > diff --git a/Documentation/ABI/testing/sysfs-bus-otp b/Documentation/ABI/testing/sysfs-bus-otp
> > new file mode 100644
> > index 0000000..4dbc652
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-bus-otp
> > @@ -0,0 +1,68 @@
> > +What:           /sys/bus/otp/
> > +Date:           March 2011
> > +KernelVersion:  2.6.40+
> > +Contact:        Jamie Iles <jamie@jamieiles.com>
> > +Description:
> > +                The otp bus presents a number of devices where each
> > +		device represents a region or device in the SoC. Each region
> > +		will create a device node which allows the region to be
> > +		written with read()/write() calls and the device on the bus
> > +		has attributes for controlling the redundancy format and
> > +		getting the region size.
> 
> Why is this a bus? You don't have any device matching code or similar,
> and the devices typically are on an existing bus_type (e.g. platform_bus).
> I think it would make more sense to do this as a class.

No, for new things, we want to use busses instead of classes please.
Especially as this does create devices, which are best put on a bus
somewhere.

thanks,

greg k-h
