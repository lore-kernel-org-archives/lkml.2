Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829Ab0GOQvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:51:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933754Ab0GOQvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:51:07 -0400
Date: Thu, 15 Jul 2010 09:51:41 -0700
From: Greg KH <gregkh@suse.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Conke Hu <conke.hu@gmail.com>, CoffBeta <coffbeta@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        inux kernel <linux-kernel@vger.kernel.org>,
        ext-jani.1.nikula@nokia.com,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: tq 2440
Message-ID: <20100715165141.GA21272@suse.de>
References: <AANLkTimyBHliUa62qmfja_ke6YTTysiVAtJcZfi8l2gG@mail.gmail.com> <AANLkTil8GE1OguyAfp3XgfJvEmH98yNrlvGAx684a-qL@mail.gmail.com> <20100715163526.GJ29322@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715163526.GJ29322@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 05:35:26PM +0100, Russell King - ARM Linux wrote:
> On Thu, Jul 15, 2010 at 11:16:30PM +0800, Conke Hu wrote:
> > ever notice to the following kernel log?
> > "Device 's3c2440-nand' does not have a release() function, it is
> > broken and must."
> > release() function should be implemented  in the platform_device.
> 
> That's not telling you to provide a release function.  The warning is
> telling you that a device is being unregistered which doesn't have a
> release function.
> 
> Consider this point - maybe it doesn't have a release function because
> it's not supposed to be unregistered?

Heh, well, it is being unregistered, and at that point in time, the
kernel complains.

All kobjects need a release function that actually frees it.  If not,
that is a logic bug.  Please see the Documentation/kobject.txt file for
details.

thanks,

greg k-h
