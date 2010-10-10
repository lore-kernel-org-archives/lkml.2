Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab0JJVTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 17:19:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45825 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0JJVTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 17:19:47 -0400
From: James Hogan <james@albanarts.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2/2] pm_trace: Add sysfs attr for rechecking dev hash.
Date: Sun, 10 Oct 2010 22:19:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-custom+; KDE/4.4.5; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        markgross <markgross@thegnar.org>
References: <201010092334.27808.james@albanarts.com> <201010102047.01950.james@albanarts.com> <20101010204719.GA3388@elf.ucw.cz>
In-Reply-To: <20101010204719.GA3388@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010102219.41793.james@albanarts.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 October 2010 21:47:19 Pavel Machek wrote:
> On Sun 2010-10-10 20:47:01, James Hogan wrote:
> > Hi Pavel,
> > 
> > On Sunday 10 October 2010 19:04:00 Pavel Machek wrote:
> > > Hi!
> > > 
> > > > If the device which fails to resume is part of a loadable kernel
> > > > module it won't be checked at startup against the magic number
> > > > stored in the RTC.
> > > > 
> > > > Add a read-only sysfs attribute /sys/power/pm_trace_dev_hash which
> > > > contains a list of newline separated devices (usually just the one)
> > > > which currently match the last magic number. This allows the device
> > > > which is failing to resume to be found after the modules are loaded
> > > > again.
> > > > 
> > > > --- a/Documentation/power/s2ram.txt
> > > > +++ b/Documentation/power/s2ram.txt
> > > > 
> > > > @@ -49,6 +49,13 @@ machine that doesn't boot) is:
> > > >     device (lspci and /sys/devices/pci* is your friend), and see if
> > > >     you can fix it, disable it, or trace into its resume function.
> > > > 
> > > > +   If no device matches the hash, it may be a device from a loadable
> > > > kernel +   module that is not loaded until after the hash is checked.
> > > > You can check +   the hash against the current devices again after
> > > > more modules are loaded +   using sysfs:
> > > > +
> > > > +	cat /sys/power/pm_trace_dev_hash
> > > > +
> > > 
> > > Yep, but exact semantics of that sysfs file should probably be linked
> > > in the sysfs documentation...
> > > 
> > > 								Pavel
> > 
> > To clarify, do you mean I should link to
> > Documentation/ABI/testing/sysfs-power from
> > Documentation/power/s2ram.txt, or just make sure the syfs file is
> > documented in Documentation/ABI/testing/sysfs-power (which is done in v2
> > of this patch)?
> 
> v2 of the patch is probably ok.
> 
> Also, sysfs should be one entry per file, and strictly speaking, this
> one is not. That may be fine... but as this is debugging facility,
> perhaps it should go to debugfs? Maybe cc gregkh...
> 									Pavel

I thought about the one entry per file issue.
Documentation/filesystems/sysfs.txt says:
> It is noted that it may not be efficient to contain only one
> value per file, so it is socially acceptable to express an array of
> values of the same type.

which appears to cover my use of it as they're all the same type (and 
considering that ideally there will be exactly 1 device listed anyway).

I wonder if I should separate them with spaces rather than newlines too 
(newlines just seemed more appropriate for a variable sized list at the time).

I ackowledge your point that debugfs may be a more appropriate place for it, 
but would that also apply to the pm_trace file?

(gregkh is cc'd)

Thanks
James
