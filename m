Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab1FETa7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 15:30:59 -0400
Received: from netrider.rowland.org ([192.131.102.5]:53485 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756230Ab1FETa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 15:30:57 -0400
Date: Sun, 5 Jun 2011 15:30:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Keshava Munegowda <keshava_mgowda@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        <tony@atomide.com>, <khilman@ti.com>, <b-cousson@ti.com>,
        <paul@pwsan.com>
Subject: Re: [PATCH 4/4] mfd: global Suspend and resume support of ehci and
 ohci
In-Reply-To: <20110605185047.GB18731@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1106051519560.5916-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jun 2011, Felipe Balbi wrote:

> > > good point. BTW, do we need this #ifdef CONFIG_PM stuff which has been
> > > popping on most drivers recently ? To me it looks like driver.pm field
> > > is always available even if PM is disabled, so what's the point ? Saving
> > > a few bytes ?
> > 
> > Basically, yes (you may want to avoid defining the object this points to if
> > CONFIG_PM is unset).
> 
> wouldn't it look nicer to have a specific section for dev_pm_ops which
> gets automatically freed if CONFIG_PM isn't set ? I mean, there are a
> few drivers which don't have the ifdeferry around dev_pm_ops anyway.
> 
> So, something like:
> 
> #define __pm_ops	__section(.pm.ops)
> 
> static const struct dev_pm_ops my_driver_pm_ops __pm_ops = {
> 	.suspend	= my_driver_suspend,
> 	.resume		= my_driver_resume,
> 	[ blablabla ]
> };
> 
> to simplify things, you could:
> 
> #define DEFINE_DEV_PM_OPS(_ops)		\
> 	const struct dev_pm_ops _ops __pm_ops
> 
> that would mean changes to all linker scripts, though and a utility call
> that only does anything ifndef CONFIG_PM to free the .pm.ops section.

In my opinion this would make programming harder, not easier.  It's
very easy to understand "#ifdef" followed by "#endif"; people see them
all the time.  The new tags you propose would force people to go
searching through tons of source files to see what they mean, and then
readers would still have to figure out when these tags should be used
or what advantage they might bring.

It's a little like "typedef struct foo foo_t;" -- doing this forces
people to remember one extra piece of information that serves no real
purpose except perhaps a minimal reduction in the amount of typing.  
Since the limiting factor in kernel programming is human brainpower,
not source file length, this is a bad tradeoff.  (Not to mention that
it also obscures an important fact: A foo_t is an extended structure
rather than a single value.)

Alan Stern

