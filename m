Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1FFJpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:45:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52815 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab1FFJpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:45:36 -0400
Date: Mon, 6 Jun 2011 10:45:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gadiyar@ti.com, sameo@linux.intel.com, parthab@india.ti.com,
        tony@atomide.com, khilman@ti.com, b-cousson@ti.com, paul@pwsan.com
Subject: Re: [PATCH 4/4] mfd: global Suspend and resume support of ehci and
	ohci
Message-ID: <20110606094524.GA23682@sirena.org.uk>
References: <20110605185047.GB18731@legolas.emea.dhcp.ti.com> <Pine.LNX.4.44L0.1106051519560.5916-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106051519560.5916-100000@netrider.rowland.org>
X-Cookie: Edited for television.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 03:30:55PM -0400, Alan Stern wrote:
> On Sun, 5 Jun 2011, Felipe Balbi wrote:

> > that would mean changes to all linker scripts, though and a utility call
> > that only does anything ifndef CONFIG_PM to free the .pm.ops section.

> In my opinion this would make programming harder, not easier.  It's
> very easy to understand "#ifdef" followed by "#endif"; people see them
> all the time.  The new tags you propose would force people to go
> searching through tons of source files to see what they mean, and then
> readers would still have to figure out when these tags should be used
> or what advantage they might bring.

The big advantage is that they make it much harder to introduce random
build breakage and they're an awful lot less fiddly to do - it used to
be not so bad when it was just the function pointers that needed to be
defined to NULL but now we need to faff around with both the functions
and the dev_pm_ops.

The annotation approach is already familiar from the init stuff so it
wouldn't be so hard for people to understand.
