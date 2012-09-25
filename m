Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2IYKaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:30:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39812 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab2IYKaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:30:14 -0400
Date: Tue, 25 Sep 2012 11:29:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: "Poddar, Sourav" <sourav.poddar@ti.com>, gregkh@linuxfoundation.org,
        khilman@ti.com, paul@pwsan.com, tony@atomide.com,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
	suspended.
Message-ID: <20120925102958.GL31374@n2100.arm.linux.org.uk>
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com> <CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com> <20120925083029.GG31374@n2100.arm.linux.org.uk> <20120925083118.GI9137@arwen.pp.htv.fi> <20120925091228.GI31374@n2100.arm.linux.org.uk> <20120925091112.GK9137@arwen.pp.htv.fi> <20120925092118.GJ31374@n2100.arm.linux.org.uk> <20120925094815.GL9137@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925094815.GL9137@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 12:48:16PM +0300, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Sep 25, 2012 at 10:21:18AM +0100, Russell King - ARM Linux wrote:
> > On Tue, Sep 25, 2012 at 12:11:14PM +0300, Felipe Balbi wrote:
> > > On Tue, Sep 25, 2012 at 10:12:28AM +0100, Russell King - ARM Linux wrote:
> > > > On Tue, Sep 25, 2012 at 11:31:20AM +0300, Felipe Balbi wrote:
> > > > > On Tue, Sep 25, 2012 at 09:30:29AM +0100, Russell King - ARM Linux wrote:
> > > > > > How is this happening?  I think that needs proper investigation - or if
> > > > > > it's had more investigation, then the results needs to be included in
> > > > > > the commit description so that everyone can understand the issue here.
> > > > > > 
> > > > > > We should not be resuming a device which hasn't been suspended.  Maybe
> > > > > > the runtime PM enable sequence is wrong, and that's what should be fixed
> > > > > > instead?  
> > > > > > 
> > > > > > This sequence in the probe() function:
> > > > > > 
> > > > > >         pm_runtime_irq_safe(&pdev->dev);
> > > > > >         pm_runtime_enable(&pdev->dev);
> > > > > >         pm_runtime_get_sync(&pdev->dev);
> > > > > > 
> > > > > > would enable runtime PM while the s/w state indicates that it's disabled,
> > > > > > and then that pm_runtime_get_sync() will want to resume the device.  See
> > > > > > the section "5. Runtime PM Initialization, Device Probing and Removal"
> > > > > > in Documentation/power/runtime_pm.txt, specifically the second paragraph
> > > > > > of that section.
> > > > > 
> > > > > that was tested. It worked in pandaboard but didn't work on beagleboard
> > > > > XM. Sourav tried to start a discussion about that, but it simply died...
> > > > > 
> > > > > In any case, pm_runtime_get_sync() in probe will always call
> > > > > runtime_resume callback, right ?
> > > > 
> > > > Well, if the runtime PM state says it's suspended, and then you enable
> > > > runtime PM, the first call to pm_runtime_get_sync() will trigger a resume
> > > > attempt.  The patch description is complaining about resume events without
> > > > there being a preceding suspend event.
> > > > 
> > > > This could well be why.
> > > 
> > > that's most likely, of course. But should we cause a regression to
> > > beagleboard XM because of that ?
> > 
> > What would cause a regression on beagleboard XM?  I have not suggested
> > any change other than more investigation of the issue and a fuller patch
> > description - yet you're screaming (idiotically IMHO) that mere
> > investigation would break beagleboard.
> > 
> > Well, if it's _that_ fragile, that mere investigation of this issue by
> > someone elsewhere on the planet would break your beagleboard, maybe it
> > deserves to be broken!
> 
> why are you always so over the top like that ? This is just
> counter-productive to say the least.

Because you are accusing me of potentially breaking your beagleboard
for merely suggesting further investigation and a better commit message.

You are the one going over the top, not me.
