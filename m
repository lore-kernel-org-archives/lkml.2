Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2IYLHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:07:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39849 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2IYLHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:07:18 -0400
Date: Tue, 25 Sep 2012 12:07:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: "Poddar, Sourav" <sourav.poddar@ti.com>, gregkh@linuxfoundation.org,
        khilman@ti.com, paul@pwsan.com, tony@atomide.com,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
	suspended.
Message-ID: <20120925110703.GN31374@n2100.arm.linux.org.uk>
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com> <CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com> <20120925083029.GG31374@n2100.arm.linux.org.uk> <20120925083118.GI9137@arwen.pp.htv.fi> <20120925091228.GI31374@n2100.arm.linux.org.uk> <20120925091112.GK9137@arwen.pp.htv.fi> <20120925092118.GJ31374@n2100.arm.linux.org.uk> <20120925094815.GL9137@arwen.pp.htv.fi> <20120925102958.GL31374@n2100.arm.linux.org.uk> <20120925103652.GN9137@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925103652.GN9137@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 01:37:03PM +0300, Felipe Balbi wrote:
> On Tue, Sep 25, 2012 at 11:29:58AM +0100, Russell King - ARM Linux wrote:
> > Because you are accusing me of potentially breaking your beagleboard
> > for merely suggesting further investigation and a better commit message.
> 
> Where did I accuse you of anyting ? I just mentioned we experienced a
> regression with beagleboard XM when using pm_runtime_set_active().

I quote:
:> But should we cause a regression to beagleboard XM because of that ?
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I say again: I was _only_ suggesting further investigation, yet you
were mouthing off about causing a regression to beagleboard "because
of that", effectively saying that no, we should not do any further
investigation and this is the only fix.

> To add extra info, here you go:

Finally, something constructive.

> We pinged Paul and asked if he had seen that before, he had no
> pointers... Because Documentation/power/runtime_pm.txt was using a
> mystruct->is_suspended flag, we just decided to follow the same
> "design" since no-one was able to suggest why pm_runtime_set_active()
> was breaking beagleXM nor how it was supposed to actually work.
> 
> Reading the code: pm_runtime_set_active() would tell pm_runtime core
> the device is actually active by setting runtime_status to RPM_ACTIVE,
> thus the following pm_runtime_get_sync() wouldn't actually call
> runtime_resume() callback, but it would increment usage_counter.
> 
> I can't see why this would fail on beagleXM, but it does and we'd like
> to hear in which situations this could fail...

Well, I've just spent five minutes analysing the code paths - which I
hadn't looked at before - and I've pointed out what's probably causing
the problem for Beagle.  I think you owe me an appology over your
aggressive attitude towards my suggestions that there needed to be
some further investigation.
