Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab1CWQYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:24:03 -0400
Received: from kroah.org ([198.145.64.141]:33773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab1CWQYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:24:01 -0400
Date: Wed, 23 Mar 2011 09:22:51 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: andy.green@linaro.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110323162251.GA9367@kroah.com>
References: <4D79F068.2080009@linaro.org>
 <201103231132.02690.arnd@arndb.de>
 <20110323150852.GE6284@kroah.com>
 <201103231712.06184.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103231712.06184.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 05:12:05PM +0100, Arnd Bergmann wrote:
> On Wednesday 23 March 2011, Greg KH wrote:
> > On Wed, Mar 23, 2011 at 11:32:02AM +0100, Arnd Bergmann wrote:
> > > On Wednesday 23 March 2011, Andy Green wrote:
> > > > It's the case for even usbnet, which is using a broken heuristic to 
> > > > decide what to call the interface not even based on vid / pid.
> > > 
> > > I agree that the heuristics in usbnet is less than helpful here,
> > > which among other things leads people to mixing up the two problems
> > > of fixing the device naming and fixing the MAC address assignment.
> > > 
> > > Even though I know Greg disagrees, I'd still prefer sanitising the
> > > rules for the default device name that usbnet assigns.
> > 
> > I'm all for that, but recall, we can't because of previous
> > implementations and past history.  I.e. you will break working systems
> > if you do this.  So we are stuck with what we have at the moment, sorry.
> 
> I would still consider it a bug fix and argue that the number of actual
> people impacted by the current behaviour is much larger than the potential
> number people that might suffer from changing the behavior in an incompatible
> way, given that:
> 
> * The common case for this hardware seems to be to ship with an eeprom
>   with a valid mac address, as identified by the fact that f4e8ab7c
>   "smsc95xx: generate random MAC address once, not every ifup" only recently
>   got into the kernel as a bug fix for the random case, though the driver
>   has been around since 2008.
> 
> * A google search on the term "smsc95xx" find almost exclusively discussions
>   about how to get the device to come up with a proper name on the panda
>   board, and various proposed workarounds.
> 
> * The comment in usbnet.c about this suggests that the intent has always
>   been what is proposed now, it just doesn't match the code:
> 
>            // heuristic:  "usb%d" for links we know are two-host,
>            // else "eth%d" when there's reasonable doubt.  userspace
>            // can rename the link if it knows better.
>                 if ((dev->driver_info->flags & FLAG_ETHER) != 0 &&
>                     (net->dev_addr [0] & 0x02) == 0)
>                         strcpy (net->name, "eth%d");
> 
>   In case of smsc95xx, we *know* that it's ethernet and not two-host,
>   there is no reasonable doubt about this. The code almost makes sense
>   on generic cdc devices, but not for anything else.

Ok, let's fix it up and see who complains :)

thanks,

greg k-h
