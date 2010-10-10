Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab0JJUrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 16:47:35 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:59143 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750761Ab0JJUrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 16:47:33 -0400
Date: Sun, 10 Oct 2010 22:47:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Hogan <james@albanarts.com>, Greg KH <greg@kroah.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        markgross <markgross@thegnar.org>
Subject: Re: [PATCH 2/2] pm_trace: Add sysfs attr for rechecking dev hash.
Message-ID: <20101010204719.GA3388@elf.ucw.cz>
References: <201010092334.27808.james@albanarts.com>
 <201010092337.47821.james@albanarts.com>
 <20101010180400.GA19524@elf.ucw.cz>
 <201010102047.01950.james@albanarts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010102047.01950.james@albanarts.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-10-10 20:47:01, James Hogan wrote:
> Hi Pavel,
> 
> On Sunday 10 October 2010 19:04:00 Pavel Machek wrote:
> > Hi!
> > 
> > > If the device which fails to resume is part of a loadable kernel module
> > > it won't be checked at startup against the magic number stored in the
> > > RTC.
> > > 
> > > Add a read-only sysfs attribute /sys/power/pm_trace_dev_hash which
> > > contains a list of newline separated devices (usually just the one)
> > > which currently match the last magic number. This allows the device
> > > which is failing to resume to be found after the modules are loaded
> > > again.
> > > 
> > > --- a/Documentation/power/s2ram.txt
> > > +++ b/Documentation/power/s2ram.txt
> > > 
> > > @@ -49,6 +49,13 @@ machine that doesn't boot) is:
> > >     device (lspci and /sys/devices/pci* is your friend), and see if you
> > >     can fix it, disable it, or trace into its resume function.
> > > 
> > > +   If no device matches the hash, it may be a device from a loadable
> > > kernel +   module that is not loaded until after the hash is checked.
> > > You can check +   the hash against the current devices again after more
> > > modules are loaded +   using sysfs:
> > > +
> > > +	cat /sys/power/pm_trace_dev_hash
> > > +
> > 
> > Yep, but exact semantics of that sysfs file should probably be linked
> > in the sysfs documentation...
> > 								Pavel
> 
> To clarify, do you mean I should link to Documentation/ABI/testing/sysfs-power 
> from Documentation/power/s2ram.txt, or just make sure the syfs file is 
> documented in Documentation/ABI/testing/sysfs-power (which is done in v2 of 
> this patch)?

v2 of the patch is probably ok.

Also, sysfs should be one entry per file, and strictly speaking, this
one is not. That may be fine... but as this is debugging facility,
perhaps it should go to debugfs? Maybe cc gregkh...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
