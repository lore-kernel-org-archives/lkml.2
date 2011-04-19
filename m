Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1DSHdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 03:33:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52166 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab1DSHdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:33:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
Date: Tue, 19 Apr 2011 09:32:31 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: John Williams <john.williams@petalogix.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Michal Simek <monstr@monstr.eu>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu> <BANLkTimFnfgiQ5aMq_KwqHP8p92pjOJJwg@mail.gmail.com> <20110419061121.GB5252@ponder.secretlab.ca>
In-Reply-To: <20110419061121.GB5252@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104190932.31777.arnd@arndb.de>
X-Provags-ID: V02:K0:Mcfm6HB4C546mDgBlHLZP0bzXxqt7+/tv8oyeq37AjB
 mrRdzxaOec735q22q3INwJotWOon80xsXOSH4KtL5nzzDMqgnK
 NsJVhkdYT9BwKgenVOI2ZmB9/hLa/RiGeHi29vi4IGE0lw1lZi
 Fityjj8R9muVjP/WCDumyNKOmnU2nikYzOsr0y1ngbifseT+AL
 F1W6xKOfAfvigxeu9xm0w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 April 2011, Grant Likely wrote:
> On Tue, Apr 19, 2011 at 11:58:25AM +1000, John Williams wrote:
> >
> > I know the arguments against the 'generic-uio' tag, but come on, let's
> > look at the lesser of two evils here!  I call BS on this DTS purity.

Both a specific device ID and something like "generic-uio" are
equally broken:

If you have generic-uio, it is impossible to write an in-kernel driver
for the same hardware without changing the device tree, meaning that
it is impossible to correctly describe the hardware in the device tree.

If you put a meaningful identifier into the match table, it is also
impossible to have an in-kernel driver for the hardware, because now
you have no way to choose whether to handle the device with UIO
or an in-kernel driver.

There may be cases where you have two instances of the same device
in a machine and  want one of them to be driven by UIO and the other
by another driver. A common example of this would be a virtual machine
where one device is passed through to the guest and the other is
used by the host. I've done this for USB input devices and PCI network
interfaces.
 
> Call it what you like, but the reasons are well founded.  The alternative
> that has been proposed which I am in agreement with is to investigate
> giving userspace the hook to tell the kernel at runtime which devices
> should be picked up by the uio driver.

Yes, I believe this is the best option.

> In the mean time, explicitly modifying the match table is an okay
> compromise.

Agreed.

	Arnd
