Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab2DFOfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 10:35:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32863 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab2DFOe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 10:34:59 -0400
Date: Fri, 6 Apr 2012 09:34:55 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        Corentin Chary <corentin.chary@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux acpi <linux-acpi@vger.kernel.org>,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] samsung-laptop: unregister ACPI video module for some
 well known laptops
Message-ID: <20120406143455.GC8666@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Corentin Chary <corentin.chary@gmail.com>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux acpi <linux-acpi@vger.kernel.org>,
	Len Brown <len.brown@intel.com>
References: <20120320163002.GB6811@srcf.ucam.org>
 <1332421699-5315-1-git-send-email-corentincj@iksaif.net>
 <CAHR064hc4AdFUeoO8Szg0FG6CwLK+xauGn9VMJntWV1Gik=ACQ@mail.gmail.com>
 <20120327112105.GA2845@srcf.ucam.org>
 <CAHR064hBVJjmEd=GeGuG-xTg5ONfJTxwqzP88=JABaXFrfiehA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHR064hBVJjmEd=GeGuG-xTg5ONfJTxwqzP88=JABaXFrfiehA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 11:42:18AM +0200, Corentin Chary wrote:
> On Tue, Mar 27, 2012 at 1:21 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Tue, Mar 27, 2012 at 11:11:18AM +0200, Corentin Chary wrote:
> >> Matthew, is this one ok ? I really hope this patch can go in 3.4 so we
> >> don't introduce a regression for old laptops.
> >
> > Yes, I've got this now.
> >
> > Thanks,
> 
> 
> A user just found a DSDT which is broken by this way of doing things
> (this is not really a regression since it was also broken before).
> 
> _BCL contains a wierd "Or (VDRV, 0x02, VDRV)".
> So if you call _BLC once (video.ko will), it set a flag that affect
> the behavior of all backlight related stuff, and it breaks
> samsung-laptop's backlight even if samsung-laptop unload the acpi
> backlight.
> Using acpi_backlight=vendor solves that since it prevents the module
> from being loaded. My previous patch also fix that since it use
> acpi_backlight= mechanism.
> 
> Do you think using acpi_backlight=vendor is a good enought solution
> here ? Should we use my first patch instead ?

I've recently noticed another problem with using acpi_video_unregister()
to disable known broken backlights -- another module might call
acpi_video_register() and make it reappear. i915 does this, so when I
EFI boot the MacBook Pro 8,2 the acpi backlights reappear (under a BIOS
compatible boot the Intel GPU doesn't show up on the bus).

So Corentin's solution does seem like a better way to go, or else
something similar that forces the ACPI video driver to behave as with
acpi_video=vendor.

Seth

