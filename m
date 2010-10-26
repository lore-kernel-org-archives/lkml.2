Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0JZT2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:28:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52823 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab0JZT2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:28:45 -0400
Date: Tue, 26 Oct 2010 20:28:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend] Add sc16is7x2 driver
Message-ID: <20101026192842.GB7119@sirena.org.uk>
References: <4CAD818B.2070603@iis.fraunhofer.de> <20101014190133.GB1009@kroah.com> <4CB801B2.808@iis.fraunhofer.de> <20101015142709.GA18905@kroah.com> <4CB86E8F.3060907@iis.fraunhofer.de> <20101015164922.GB21576@kroah.com> <4CBC177E.8020407@iis.fraunhofer.de> <20101019153748.GB4589@kroah.com> <4CC6977C.1020908@iis.fraunhofer.de> <20101026145107.GA18531@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101026145107.GA18531@kroah.com>
X-Cookie: Honi soit la vache qui rit.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 07:51:07AM -0700, Greg KH wrote:
> On Tue, Oct 26, 2010 at 10:55:24AM +0200, Manuel Stahl wrote:

> > This is the driver I took as a template. It consists of 
> > drivers/serial/max3100.c and include/linux/serial_max3100.h

> > And huh, "grep -R serial_max3100.h *" gives what? Only max3100.c
> > So do we need to remove serial_max3100.h as it's not used anywhere else?

> Yup, that sounds like a great idea, I'll go queue up that patch when I
> get back from my travels at the moment.

Requiring that we have a user for all platform data provided by drivers
would be incredibly painful for embedded development.  It would mean
that we would be unable to usefully merge any drivers with platform data
unless we also merge at least one board using them, meaning that we're
dependant on getting the core board support for some public board into a
state which can be merged (which would at best be likely to end up
creating logjams on support for CPUs).
